//
//  NSURLRequest+XKNetworkingMethods.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (XKNetworkingMethods)

@property (nonatomic, copy) NSDictionary *actualRequestParams;
@property (nonatomic, copy) NSDictionary *originRequestParams;
@property (nonatomic, strong) id <XKServiceProtocol> service;

@end

NS_ASSUME_NONNULL_END
