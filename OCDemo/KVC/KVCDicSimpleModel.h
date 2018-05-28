//
//  KVCDicSimpleModel.h
//  OCDemo
//
//  Created by hollywater on 2018/5/14.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCDicSimpleModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *interest;

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;

+ (NSArray *)datasWithDictionary:(NSArray *)list;

@end

#pragma mark -

@interface KVCDicSimpleModel1 : KVCDicSimpleModel

@end

#pragma mark -

@interface KVCDicSimpleModel2 : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *interest;

@end

#pragma mark -

@interface KVCStudentModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray *subjects;

@end

#pragma mark -

@interface KVCSubjectModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *hour;

@end

#pragma mark -

@interface KVCStudentOtherModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) KVCSubjectModel *subject;

@end

#pragma mark -

@interface KVCScoreModel : NSObject

@property (nonatomic, copy) NSString *math;

@property (nonatomic, copy) NSString *chinese;

@end

#pragma mark -

@interface KVCStudentAgainModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray *subjects;

@property (nonatomic, strong) KVCScoreModel *score;

@end
