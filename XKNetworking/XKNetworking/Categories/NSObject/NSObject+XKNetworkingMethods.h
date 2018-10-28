//
//  NSObject+XKNetworkingMethods.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XKNetworkingMethods)

- (id)XK_defaultValue:(id)defaultData;
- (BOOL)XK_isEmptyObject;

@end

NS_ASSUME_NONNULL_END
