//
//  XKMemoryCacheDataCenter.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "XKMemoryCacheDataCenter.h"
#import "XKMemoryCachedRecord.h"
#import "CTMediator+XKAppContext.h"


@interface XKMemoryCacheDataCenter ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation XKMemoryCacheDataCenter

- (XKURLResponse *)fetchCachedRecordWithKey:(NSString *)key {
    XKURLResponse *result = nil;
    XKMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (cachedRecord != nil) {
        if (cachedRecord.isOutdated || cachedRecord.isEmpty) {
            [self.cache removeObjectForKey:key];
        } else {
            result = [[XKURLResponse alloc] initWithData:cachedRecord.content];
        }
    }
    return result;
}

- (void)saveCacheWithResponse:(XKURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime {
    XKMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (cachedRecord == nil) {
        cachedRecord = [[XKMemoryCachedRecord alloc] init];
    }
    cachedRecord.cacheTime = cacheTime;
    [cachedRecord updateContent:[NSJSONSerialization dataWithJSONObject:response.content options:0 error:NULL]];
    [self.cache setObject:cachedRecord forKey:key];
}

- (void)cleanAll {
    [self.cache removeAllObjects];
}

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = [[CTMediator sharedInstance] XKNetworking_cacheResponseCountLimit];
    }
    return _cache;
}

@end
