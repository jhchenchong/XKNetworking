//
//  XKCacheCenter.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "XKCacheCenter.h"
#import "XKMemoryCacheDataCenter.h"
#import "XKMemoryCachedRecord.h"
#import "XKLogger.h"
#import "XKServiceFactory.h"
#import "NSDictionary+XKNetworkingMethods.h"
#import "XKDiskCacheCenter.h"
#import "XKMemoryCacheDataCenter.h"

@interface XKCacheCenter ()

@property (nonatomic, strong) XKMemoryCacheDataCenter *memoryCacheCenter;
@property (nonatomic, strong) XKDiskCacheCenter *diskCacheCenter;

@end

@implementation XKCacheCenter

+ (instancetype)sharedInstance {
    static XKCacheCenter *cacheCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[XKCacheCenter alloc] init];
    });
    return cacheCenter;
}

- (XKURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params {
    XKURLResponse *response = [self.diskCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params]];
    if (response) {
        response.logString = [XKLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[XKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (XKURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params {
    XKURLResponse *response = [self.memoryCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params]];
    if (response) {
        response.logString = [XKLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[XKServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (void)saveDiskCacheWithResponse:(XKURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime {
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.diskCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams] cacheTime:cacheTime];
    }
}

- (void)saveMemoryCacheWithResponse:(XKURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime {
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.memoryCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams] cacheTime:cacheTime];
    }
}

- (void)cleanAllMemoryCache {
    [self.memoryCacheCenter cleanAll];
}

- (void)cleanAllDiskCache {
    [self.diskCacheCenter cleanAll];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams XK_transformToUrlParamString]];
    return key;
}

- (XKDiskCacheCenter *)diskCacheCenter {
    if (!_diskCacheCenter) {
        _diskCacheCenter = [[XKDiskCacheCenter alloc] init];
    }
    return _diskCacheCenter;
}

- (XKMemoryCacheDataCenter *)memoryCacheCenter {
    if (!_memoryCacheCenter) {
        _memoryCacheCenter = [[XKMemoryCacheDataCenter alloc] init];
    }
    return _memoryCacheCenter;
}

@end
