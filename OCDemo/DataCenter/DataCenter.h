//
//  DataCenter.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/16.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Department+CoreDataClass.h"
#import "Employee+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"
#import "Student+CoreDataClass.h"

@interface DataCenter : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

@property (nonatomic, strong, readonly) NSManagedObjectContext *subContext;

+ (instancetype)shareDataCenter;

@end
