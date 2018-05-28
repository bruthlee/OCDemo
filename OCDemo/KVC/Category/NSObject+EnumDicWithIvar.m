//
//  NSObject+EnumDicWithIvar.m
//  OCDemo
//
//  Created by hollywater on 2018/5/15.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "NSObject+EnumDicWithIvar.h"

#import <objc/runtime.h>

@implementation NSObject (EnumDicWithIvar)

+ (instancetype)ll_modelWithDic:(NSDictionary *)dic {
    if (dic) {
        id model = [[self alloc] init];
        
        // 获取成员属性
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList(self, &count);
        
        // 遍历所有属性
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            
            // 获取成员名称
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // 获取字典key
            NSString *key = [ivarName substringFromIndex:1];
            
            // 获取字典value
            id value = dic[key];
            
            // 获取成员属性类型
            NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            // 如果value是字典
            if ([value isKindOfClass:NSDictionary.class] && ![ivarType containsString:@"NS"]) {
                NSLog(@"ivarType: %@",ivarType);
                ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
                ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                Class modalClass = NSClassFromString(ivarType);
                if (modalClass) {
                    value = [modalClass ll_modelWithDic:value];
                }
            }
            
            // 如果value是数组
            if ([value isKindOfClass:NSArray.class]) {
                // 判断有没有自定义数组包含的对象
                if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                    id idSelf = self;
                    // 获取协议指定的成员属性类型
                    NSString *type = [idSelf arrayContainModelClass][key];
                    // 生成对应的模型
                    Class cls = NSClassFromString(type);
                    NSMutableArray *arrTemp = [NSMutableArray array];
                    for (NSDictionary *dic in value) {
                        id arrModel = [cls ll_modelWithDic:dic];
                        if (arrModel) {
                            [arrTemp addObject:arrModel];
                        }
                    }
                    value = arrTemp;
                }
            }
            
            if (value) {
                [model setValue:value forKey:key];
            }
        }
        
        return model;
    }
    return nil;
}

@end

@implementation NSArray (EnumDicWithIvar)

+ (NSArray *)ll_modelWithClass:(Class)cls datas:(NSArray *)datas {
    if (datas && datas.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in datas) {
            id object = [cls ll_modelWithDic:dic];
            if (object) {
                [temp addObject:object];
            }
        }
        return temp;
    }
    return nil;
}

@end
