//
//  CTMediator+XKAppContext.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "CTMediator+XKAppContext.h"

@implementation CTMediator (XKAppContext)

- (BOOL)XKNetworking_shouldPrintNetworkingLog {
    return [[[CTMediator sharedInstance] performTarget:@"XKAppContext" action:@"shouldPrintNetworkingLog" params:nil shouldCacheTarget:YES] boolValue];
}

- (BOOL)XKNetworking_isReachable {
    return [[[CTMediator sharedInstance] performTarget:@"XKAppContext" action:@"isReachable" params:nil shouldCacheTarget:YES] boolValue];
}

- (NSInteger)XKNetworking_cacheResponseCountLimit {
    return [[[CTMediator sharedInstance] performTarget:@"XKAppContext" action:@"cacheResponseCountLimit" params:nil shouldCacheTarget:YES] integerValue];
}

@end
