//
//  Student+CoreDataProperties.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/20.
//  Copyright © 2017年 greencici. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Student"];
}

@dynamic age;
@dynamic name;
@dynamic sex;
@dynamic teacher;

@end
