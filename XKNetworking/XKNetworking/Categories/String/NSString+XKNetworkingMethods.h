//
//  NSString+XKNetworkingMethods.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XKNetworkingMethods)

- (NSString *)XK_MD5;
- (NSString *)XK_SHA1;
- (NSString *)XK_Base64Encode;

@end

NS_ASSUME_NONNULL_END
