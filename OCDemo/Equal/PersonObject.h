//
//  PersonObject.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/20.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonObject : NSObject

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, strong) NSString *name;

- (instancetype)initWithID:(NSInteger)uid name:(NSString *)name;

@end
