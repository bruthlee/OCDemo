//
//  DemoObject.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DemoSection : NSObject

+ (instancetype)initWithTitle:(NSString *)title list:(NSArray *)list;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *list;//DemoObject

@end

#pragma mark -

@interface DemoObject : NSObject

+ (instancetype)initWithName:(NSString *)name method:(NSString *)method;

+ (instancetype)initWithName:(NSString *)name method:(NSString *)method params:(NSString *)params;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *method;

@property (nonatomic, copy) NSString *params;

@property (nonatomic, strong) id data;

@end


#pragma mark -

@interface NetworkResponse : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) id data;

@end

