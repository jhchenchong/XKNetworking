//
//  Target_H5API.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKAPIBaseManager.h"

extern NSString * const kXKBaseAPITargetAPIContextDataKeyParamsForAPI;
extern NSString * const kXKBaseAPITargetAPIContextDataKeyParamsAPIManager;
extern NSString * const kXKBaseAPITargetAPIContextDataKeyOriginActionParams;

NS_ASSUME_NONNULL_BEGIN

@interface Target_H5API : NSObject<XKAPIManagerCallBackDelegate, XKAPIManagerParamSource, XKAPIManagerInterceptor>

- (id)Action_loadAPI:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
