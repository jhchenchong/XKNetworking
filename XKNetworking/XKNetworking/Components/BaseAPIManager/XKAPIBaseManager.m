//
//  XKAPIBaseManager.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "XKAPIBaseManager.h"
#import "XKNetworking.h"
#import "XKCacheCenter.h"
#import "XKLogger.h"
#import "XKServiceFactory.h"
#import "XKApiProxy.h"
#import "CTMediator+XKAppContext.h"
#import "XKServiceFactory.h"

NSString * const kXKUserTokenInvalidNotification = @"kXKUserTokenInvalidNotification";
NSString * const kXKUserTokenIllegalNotification = @"kXKUserTokenIllegalNotification";

NSString * const kXKUserTokenNotificationUserInfoKeyManagerToContinue = @"kXKUserTokenNotificationUserInfoKeyManagerToContinue";
NSString * const kXKAPIBaseManagerRequestID = @"kXKAPIBaseManagerRequestID";

@interface XKAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, copy, readwrite) NSString *errorMessage;

@property (nonatomic, readwrite) XKAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, strong, nullable) void (^successBlock)(XKAPIBaseManager *apimanager);
@property (nonatomic, strong, nullable) void (^failBlock)(XKAPIBaseManager *apimanager);

@end

@implementation XKAPIBaseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = XKAPIManagerErrorTypeDefault;
        
        _memoryCacheSecond = 3 * 60;
        _diskCacheSecond = 3 * 60;
        
        if ([self conformsToProtocol:@protocol(XKAPIManager)]) {
            self.child = (id <XKAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)cancelAllRequests {
    [[XKApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [self removeRequestIdWithRequestID:requestID];
    [[XKApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<XKAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

- (NSInteger)loadData {
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

+ (NSInteger)loadDataWithParams:(NSDictionary *)params success:(void (^)(XKAPIBaseManager *))successCallback fail:(void (^)(XKAPIBaseManager *))failCallback {
    return [[[self alloc] init] loadDataWithParams:params success:successCallback fail:failCallback];
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params success:(void (^)(XKAPIBaseManager *))successCallback fail:(void (^)(XKAPIBaseManager *))failCallback {
    self.successBlock = successCallback;
    self.failBlock = failCallback;
    
    return [self loadDataWithParams:params];
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    NSDictionary *reformedParams = [self reformParams:params];
    if (reformedParams == nil) {
        reformedParams = @{};
    }
    if ([self shouldCallAPIWithParams:reformedParams]) {
        XKAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithParamsData:reformedParams];
        if (errorType == XKAPIManagerErrorTypeNoError) {
            
            XKURLResponse *response = nil;
            // 先检查一下是否有内存缓存
            if ((self.cachePolicy & XKAPIManagerCachePolicyMemory) && self.shouldIgnoreCache == NO) {
                response = [[XKCacheCenter sharedInstance] fetchMemoryCacheWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName params:reformedParams];
            }
            
            // 再检查是否有磁盘缓存
            if ((self.cachePolicy & XKAPIManagerCachePolicyDisk) && self.shouldIgnoreCache == NO) {
                response = [[XKCacheCenter sharedInstance] fetchDiskCacheWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName params:reformedParams];
            }
            
            if (response != nil) {
                [self successedOnCallingAPI:response];
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                self.isLoading = YES;
                
                id <XKServiceProtocol> service = [[XKServiceFactory sharedInstance] serviceWithIdentifier:self.child.serviceIdentifier];
                NSURLRequest *request = [service requestWithParams:reformedParams methodName:self.child.methodName requestType:self.child.requestType];
                request.service = service;
                [XKLogger logDebugInfoWithRequest:request apiName:self.child.methodName service:service];
                
                NSNumber *requestId = [[XKApiProxy sharedInstance] callApiWithRequest:request success:^(XKURLResponse *response) {
                    [self successedOnCallingAPI:response];
                } fail:^(XKURLResponse *response) {
                    XKAPIManagerErrorType errorType = XKAPIManagerErrorTypeDefault;
                    if (response.status == XKURLResponseStatusErrorCancel) {
                        errorType = XKAPIManagerErrorTypeCanceled;
                    }
                    if (response.status == XKURLResponseStatusErrorTimeout) {
                        errorType = XKAPIManagerErrorTypeTimeout;
                    }
                    if (response.status == XKURLResponseStatusErrorNoNetwork) {
                        errorType = XKAPIManagerErrorTypeNoNetWork;
                    }
                    [self failedOnCallingAPI:response withErrorType:errorType];
                }];
                [self.requestIdList addObject:requestId];
                
                NSMutableDictionary *params = [reformedParams mutableCopy];
                params[kXKAPIBaseManagerRequestID] = requestId;
                [self afterCallingAPIWithParams:params];
                return [requestId integerValue];
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:XKAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:errorType];
            return requestId;
        }
    }
    return requestId;
}

- (void)successedOnCallingAPI:(XKURLResponse *)response {
    self.isLoading = NO;
    self.response = response;

    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    
    XKAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithCallBackData:response.content];
    if (errorType == XKAPIManagerErrorTypeNoError) {
        
        if (self.cachePolicy != XKAPIManagerCachePolicyNoCache && response.isCache == NO) {
            if (self.cachePolicy & XKAPIManagerCachePolicyMemory) {
                [[XKCacheCenter sharedInstance] saveMemoryCacheWithResponse:response
                                                          serviceIdentifier:self.child.serviceIdentifier
                                                                 methodName:self.child.methodName
                                                                  cacheTime:self.memoryCacheSecond];
            }
            
            if (self.cachePolicy & XKAPIManagerCachePolicyDisk) {
                [[XKCacheCenter sharedInstance] saveDiskCacheWithResponse:response
                                                        serviceIdentifier:self.child.serviceIdentifier
                                                               methodName:self.child.methodName
                                                                cacheTime:self.diskCacheSecond];
            }
        }
        
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformSuccessWithResponse:response]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.successBlock) {
                    self.successBlock(self);
                }
            });
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:errorType];
    }
}

- (void)failedOnCallingAPI:(XKURLResponse *)response withErrorType:(XKAPIManagerErrorType)errorType {
    self.isLoading = NO;
    if (response) {
        self.response = response;
    }
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    // 可以自动处理的错误
    // user token 无效，重新登录
    if (errorType == XKAPIManagerErrorTypeNeedLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kXKUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kXKUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return;
    }
    
    // 可以自动处理的错误
    // user token 过期，重新刷新
    if (errorType == XKAPIManagerErrorTypeNeedAccessToken) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kXKUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kXKUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return;
    }
    
    id<XKServiceProtocol> service = [[XKServiceFactory sharedInstance] serviceWithIdentifier:self.child.serviceIdentifier];
    BOOL shouldContinue = [service handleCommonErrorWithResponse:response manager:self errorType:errorType];
    if (shouldContinue == NO) {
        return;
    }
    
    // 常规错误
    if (errorType == XKAPIManagerErrorTypeNoNetWork) {
        self.errorMessage = @"无网络连接，请检查网络";
    }
    if (errorType == XKAPIManagerErrorTypeTimeout) {
        self.errorMessage = @"请求超时";
    }
    if (errorType == XKAPIManagerErrorTypeCanceled) {
        self.errorMessage = @"您已取消";
    }
    if (errorType == XKAPIManagerErrorTypeDownGrade) {
        self.errorMessage = @"网络拥塞";
    }
    
    // 其他错误
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformFailWithResponse:response]) {
            [self.delegate managerCallAPIDidFailed:self];
        }
        if (self.failBlock) {
            self.failBlock(self);
        }
        [self afterPerformFailWithResponse:response];
    });
}


- (BOOL)beforePerformSuccessWithResponse:(XKURLResponse *)response {
    BOOL result = YES;
    
    self.errorType = XKAPIManagerErrorTypeSuccess;
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(XKURLResponse *)response {
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(XKURLResponse *)response {
    BOOL result = YES;
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(XKURLResponse *)response {
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params {
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

- (void)cleanData {
    self.fetchedRawData = nil;
    self.errorType = XKAPIManagerErrorTypeDefault;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (NSMutableArray *)requestIdList {
    if (!_requestIdList) {
        _requestIdList = @[].mutableCopy;
    }
    return _requestIdList;
}

- (BOOL)isReachable {
    BOOL isReachability = [[CTMediator sharedInstance] XKNetworking_isReachable];
    if (!isReachability) {
        self.errorType = XKAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading {
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

@end
