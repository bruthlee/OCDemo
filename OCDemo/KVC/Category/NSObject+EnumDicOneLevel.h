//
//  NSObject+EnumDicOneLevel.h
//  OCDemo
//
//  Created by hollywater on 2018/5/15.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EnumDicOneLevel)

+ (instancetype)cc_modelWithDic:(NSDictionary *)dic;

@end

#pragma mark -

@interface NSArray (EnumDicOneLevel)

+ (NSArray *)cc_modelWithClass:(Class)cls list:(NSArray *)list;

@end
