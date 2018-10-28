//
//  XKMemoryCacheDataCenter.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKMemoryCacheDataCenter : NSObject

- (XKURLResponse *)fetchCachedRecordWithKey:(NSString *)key;
- (void)saveCacheWithResponse:(XKURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime;
- (void)cleanAll;

@end

NS_ASSUME_NONNULL_END
