//
//  XKApiProxy.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XKCallback)(XKURLResponse *response);

@interface XKApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(XKCallback)success fail:(XKCallback)fail;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end

NS_ASSUME_NONNULL_END
