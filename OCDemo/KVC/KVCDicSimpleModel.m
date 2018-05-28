//
//  KVCDicSimpleModel.m
//  OCDemo
//
//  Created by hollywater on 2018/5/14.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "KVCDicSimpleModel.h"

@implementation KVCDicSimpleModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dic {
    if (dic) {
        KVCDicSimpleModel *model = [KVCDicSimpleModel new];
        [model setValuesForKeysWithDictionary:dic];
        return model;
    }
    return nil;
}

+ (NSArray *)datasWithDictionary:(NSArray *)list {
    if (list && list.count > 0) {
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dic in list) {
            KVCDicSimpleModel *model = [KVCDicSimpleModel modelWithDictionary:dic];
            if (model) {
                [result addObject:model];
            }
        }
        return [NSArray arrayWithArray:result];
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name = %@, age = %@, sex = %@, interest = %@", self.name, self.age, self.sex, self.interest];
}

@end

#pragma mark -

@implementation KVCDicSimpleModel1

+ (instancetype)modelWithDictionary:(NSDictionary *)dic {
    if (dic) {
        KVCDicSimpleModel1 *model = [KVCDicSimpleModel1 new];
        [model setValuesForKeysWithDictionary:dic];
        return model;
    }
    return nil;
}

+ (NSArray *)datasWithDictionary:(NSArray *)list {
    if (list && list.count > 0) {
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dic in list) {
            KVCDicSimpleModel1 *model = [KVCDicSimpleModel1 modelWithDictionary:dic];
            if (model) {
                [result addObject:model];
            }
        }
        return [NSArray arrayWithArray:result];
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"the [%@] is not defined, so set [%@] failed.", key, value);
}

@end

#pragma mark -

@implementation KVCDicSimpleModel2

- (NSString *)description {
    return [NSString stringWithFormat:@"name = %@, age = %@, sex = %@, interest = %@", self.name, self.age, self.sex, self.interest];
}

@end

#pragma mark -

@implementation KVCStudentModel

+ (NSDictionary *)arrayContainModelClass {
    return @{@"subjects": @"KVCSubjectModel"};
}

- (NSString *)description {
    NSMutableArray *sub = [NSMutableArray array];
    if (self.subjects && self.subjects.count > 0) {
        for (KVCSubjectModel *item in self.subjects) {
            [sub addObject:item.description];
        }
    }
    return [NSString stringWithFormat:@"name = %@, age = %@, sex = %@, subjects = %@", self.name, self.age, self.sex, [sub componentsJoinedByString:@" | "]];
}

@end

#pragma mark -

@implementation KVCSubjectModel

- (NSString *)description {
    return [NSString stringWithFormat:@"%@-%@", self.name, self.hour];
}

@end

#pragma mark -

@implementation KVCStudentOtherModel

- (NSString *)description {
    return [NSString stringWithFormat:@"name = %@, age = %@, sex = %@, subject = %@", self.name, self.age, self.sex, self.subject.description];
}

@end

#pragma mark -

@implementation KVCScoreModel

- (NSString *)description {
    return [NSString stringWithFormat:@"%@[math], %@[chinese]", self.math, self.chinese];
}

@end

#pragma mark -

@implementation KVCStudentAgainModel

+ (NSDictionary *)arrayContainModelClass {
    return @{@"subjects": @"KVCSubjectModel"};
}

- (NSString *)description {
    NSMutableArray *sub = [NSMutableArray array];
    if (self.subjects && self.subjects.count > 0) {
        for (KVCSubjectModel *item in self.subjects) {
            [sub addObject:item.description];
        }
    }
    return [NSString stringWithFormat:@"name = %@, age = %@, sex = %@, subjects = %@, score = %@", self.name, self.age, self.sex, [sub componentsJoinedByString:@" | "], self.score.description];
}

@end
