//
//  LLDoubleLinkedList.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/23.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LLDoubleLinkedNode : NSObject <NSCopying>

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) LLDoubleLinkedNode *prev;

@property (nonatomic, strong) LLDoubleLinkedNode *next;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;

+ (instancetype)nodeWithKey:(NSString *)key value:(NSString *)value;

@end


#pragma mark -

@interface LLDoubleLinkedList : NSObject

- (void)insertNodeAtHead:(LLDoubleLinkedNode *)node;

- (void)insertNode:(LLDoubleLinkedNode *)node;

- (void)insertNode:(LLDoubleLinkedNode *)newNode beforeNodeForKey:(NSString *)key;

- (void)insertNode:(LLDoubleLinkedNode *)newNode afterNodeForKey:(NSString *)key;

- (void)bringNodeToHead:(LLDoubleLinkedNode *)node;

- (void)readAllNode;

- (void)removeNodeForKey:(NSString *)key;

- (void)removeTailNode;

- (NSInteger)length;

- (BOOL)isEmpty;

- (LLDoubleLinkedNode *)nodeForKey:(NSString *)key;

- (LLDoubleLinkedNode *)headNode;

- (LLDoubleLinkedNode *)tailNode;

@end
