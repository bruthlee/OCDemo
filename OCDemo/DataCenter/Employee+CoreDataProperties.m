//
//  Employee+CoreDataProperties.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/20.
//  Copyright © 2017年 greencici. All rights reserved.
//
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
}

@dynamic age;
@dynamic birthday;
@dynamic name;
@dynamic sectionName;
@dynamic department;

@end
