//
//  XKServiceFactory.h
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (id <XKServiceProtocol>)serviceWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
