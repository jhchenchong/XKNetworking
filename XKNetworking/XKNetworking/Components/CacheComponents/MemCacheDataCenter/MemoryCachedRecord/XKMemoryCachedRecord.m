//
//  XKMemoryCachedRecord.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "XKMemoryCachedRecord.h"

@interface XKMemoryCachedRecord ()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end

@implementation XKMemoryCachedRecord

- (BOOL)isEmpty {
    return self.content == nil;
}

- (BOOL)isOutdated {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > self.cacheTime;
}

- (void)setContent:(NSData *)content {
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (instancetype)initWithContent:(NSData *)content {
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

- (void)updateContent:(NSData *)content {
    self.content = content;
}

@end
