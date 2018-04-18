//
//  Teacher+CoreDataProperties.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/20.
//  Copyright © 2017年 greencici. All rights reserved.
//
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *subject;
@property (nullable, nonatomic, retain) Student *students;

@end

NS_ASSUME_NONNULL_END
