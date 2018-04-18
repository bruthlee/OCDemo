//
//  DemoObject.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "DemoObject.h"

@implementation DemoSection

+ (instancetype)initWithTitle:(NSString *)title list:(NSArray *)list {
    DemoSection *item = [[DemoSection alloc] init];
    item.title = title;
    item.list = list;
    return item;
}

@end


#pragma mark -

@implementation DemoObject

+ (instancetype)initWithName:(NSString *)name method:(NSString *)method {
    return [self initWithName:name method:method params:nil];
}

+ (instancetype)initWithName:(NSString *)name method:(NSString *)method params:(NSString *)params {
    DemoObject *item = [[DemoObject alloc] init];
    item.name = name;
    item.method = method;
    item.params = params;
    return item;
}

@end


#pragma mark -

@implementation NetworkResponse

@end
