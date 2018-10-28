//
//  DemoService.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "DemoService.h"

@interface DemoService ()

@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) NSString *baseURL;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation DemoService

@synthesize apiEnvironment;

- (BOOL)handleCommonErrorWithResponse:(nonnull XKURLResponse *)response manager:(nonnull XKAPIBaseManager *)manager errorType:(XKAPIManagerErrorType)errorType {
    // 业务上这些错误码表示需要重新登录
    NSString *resCode = [NSString stringWithFormat:@"%@", response.content[@"resCode"]];
    if ([resCode isEqualToString:@"00100009"]
        || [resCode isEqualToString:@"05111001"]
        || [resCode isEqualToString:@"05111002"]
        || [resCode isEqualToString:@"1080002"]
        ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kXKUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kXKUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return NO;
    }
    
    // 业务上这些错误码表示需要刷新token
    NSString *errorCode = [NSString stringWithFormat:@"%@", response.content[@"errorCode"]];
    if ([response.content[@"errorMsg"] isEqualToString:@"invalid token"]
        || [response.content[@"errorMsg"] isEqualToString:@"access_token is required"]
        || [errorCode isEqualToString:@"BL10015"]
        ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kXKUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kXKUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return NO;
    }
    
    return YES;
}

- (nonnull NSURLRequest *)requestWithParams:(nonnull NSDictionary *)params methodName:(nonnull NSString *)methodName requestType:(XKAPIManagerRequestType)requestType {
    if (requestType == XKAPIManagerRequestTypeGet) {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL, methodName];
        NSString *tsString = [NSUUID UUID].UUIDString;
        NSString *md5Hash = [[NSString stringWithFormat:@"%@%@%@", tsString, self.privateKey, self.publicKey] XK_MD5];
        NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET"
                                                                           URLString:urlString
                                                                          parameters:@{
                                                                                       @"apikey":self.publicKey,
                                                                                       @"ts":tsString,
                                                                                       @"hash":md5Hash
                                                                                       }
                                                                               error:nil];
        request.originRequestParams = params;
        request.actualRequestParams = params;
        return request;
    }
    
    return nil;
}

- (NSDictionary *)resultWithResponseObject:(id)responseObject
                                  response:(NSURLResponse *)response
                                   request:(NSURLRequest *)request
                                     error:(NSError *)error {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if (error || !responseObject) {
        return result;
    }
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        result[kXKApiProxyValidateResultKeyResponseString] = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        result[kXKApiProxyValidateResultKeyResponseObject] = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
    } else {
        result[kXKApiProxyValidateResultKeyResponseObject] = responseObject;
    }
    
    return result;
}

- (NSString *)publicKey {
    return @"d97bab99fa506c7cdf209261ffd06652";
}

- (NSString *)privateKey {
    return @"31bb736a11cbc10271517816540e626c4ff2279a";
}

- (NSString *)baseURL {
    if (self.apiEnvironment == XKServiceAPIEnvironmentRelease) {
        return @"https://gateway.marvel.com:443/v1";
    }
    if (self.apiEnvironment == XKServiceAPIEnvironmentDevelop) {
        return @"https://gateway.marvel.com:443/v1";
    }
    if (self.apiEnvironment == XKServiceAPIEnvironmentReleaseCandidate) {
        return @"https://gateway.marvel.com:443/v1";
    }
    return @"https://gateway.marvel.com:443/v1";
}

- (XKServiceAPIEnvironment)apiEnvironment {
    return XKServiceAPIEnvironmentRelease;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}

@end
