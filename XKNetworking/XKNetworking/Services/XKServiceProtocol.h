//
//  XKServiceProtocol.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKNetworkingDefines.h"
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XKServiceProtocol <NSObject>

@property (nonatomic, assign) XKServiceAPIEnvironment apiEnvironment;

- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        requestType:(XKAPIManagerRequestType)requestType;

- (NSDictionary *)resultWithResponseObject:(id)responseObject
                                  response:(NSURLResponse *)response
                                   request:(NSURLRequest *)request
                                     error:(NSError *)error;

- (BOOL)handleCommonErrorWithResponse:(XKURLResponse *)response
                              manager:(XKAPIBaseManager *)manager
                            errorType:(XKAPIManagerErrorType)errorType;

@optional
- (AFHTTPSessionManager *)sessionManager;

@end

NS_ASSUME_NONNULL_END
