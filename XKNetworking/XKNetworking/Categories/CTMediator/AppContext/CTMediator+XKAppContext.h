//
//  CTMediator+XKAppContext.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <CTMediator/CTMediator.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (XKAppContext)

- (BOOL)XKNetworking_shouldPrintNetworkingLog;
- (BOOL)XKNetworking_isReachable;
- (NSInteger)XKNetworking_cacheResponseCountLimit;

@end

NS_ASSUME_NONNULL_END
