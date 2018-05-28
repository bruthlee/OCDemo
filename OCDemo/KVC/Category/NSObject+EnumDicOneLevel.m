//
//  NSObject+EnumDicOneLevel.m
//  OCDemo
//
//  Created by hollywater on 2018/5/15.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "NSObject+EnumDicOneLevel.h"

#import <objc/runtime.h>

const char * EnumDicOneLevelKey = "EnumDicOneLevelKey";

@implementation NSObject (EnumDicOneLevel)

+ (instancetype)cc_modelWithDic:(NSDictionary *)dic {
    if (dic) {
        // 实例化对象
        id model = [[self alloc] init];
        
        // 获取属性列表
        NSArray *properties = [self cc_modelProperties];
        
        // 遍历字典key
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // 判断key在不在属性列表
            if ([properties containsObject:key]) {
                if (obj) {
                    // 存在key，则利用KVC设置value
                    [model setValue:obj forKey:key];
                }
            }
        }];
        
        return model;
    }
    return nil;
}

/**
 获取属性列表
 */
+ (NSArray *)cc_modelProperties {
    NSArray *list = objc_getAssociatedObject(self, &EnumDicOneLevelKey);
    if (list && list.count > 0) {
        return list;
    }
    
    /* 成员变量:
     * class_copyIvarList(__unsafe_unretained Class cls, unsigned int *outCount)
     * 方法:
     * class_copyMethodList(__unsafe_unretained Class cls, unsigned int *outCount)
     * 属性:
     * class_copyPropertyList(__unsafe_unretained Class cls, unsigned int *outCount)
     * 协议:
     * class_copyProtocolList(__unsafe_unretained Class cls, unsigned int *outCount)
     */
    // 调用运行时方法, 取得类的属性列表
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    
    // 获取属性列表的string
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [temp addObject:name];
    }
    
    // 保存属性列表
    objc_setAssociatedObject(self, &EnumDicOneLevelKey, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 释放propertyList
    free(propertyList);
    
    return [NSArray arrayWithArray:temp];
}
/*
- (NSString *)description {
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        unsigned int count = 0;
        objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
        for (int j = 0; j < count; j++) {
            objc_property_attribute_t att = attribute[j];
            const char * attName = att.name;
            const char * attValue = att.value;
            NSString *attN = [NSString stringWithCString:attName encoding:NSUTF8StringEncoding];
            NSString *attV = [NSString stringWithCString:attValue encoding:NSUTF8StringEncoding];
            NSLog(@"[%@] - [%@]", attN, attV);
        }
        
        const char *propertyValue = property_getAttributes(property);
        NSString *value = [NSString stringWithCString:propertyValue encoding:NSUTF8StringEncoding];
        [result appendFormat:@"%@ = %@", name, value];
        if (i < outCount - 1) {
            [result appendString:@", "];
        }
    }
    
    return [NSString stringWithString:result];
}
*/
@end

#pragma mark -

@implementation NSArray (EnumDicOneLevel)

+ (NSArray *)cc_modelWithClass:(Class)cls list:(NSArray *)list {
    if (!cls || !list) return nil;
    if (list.count == 0) return [NSArray array];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        if ([dic isKindOfClass:NSDictionary.class]) {
            NSObject *model = [cls cc_modelWithDic:dic];
            if (model) [temp addObject:model];
        }
    }
    return [NSArray arrayWithArray:temp];
}

@end
