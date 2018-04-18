//
//  LLDoubleLinkedList.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/23.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "LLDoubleLinkedList.h"

@implementation LLDoubleLinkedNode

- (id)copyWithZone:(nullable NSZone *)zone {
    LLDoubleLinkedNode *newNode = [[LLDoubleLinkedNode allocWithZone:zone] init];
    newNode.key = self.key;
    newNode.value = self.value;
    newNode.prev = self.prev;
    newNode.next = self.next;
    return newNode;
}

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value {
    if (self = [super init]) {
        _key = key;
        _value = value;
    }
    return self;
}

+ (instancetype)nodeWithKey:(NSString *)key value:(NSString *)value {
    return [[[self class] alloc] initWithKey:key value:value];
}

- (BOOL)isEqual:(LLDoubleLinkedNode *)object {
    BOOL flag = NO;
    if (self.key && object.key && [object.key isEqualToString:self.key]) {
        flag = YES;
    }
    return flag;
}

@end


#pragma mark -

@interface LLDoubleLinkedList()

@property (nonatomic, strong) LLDoubleLinkedNode *headNode;

@property (nonatomic, strong) LLDoubleLinkedNode *tailNode;

@property (nonatomic, strong) NSMutableDictionary *innerMap;

@end

@implementation LLDoubleLinkedList

- (instancetype)init {
    self = [super init];
    if (self) {
        _innerMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark **Tools**

- (BOOL)stringIsNull:(NSString *)str {
    return !str || str.length == 0;
}

- (BOOL)isNodeExit:(LLDoubleLinkedNode *)node {
    LLDoubleLinkedNode *temp = self.headNode;
    while (temp) {
        if ([temp isEqual:node]) {
            return YES;
        }
        temp = temp.next;
    }
    return NO;
}

#pragma mark **Public Methods**

- (void)insertNodeAtHead:(LLDoubleLinkedNode *)node {
    if (!node || [self stringIsNull:node.key]) {
        return;
    }
    
    if ([self isNodeExit:node]) {
        return;
    }
    
    _innerMap[node.key] = node;
    
    if (_headNode) {
        _headNode.prev = node;
        node.next = _headNode;
        _headNode = node;
    }
    else {
        _headNode = _tailNode = node;
    }
}

- (void)insertNode:(LLDoubleLinkedNode *)node {
    if (!node || [self stringIsNull:node.key]) {
        return;
    }
    
    if ([self isNodeExit:node]) {
        return;
    }
    
    if (!_headNode && !_tailNode) {
        _headNode = _tailNode = node;
        return;
    }
    
    _innerMap[node.key] = node;
    
    _tailNode.next = node;
    node.prev = _tailNode;
    _tailNode = node;
}

- (void)insertNode:(LLDoubleLinkedNode *)newNode beforeNodeForKey:(NSString *)key {
    if (!newNode || [self stringIsNull:newNode.key] || [self stringIsNull:key]) {
        return;
    }
    
    if ([self isNodeExit:newNode]) {
        return;
    }
    
    if (!_headNode && !_tailNode) {
        _headNode = _tailNode = newNode;
        return;
    }
    
    LLDoubleLinkedNode *node = _innerMap[key];
    if (node) {
        if (node.prev) {
            _innerMap[newNode.key] = newNode;
            
            newNode.prev = node.prev;
            newNode.next = node;
            node.prev.next = newNode;
            node.prev = newNode;
        }
        else {
            [self insertNodeAtHead:newNode];
        }
    }
    else {
        [self insertNode:newNode];
    }
}

- (void)insertNode:(LLDoubleLinkedNode *)newNode afterNodeForKey:(NSString *)key {
    if (!newNode || [self stringIsNull:newNode.key] || [self stringIsNull:key]) {
        return;
    }
    
    if ([self isNodeExit:newNode]) {
        return;
    }
    
    if (!_headNode && !_tailNode) {
        _headNode = _tailNode = newNode;
        return;
    }
    
    LLDoubleLinkedNode *node =_innerMap[key];
    if (node && node.next) {
        _innerMap[newNode.key] = newNode;
        
        node.next.prev = newNode;
        newNode.next = node.next;
        newNode.prev = node;
        node.next = newNode;
    }
    else {
        [self insertNode:newNode];
    }
}

- (void)bringNodeToHead:(LLDoubleLinkedNode *)node {
    if (!node || [self stringIsNull:node.key]) {
        return;
    }
    
    if (!_headNode && !_tailNode) {
        _headNode = _tailNode = node;
        return;
    }
    
    if ([_headNode isEqual:node]) {
        return;
    }
    
    if ([self isNodeExit:node]) {
        node = _innerMap[node.key];
        if ([_tailNode isEqual:node]) {
            _tailNode = node.prev;
            _tailNode.next = nil;
        }
        else {
            node.next.prev = node.prev;
            node.prev.next = node.next;
        }
        
        _headNode.prev = node;
        node.next = _headNode;
        node.prev = nil;
        _headNode = node;
    }
    else {
        [self insertNodeAtHead:node];
    }
}

- (void)readAllNode {
    LLDoubleLinkedNode *node = _headNode;
    while (node) {
        NSLog(@"node key -- %@, node value -- %@", node.key, node.value);
        node = node.next;
    }
}

- (void)removeNodeForKey:(NSString *)key {
    if ([self stringIsNull:key]) {
        return;
    }
    
    LLDoubleLinkedNode *node = _innerMap[key];
    if (!node) {
        return;
    }
    if ([_headNode isEqual:node]) {
        _headNode = node.next;
        _headNode.prev = nil;
    }
    else if ([_tailNode isEqual:node]) {
        _tailNode = node.prev;
        _tailNode.next = nil;
    }
    else {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }
    
    [_innerMap removeObjectForKey:key];
}

- (void)removeTailNode {
    if (!_tailNode || [self stringIsNull:_tailNode.key]) {
        return;
    }
    
    [_innerMap removeObjectForKey:_tailNode.key];
    
    if ([_headNode isEqual:_tailNode]) {
        _headNode = _tailNode = nil;
        return;
    }
    
    _tailNode = _tailNode.prev;
    _tailNode.next = nil;
}

- (NSInteger)length {
    return _innerMap.count;
}

- (BOOL)isEmpty {
    return _headNode == nil ? YES : NO;
}

- (LLDoubleLinkedNode *)nodeForKey:(NSString *)key {
    if ([self stringIsNull:key]) {
        return nil;
    }
    return _innerMap[key];
}

- (LLDoubleLinkedNode *)headNode {
    return _headNode;
}

- (LLDoubleLinkedNode *)tailNode {
    return _tailNode;
}

@end
