//
//  XKApiProxy.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "XKApiProxy.h"
#import "XKServiceFactory.h"
#import "XKLogger.h"
#import "NSURLRequest+XKNetworkingMethods.h"
#import "NSString+XKNetworkingMethods.h"
#import "NSObject+XKNetworkingMethods.h"
#import "CTMediator+XKAppContext.h"

static NSString * const kXKApiProxyDispatchItemKeyCallbackSuccess = @"kXKApiProxyDispatchItemCallbackSuccess";
static NSString * const kXKApiProxyDispatchItemKeyCallbackFail = @"kXKApiProxyDispatchItemCallbackFail";

NSString * const kXKApiProxyValidateResultKeyResponseObject = @"kXKApiProxyValidateResultKeyResponseObject";
NSString * const kXKApiProxyValidateResultKeyResponseString = @"kXKApiProxyValidateResultKeyResponseString";

@interface XKApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation XKApiProxy

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XKApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XKApiProxy alloc] init];
    });
    return sharedInstance;
}


- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(XKCallback)success fail:(XKCallback)fail {
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [[self sessionManagerWithService:request.service] dataTaskWithRequest:request
                                                                      uploadProgress:nil
                                                                    downloadProgress:nil
                                                                   completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
                                                                       NSNumber *requestID = @([dataTask taskIdentifier]);
                                                                       [self.dispatchTable removeObjectForKey:requestID];
                                                                       
                                                                       NSDictionary *result = [request.service resultWithResponseObject:responseObject response:response request:request error:error];
                                                                       // 输出返回数据
                                                                       XKURLResponse *XKResponse = [[XKURLResponse alloc] initWithResponseString:result[kXKApiProxyValidateResultKeyResponseString]
                                                                                                                                       requestId:requestID
                                                                                                                                         request:request
                                                                                                                                  responseObject:result[kXKApiProxyValidateResultKeyResponseObject]
                                                                                                                                           error:error];
                                                                       
                                                                       XKResponse.logString = [XKLogger logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                                                                                                                  responseObject:responseObject
                                                                                                                  responseString:result[kXKApiProxyValidateResultKeyResponseString]
                                                                                                                         request:request
                                                                                                                           error:error];
                                                                       
                                                                       if (error) {
                                                                           fail?fail(XKResponse):nil;
                                                                       } else {
                                                                           success?success(XKResponse):nil;
                                                                       }
                                                                   }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (AFHTTPSessionManager *)sessionManagerWithService:(id<XKServiceProtocol>)service {
    AFHTTPSessionManager *sessionManager = nil;
    if ([service respondsToSelector:@selector(sessionManager)]) {
        sessionManager = service.sessionManager;
    }
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    return sessionManager;
}

- (NSMutableDictionary *)dispatchTable {
    if (!_dispatchTable) {
        _dispatchTable = @{}.mutableCopy;
    }
    return _dispatchTable;
}

@end
