//
//  NSDictionary+Parse.m
//  OCDemo
//
//  Created by lixy on 2018/1/31.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "NSDictionary+Parse.h"

@implementation NSDictionary (Parse)

- (id)theValueForKey:(id)aKey {
    if (self) {
        id value = [self objectForKey:aKey];
        if ((NSNull *)value == [NSNull null]) {
            return nil;
        }
        else if (value == NULL)
        {
            return nil;
        }
        return value;
    }
    else{
        return nil;
    }
}

- (id)stringForKey:(id)aKey {
    id value = [self theValueForKey:aKey];
    if (value == nil) {
        return  @"";
    }
    return value;
}

- (NSString *)theStringForKey:(NSString *)key {
    id value = [self theValueForKey:key];
    if (value == nil) {
        return @"";
    }
    else {
        return [NSString stringWithFormat:@"%@",value];
    }
}

- (NSString *)JSONLocalString {
    if (self) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        if (data) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return @"";
}

@end
