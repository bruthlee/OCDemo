//
//  NSObject+EnumDicWithIvar.h
//  OCDemo
//
//  Created by hollywater on 2018/5/15.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EnumDicWithIvar <NSObject>

@optional
+ (NSDictionary *)arrayContainModelClass;

@end

@interface NSObject (EnumDicWithIvar)

+ (instancetype)ll_modelWithDic:(NSDictionary *)dic;

@end


@interface NSArray (EnumDicWithIvar)

+ (NSArray *)ll_modelWithClass:(Class)cls datas:(NSArray *)datas;

@end
