//
//  XKURLResponse.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XKURLResponseStatus) {
    XKURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    XKURLResponseStatusErrorTimeout,
    XKURLResponseStatusErrorCancel,
    XKURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};


@interface XKURLResponse : NSObject

@property (nonatomic, assign, readonly) XKURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, strong, readonly) NSString *errorMessage;

@property (nonatomic, copy) NSDictionary *acturlRequestParams;
@property (nonatomic, copy) NSDictionary *originRequestParams;
@property (nonatomic, copy) NSString *logString;

@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error;

// 使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
