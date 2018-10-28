//
//  XKNetworkingDefines.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#ifndef XKNetworkingDefines_h
#define XKNetworkingDefines_h

#import <UIKit/UIKit.h>

@class XKAPIBaseManager;
@class XKURLResponse;

typedef NS_ENUM (NSUInteger, XKServiceAPIEnvironment){
    XKServiceAPIEnvironmentDevelop,
    XKServiceAPIEnvironmentReleaseCandidate,
    XKServiceAPIEnvironmentRelease
};

typedef NS_ENUM (NSUInteger, XKAPIManagerRequestType){
    XKAPIManagerRequestTypePost,
    XKAPIManagerRequestTypeGet,
    XKAPIManagerRequestTypePut,
    XKAPIManagerRequestTypeDelete,
};

typedef NS_ENUM (NSUInteger, XKAPIManagerErrorType){
    XKAPIManagerErrorTypeNeedAccessToken, // 需要重新刷新accessToken
    XKAPIManagerErrorTypeNeedLogin,       // 需要登陆
    XKAPIManagerErrorTypeDefault,         // 没有产生过API请求，这个是manager的默认状态。
    XKAPIManagerErrorTypeLoginCanceled,   // 调用API需要登陆态，弹出登陆页面之后用户取消登陆了
    XKAPIManagerErrorTypeSuccess,         // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    XKAPIManagerErrorTypeNoContent,       // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    XKAPIManagerErrorTypeParamsError,     // 参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    XKAPIManagerErrorTypeTimeout,         // 请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    XKAPIManagerErrorTypeNoNetWork,       // 网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    XKAPIManagerErrorTypeCanceled,        // 取消请求
    XKAPIManagerErrorTypeNoError,         // 无错误
    XKAPIManagerErrorTypeDownGrade,       // APIManager被降级了
};

typedef NS_OPTIONS(NSUInteger, XKAPIManagerCachePolicy) {
    XKAPIManagerCachePolicyNoCache = 0,
    XKAPIManagerCachePolicyMemory = 1 << 0,
    XKAPIManagerCachePolicyDisk = 1 << 1,
};

extern NSString * _Nonnull const kXKAPIBaseManagerRequestID;

// notification name
extern NSString * _Nonnull const kXKUserTokenInvalidNotification;
extern NSString * _Nonnull const kXKUserTokenIllegalNotification;
extern NSString * _Nonnull const kXKUserTokenNotificationUserInfoKeyManagerToContinue;

// result
extern NSString * _Nonnull const kXKApiProxyValidateResultKeyResponseObject;
extern NSString * _Nonnull const kXKApiProxyValidateResultKeyResponseString;

/*************************************************************************************/
@protocol XKAPIManager <NSObject>

@required
- (NSString *_Nonnull)methodName;
- (NSString *_Nonnull)serviceIdentifier;
- (XKAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params;
- (NSInteger)loadDataWithParams:(NSDictionary *_Nullable)params;

@end

/*************************************************************************************/
@protocol XKAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(XKAPIBaseManager *_Nonnull)manager beforePerformSuccessWithResponse:(XKURLResponse *_Nonnull)response;
- (void)manager:(XKAPIBaseManager *_Nonnull)manager afterPerformSuccessWithResponse:(XKURLResponse *_Nonnull)response;

- (BOOL)manager:(XKAPIBaseManager *_Nonnull)manager beforePerformFailWithResponse:(XKURLResponse *_Nonnull)response;
- (void)manager:(XKAPIBaseManager *_Nonnull)manager afterPerformFailWithResponse:(XKURLResponse *_Nonnull)response;

- (BOOL)manager:(XKAPIBaseManager *_Nonnull)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(XKAPIBaseManager *_Nonnull)manager afterCallingAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(XKAPIBaseManager *_Nonnull)manager didReceiveResponse:(XKURLResponse *_Nullable)response;

@end

/*************************************************************************************/

@protocol XKAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(XKAPIBaseManager * _Nonnull)manager;
- (void)managerCallAPIDidFailed:(XKAPIBaseManager * _Nonnull)manager;
@end

@protocol XKPagableAPIManager <NSObject>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSUInteger currentPageNumber;
@property (nonatomic, assign, readonly) BOOL isFirstPage;
@property (nonatomic, assign, readonly) BOOL isLastPage;

- (void)loadNextPage;

@end

/*************************************************************************************/

@protocol XKAPIManagerDataReformer <NSObject>
@required
- (id _Nullable)manager:(XKAPIBaseManager * _Nonnull)manager reformData:(NSDictionary * _Nullable)data;
@end

/*************************************************************************************/

@protocol XKAPIManagerValidator <NSObject>
@required
- (XKAPIManagerErrorType)manager:(XKAPIBaseManager *_Nonnull)manager isCorrectWithCallBackData:(NSDictionary *_Nullable)data;
- (XKAPIManagerErrorType)manager:(XKAPIBaseManager *_Nonnull)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data;
@end

/*************************************************************************************/

@protocol XKAPIManagerParamSource <NSObject>
@required
- (NSDictionary *_Nullable)paramsForApi:(XKAPIBaseManager *_Nonnull)manager;
@end


#endif
