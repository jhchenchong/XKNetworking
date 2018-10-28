//
//  Target_H5API.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "Target_H5API.h"
#import "XKApiProxy.h"

typedef void (^XKH5APICallback)(NSDictionary *result);

NSString * const kXKBaseAPITargetAPIContextDataKeyParamsForAPI = @"kXKBaseAPITargetAPIContextDataKeyParamsForAPI";
NSString * const kXKBaseAPITargetAPIContextDataKeyParamsAPIManager = @"kXKBaseAPITargetAPIContextDataKeyParamsAPIManager";
NSString * const kXKBaseAPITargetAPIContextDataKeyOriginActionParams = @"kXKBaseAPITargetAPIContextDataKeyOriginActionParams";

NSString * const kXKOriginActionCallbackKeySuccess = @"success";
NSString * const kXKOriginActionCallbackKeyFail = @"fail";
NSString * const kXKOriginActionCallbackKeyProgress = @"progress";

@interface Target_H5API ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *APIContextDictionary;

@end

@implementation Target_H5API

- (id)Action_loadAPI:(NSDictionary *)params {
    NSDictionary *paramsForAPI = params[@"data"];
    
    if (paramsForAPI == nil) {
        paramsForAPI = @{};
    }
    
    if ([paramsForAPI isKindOfClass:[NSDictionary class]] == NO) {
        return nil;
    }
    
    Class APIManagerClass = NSClassFromString(params[@"apiName"]);
    XKAPIBaseManager *apiManager = [[APIManagerClass alloc] init];
    if ([apiManager isKindOfClass:[XKAPIBaseManager class]]) {
        self.APIContextDictionary[apiManager] = @{
                                                  kXKBaseAPITargetAPIContextDataKeyParamsForAPI:paramsForAPI,
                                                  kXKBaseAPITargetAPIContextDataKeyOriginActionParams:params,
                                                  kXKBaseAPITargetAPIContextDataKeyParamsAPIManager:apiManager
                                                  };
        
        apiManager.delegate = self;
        apiManager.paramSource = self;
        apiManager.interceptor = self;
        [apiManager loadData];
    }
    return nil;
}

- (void)managerCallAPIDidSuccess:(XKAPIBaseManager *)manager {
    XKH5APICallback successCallback = self.APIContextDictionary[manager][kXKBaseAPITargetAPIContextDataKeyOriginActionParams][kXKOriginActionCallbackKeySuccess];
    if (successCallback) {
        NSMutableDictionary *fetchedData = [manager fetchDataWithReformer:nil];
        if ([fetchedData isKindOfClass:[NSMutableDictionary class]]) {
            [fetchedData removeObjectForKey:kXKApiProxyValidateResultKeyResponseString];
        }
        successCallback(fetchedData);
    }
    [self.APIContextDictionary removeObjectForKey:manager];
}

- (void)managerCallAPIDidFailed:(XKAPIBaseManager *)manager {
    XKH5APICallback failCallback = self.APIContextDictionary[manager][kXKBaseAPITargetAPIContextDataKeyOriginActionParams][kXKOriginActionCallbackKeyFail];
    if (failCallback) {
        failCallback([manager fetchDataWithReformer:nil]);
    }
    [self.APIContextDictionary removeObjectForKey:manager];
}

- (void)manager:(XKAPIBaseManager *)manager didReceiveResponse:(XKURLResponse *)response {
    XKH5APICallback progressCallback = self.APIContextDictionary[manager][kXKBaseAPITargetAPIContextDataKeyOriginActionParams][kXKOriginActionCallbackKeyProgress];
    if (progressCallback) {
        progressCallback(@{
                           @"result":@"progress",
                           @"status":@"request finished"
                           });
    }
}

- (BOOL)manager:(XKAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params {
    XKH5APICallback progressCallback = self.APIContextDictionary[manager][kXKBaseAPITargetAPIContextDataKeyOriginActionParams][kXKOriginActionCallbackKeyProgress];
    if (progressCallback) {
        progressCallback(@{
                           @"result":@"progress",
                           @"status":@"request started"
                           });
    }
    return YES;
}

- (NSDictionary *)paramsForApi:(XKAPIBaseManager *)manager {
    NSDictionary *result = self.APIContextDictionary[manager][kXKBaseAPITargetAPIContextDataKeyParamsForAPI];
    return  result;
}

- (NSMutableDictionary *)APIContextDictionary {
    if (!_APIContextDictionary) {
        _APIContextDictionary = @{}.mutableCopy;
    }
    return _APIContextDictionary;
}

@end
