//
//  LLSingleLinkedList.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/23.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLSingleLinkedNode : NSObject <NSCopying>

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) LLSingleLinkedNode *next;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;

+ (instancetype)nodeWithKey:(NSString *)key value:(NSString *)value;

@end


#pragma mark -

@interface LLSingleLinkedList : NSObject

- (void)insertNode:(LLSingleLinkedNode *)node;

- (void)insertNodeAtHead:(LLSingleLinkedNode *)node;

- (void)insertNode:(LLSingleLinkedNode *)newNode beforeNodeForKey:(NSString *)key;

- (void)insertNode:(LLSingleLinkedNode *)newNode afterNodeForKey:(NSString *)key;

- (void)bringNodeToHead:(LLSingleLinkedNode *)node;

- (void)removeNode:(NSString *)key;

- (LLSingleLinkedNode *)nodeForKey:(NSString *)key;

- (LLSingleLinkedNode *)headNode;

- (LLSingleLinkedNode *)lastNode;

- (NSInteger)length;

- (BOOL)isEmpty;

- (void)reverse;

- (void)readAllNode;

@end
