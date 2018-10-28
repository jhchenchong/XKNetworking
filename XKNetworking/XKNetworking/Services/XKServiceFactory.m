//
//  XKServiceFactory.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "XKServiceFactory.h"
#import <CTMediator/CTMediator.h>

@interface XKServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation XKServiceFactory

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XKServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XKServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (id<XKServiceProtocol>)serviceWithIdentifier:(NSString *)identifier {
    if (!self.serviceStorage[identifier]) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (id <XKServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier {
    return [[CTMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:NO];
}

- (NSMutableDictionary *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = @{}.mutableCopy;
    }
    return _serviceStorage;
}

@end
