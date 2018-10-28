//
//  Target_DemoService.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoService.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const XKNetworkingDemoServiceIdentifier;

@interface Target_DemoService : NSObject

- (DemoService *)Action_DemoService:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
