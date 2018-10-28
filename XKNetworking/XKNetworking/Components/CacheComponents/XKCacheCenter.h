//
//  XKCacheCenter.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKCacheCenter : NSObject

+ (instancetype)sharedInstance;

- (XKURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;
- (XKURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;

- (void)saveDiskCacheWithResponse:(XKURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime;
- (void)saveMemoryCacheWithResponse:(XKURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime;

- (void)cleanAllMemoryCache;
- (void)cleanAllDiskCache;

@end

NS_ASSUME_NONNULL_END
