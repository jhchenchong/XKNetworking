//
//  XKAPIBaseManager.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKURLResponse.h"
#import "XKNetworkingDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKAPIBaseManager : NSObject <NSCopying>

// outter functions
@property (nonatomic, weak) id <XKAPIManagerCallBackDelegate> _Nullable delegate;
@property (nonatomic, weak) id <XKAPIManagerParamSource> _Nullable paramSource;
@property (nonatomic, weak) id <XKAPIManagerValidator> _Nullable validator;
@property (nonatomic, weak) NSObject<XKAPIManager> * _Nullable child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id <XKAPIManagerInterceptor> _Nullable interceptor;

// cache
@property (nonatomic, assign) XKAPIManagerCachePolicy cachePolicy;
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) NSTimeInterval diskCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) BOOL shouldIgnoreCache;  //默认NO

// response
@property (nonatomic, strong) XKURLResponse * _Nonnull response;
@property (nonatomic, readonly) XKAPIManagerErrorType errorType;
@property (nonatomic, copy, readonly) NSString * _Nullable errorMessage;

// before loading
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

// start
- (NSInteger)loadData;
+ (NSInteger)loadDataWithParams:(NSDictionary * _Nullable)params success:(void (^ _Nullable)(XKAPIBaseManager * _Nonnull apiManager))successCallback fail:(void (^ _Nullable)(XKAPIBaseManager * _Nonnull apiManager))failCallback;

// cancel
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// finish
- (id _Nullable )fetchDataWithReformer:(id <XKAPIManagerDataReformer> _Nullable)reformer;
- (void)cleanData;

@end

@interface XKAPIBaseManager (InnerInterceptor)

- (BOOL)beforePerformSuccessWithResponse:(XKURLResponse *_Nullable)response;
- (void)afterPerformSuccessWithResponse:(XKURLResponse *_Nullable)response;

- (BOOL)beforePerformFailWithResponse:(XKURLResponse *_Nullable)response;
- (void)afterPerformFailWithResponse:(XKURLResponse *_Nullable)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)afterCallingAPIWithParams:(NSDictionary *_Nullable)params;

@end

NS_ASSUME_NONNULL_END
