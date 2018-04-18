//
//  Department+CoreDataProperties.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/16.
//  Copyright © 2017年 greencici. All rights reserved.
//
//

#import "Department+CoreDataProperties.h"

@implementation Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Department"];
}

@dynamic name;
@dynamic address;
@dynamic employee;

@end
