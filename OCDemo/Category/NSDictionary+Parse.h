//
//  NSDictionary+Parse.h
//  OCDemo
//
//  Created by lixy on 2018/1/31.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Parse)

- (id)theValueForKey:(id)aKey;

- (id)stringForKey:(id)aKey;

- (NSString *)theStringForKey:(NSString *)key;

- (NSString *)JSONLocalString;

@end
