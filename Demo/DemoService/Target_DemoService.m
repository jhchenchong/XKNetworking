//
//  Target_DemoService.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "Target_DemoService.h"

NSString * const XKNetworkingDemoServiceIdentifier = @"DemoService";

@implementation Target_DemoService

- (DemoService *)Action_DemoService:(NSDictionary *)params {
    return [[DemoService alloc] init];
}

@end
