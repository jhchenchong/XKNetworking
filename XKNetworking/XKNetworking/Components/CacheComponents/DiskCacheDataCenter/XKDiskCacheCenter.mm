//
//  XKDiskCacheCenter.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "XKDiskCacheCenter.h"
#import <MMKV/MMKV.h>

NSString * const kXKDiskCacheCenterCachedName = @"mmkv.networkingdiskcache";

@implementation XKDiskCacheCenter

- (XKURLResponse *)fetchCachedRecordWithKey:(NSString *)key {
    NSString *actualKey = [NSString stringWithFormat:@"%@", key];
    XKURLResponse *response = nil;
    NSData *data = [[MMKV mmkvWithID:kXKDiskCacheCenterCachedName] getObjectOfClass:NSData.class forKey:actualKey];
    if (data) {
        NSDictionary *fetchedContent = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSNumber *lastUpdateTimeNumber = fetchedContent[@"lastUpdateTime"];
        NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:lastUpdateTimeNumber.doubleValue];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeInterval < [fetchedContent[@"cacheTime"] doubleValue]) {
            response = [[XKURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:fetchedContent[@"content"] options:0 error:NULL]];
        } else {
            [[MMKV mmkvWithID:kXKDiskCacheCenterCachedName] removeValueForKey:actualKey];
        }
    }
    return response;
}

- (void)saveCacheWithResponse:(XKURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime {
    if (response.content) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                 @"content":response.content,
                                                                 @"lastUpdateTime":@([NSDate date].timeIntervalSince1970),
                                                                 @"cacheTime":@(cacheTime)
                                                                 }
                                                       options:0
                                                         error:NULL];
        if (data) {
            NSString *actualKey = [NSString stringWithFormat:@"%@", key];
            [[MMKV mmkvWithID:kXKDiskCacheCenterCachedName] setObject:data forKey:actualKey];
        }
    }
}

- (void)cleanAll {
    [[MMKV mmkvWithID:kXKDiskCacheCenterCachedName] clearAll];
}

@end
