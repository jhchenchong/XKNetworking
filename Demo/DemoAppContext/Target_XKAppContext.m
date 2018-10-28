//
//  Target_XKAppContext.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "Target_XKAppContext.h"

@implementation Target_XKAppContext

- (BOOL)Action_isReachable:(NSDictionary *)params {
    return YES;
}

- (BOOL)Action_shouldPrintNetworkingLog:(NSDictionary *)params {
    return YES;
}

- (NSInteger)Action_cacheResponseCountLimit:(NSDictionary *)params {
    return 2;
}

@end
