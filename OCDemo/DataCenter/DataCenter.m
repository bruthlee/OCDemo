//
//  DataCenter.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/10/16.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter
@synthesize mainContext = _mainContext;
@synthesize subContext = _subContext;

+ (instancetype)shareDataCenter {
    static DataCenter *dataCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCenter = [[DataCenter alloc] init];
    });
    return dataCenter;
}

- (NSManagedObjectContext *)mainContext {
    if (_mainContext == nil) {
        //创建上下文主对象，设置为主并发队列
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        //创建托管对象模型
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"DataCenter" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        
        //创建持久化存储调度器
        NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        //创建SQLite数据库文件，不会重复创建
        NSString *sqlPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        sqlPath = [sqlPath stringByAppendingPathComponent:@"DataCenter.sqlite"];
        NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
        
        //关联SQLite数据库文件
        [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:nil];
        
        //关联主对象与持久化存储器
        _mainContext.persistentStoreCoordinator = storeCoordinator;
    }
    return _mainContext;
}

- (NSManagedObjectContext *)subContext {
    if (_subContext == nil) {
        _subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _subContext.parentContext = self.mainContext;
    }
    return _subContext;
}

@end
