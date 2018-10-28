//
//  NSURLRequest+XKNetworkingMethods.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "NSURLRequest+XKNetworkingMethods.h"
#import <objc/runtime.h>

static void *XKNetworkingActualRequestParams = &XKNetworkingActualRequestParams;
static void *XKNetworkingOriginRequestParams = &XKNetworkingOriginRequestParams;
static void *XKNetworkingRequestService = &XKNetworkingRequestService;

@implementation NSURLRequest (XKNetworkingMethods)

- (void)setActualRequestParams:(NSDictionary *)actualRequestParams {
    objc_setAssociatedObject(self, XKNetworkingActualRequestParams, actualRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)actualRequestParams {
    return objc_getAssociatedObject(self, XKNetworkingActualRequestParams);
}

- (void)setOriginRequestParams:(NSDictionary *)originRequestParams {
    objc_setAssociatedObject(self, XKNetworkingOriginRequestParams, originRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)originRequestParams {
    return objc_getAssociatedObject(self, XKNetworkingOriginRequestParams);
}

- (void)setService:(id<XKServiceProtocol>)service {
    objc_setAssociatedObject(self, XKNetworkingRequestService, service, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<XKServiceProtocol>)service {
    return objc_getAssociatedObject(self, XKNetworkingRequestService);
}

@end
