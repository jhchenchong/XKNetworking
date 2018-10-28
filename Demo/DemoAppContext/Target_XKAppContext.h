//
//  Target_XKAppContext.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_XKAppContext : NSObject

- (BOOL)Action_shouldPrintNetworkingLog:(NSDictionary *)params;
- (BOOL)Action_isReachable:(NSDictionary *)params;
- (NSInteger)Action_cacheResponseCountLimit:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
