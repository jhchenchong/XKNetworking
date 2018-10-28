//
//  XKLogger.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKServiceProtocol.h"
#import "XKURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKLogger : NSObject

+ (NSString *)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(id <XKServiceProtocol>)service;
+ (NSString *)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (NSString *)logDebugInfoWithCachedResponse:(XKURLResponse *)response methodName:(NSString *)methodName service:(id <XKServiceProtocol>)service params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
