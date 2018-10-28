//
//  NSMutableString+XKNetworkingMethods.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "NSMutableString+XKNetworkingMethods.h"
#import "NSObject+XKNetworkingMethods.h"
#import "NSURLRequest+XKNetworkingMethods.h"
#import "NSDictionary+XKNetworkingMethods.h"

@implementation NSMutableString (XKNetworkingMethods)

- (void)appendURLRequest:(NSURLRequest *)request {
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Origin Params:\n\t%@", request.originRequestParams.XK_jsonString];
    [self appendFormat:@"\n\nHTTP Actual Params:\n\t%@", request.actualRequestParams.XK_jsonString];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] XK_defaultValue:@"\t\t\t\tN/A"]];
    
    NSMutableString *headerString = [[NSMutableString alloc] init];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *header = [NSString stringWithFormat:@" -H \"%@: %@\"", key, obj];
        [headerString appendString:header];
    }];
    
    [self appendString:@"\n\nCURL:\n\t curl"];
    [self appendFormat:@" -X %@", request.HTTPMethod];
    
    if (headerString.length > 0) {
        [self appendString:headerString];
    }
    if (request.HTTPBody.length > 0) {
        [self appendFormat:@" -d '%@'", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] XK_defaultValue:@"\t\t\t\tN/A"]];
    }
    
    [self appendFormat:@" %@", request.URL];
}

@end
