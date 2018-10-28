//
//  DemoApiManager.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "DemoApiManager.h"
#import "Target_DemoService.h"

@interface DemoApiManager ()<XKAPIManagerValidator, XKAPIManagerParamSource>



@end

@implementation DemoApiManager

- (instancetype)init {
    if (self = [super init]) {
        self.paramSource = self;
        self.validator = self;
        self.cachePolicy = XKAPIManagerCachePolicyDisk;
    }
    return self;
}

- (NSString *_Nonnull)methodName {
    return @"public/characters";
}

- (NSString *_Nonnull)serviceIdentifier {
    return XKNetworkingDemoServiceIdentifier;
}

- (XKAPIManagerRequestType)requestType {
    return XKAPIManagerRequestTypeGet;
}

- (NSDictionary *)paramsForApi:(XKAPIBaseManager *)manager {
    return nil;
}

- (XKAPIManagerErrorType)manager:(XKAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return XKAPIManagerErrorTypeNoError;
}

- (XKAPIManagerErrorType)manager:(XKAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return XKAPIManagerErrorTypeNoError;
}

@end
