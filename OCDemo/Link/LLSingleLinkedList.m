//
//  LLSingleLinkedList.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/23.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "LLSingleLinkedList.h"

@implementation LLSingleLinkedNode

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

- (id)copyWithZone:(nullable NSZone *)zone {
    LLSingleLinkedNode *newNode = [[LLSingleLinkedNode allocWithZone:zone] init];
    newNode.key = self.key;
    newNode.value = self.value;
    newNode.next = self.next;
    return newNode;
}

- (BOOL)isEqual:(LLSingleLinkedNode *)object {
    BOOL flag = NO;
    if (self.key && object.key && [object.key isEqualToString:self.key]) {
        flag = YES;
    }
    return flag;
}

@end


#pragma mark -

@interface LLSingleLinkedList()

@property (nonatomic, strong) LLSingleLinkedNode *headNode;

@property (nonatomic, strong) NSMutableDictionary *innerMap;

@end

@implementation LLSingleLinkedList

- (instancetype)init {
    self = [super init];
    if (self) {
        _innerMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)stringIsNull:(NSString *)str {
    return !str || str.length == 0;
}

- (BOOL)isNodeExit:(LLSingleLinkedNode *)node {
    LLSingleLinkedNode *temp = self.headNode;
    while (temp) {
        if ([temp isEqual:node]) {
            return YES;
        }
        temp = temp.next;
    }
    return NO;
}

- (LLSingleLinkedNode *)nodeBeforeNode:(LLSingleLinkedNode *)node {
    LLSingleLinkedNode *target = nil;
    LLSingleLinkedNode *temp = self.headNode;
    while (temp) {
        if (temp.next && [temp.next isEqual:node]) {
            target = temp;
            break;
        }
        else {
            temp = temp.next;
        }
    }
    return target;
}

#pragma mark - Public Methods

- (void)insertNodeAtHead:(LLSingleLinkedNode *)node {
    if (!node || [self stringIsNull:node.key]) {
        return;
    }
    
    if ([self isNodeExit:node]) {
        return;
    }
    
    _innerMap[node.key] = node;
    
    if (_headNode) {
        node.next = _headNode;
        _headNode = node;
    }
    else {
        _headNode = node;
    }
}

- (void)insertNode:(LLSingleLinkedNode *)node {
    if (!node || [self stringIsNull:node.key]) {
        return;
    }
    
    if ([self isNodeExit:node]) {
        return;
    }
    
    _innerMap[node.key] = node;
    
    if (!_headNode) {
        _headNode = node;
        return;
    }
    
    LLSingleLinkedNode *last = [self lastNode];
    last.next = node;
}

- (void)insertNode:(LLSingleLinkedNode *)newNode beforeNodeForKey:(NSString *)key {
    if ([self stringIsNull:key] || !newNode || [self stringIsNull:newNode.key]) {
        return;
    }
    
    if ([self isNodeExit:newNode]) {
        return;
    }
    
    if (!_headNode) {
        _headNode = newNode;
        return;
    }
    
    LLSingleLinkedNode *node = _innerMap[key];
    if (node) {
        _innerMap[newNode.key] = newNode;
        LLSingleLinkedNode *before = [self nodeBeforeNode:node];
        if (before) {
            before.next = newNode;
        }
        else {
            _headNode = newNode;
        }
        newNode.next = node;
    }
    else {
        [self insertNode:newNode];
    }
}

- (void)insertNode:(LLSingleLinkedNode *)newNode afterNodeForKey:(NSString *)key {
    if ([self stringIsNull:key] || !newNode || [self stringIsNull:newNode.key]) {
        return;
    }
    
    if ([self isNodeExit:newNode]) {
        return;
    }
    
    if (!_headNode) {
        _headNode = newNode;
        return;
    }
    
    LLSingleLinkedNode *node = _innerMap[key];
    if (node) {
        _innerMap[newNode.key] = newNode;
        newNode.next = node.next;
        node.next = newNode;
    }
    else {
        [self insertNode:newNode];
    }
}

- (void)bringNodeToHead:(LLSingleLinkedNode *)node {
    if (!node || !_headNode || [self stringIsNull:node.key]) {
        return;
    }
    
    if ([self isNodeExit:node]) {
        node = _innerMap[node.key];
        if ([node isEqual:_headNode]) {
            return;
        }
        
        LLSingleLinkedNode *before = [self nodeBeforeNode:node];
        if (before) {
            before.next = node.next;
            node.next = _headNode;
            _headNode = node;
        }
    }
    else {
        [self insertNodeAtHead:node];
    }
}

- (void)removeNode:(NSString *)key {
    if ([self stringIsNull:key]) {
        return;
    }
    
    LLSingleLinkedNode *node =_innerMap[key];
    if (node.next) {
        node.key = node.next.key;
        node.value = node.next.value;
        node.next = node.next.next;
    }
    else {
        LLSingleLinkedNode *before = [self nodeBeforeNode:node];
        if (before) {
            before.next = nil;
        }
    }
    
    [_innerMap removeObjectForKey:key];
}

- (LLSingleLinkedNode *)nodeForKey:(NSString *)key {
    if ([self stringIsNull:key]) {
        return nil;
    }
    
    return _innerMap[key];
}

- (LLSingleLinkedNode *)headNode {
    return _headNode;
}

- (LLSingleLinkedNode *)lastNode {
    LLSingleLinkedNode *last = _headNode;
    while (last.next) {
        last = last.next;
    }
    return last;
}

- (NSInteger)length {
    return _innerMap.count;
}

- (BOOL)isEmpty {
    return _headNode == nil;
}

- (void)reverse {
    LLSingleLinkedNode *prev = nil;
    LLSingleLinkedNode *current = _headNode;
    LLSingleLinkedNode *forward = nil;
    while (current) {
        forward = current.next;
        current.next = prev;
        prev = current;
        current = forward;
    }
    
    _headNode = prev;
}

- (void)readAllNode {
    LLSingleLinkedNode *tmpNode = _headNode;
    while (tmpNode) {
        NSLog(@"node key -- %@, node value -- %@", tmpNode.key, tmpNode.value);
        tmpNode = tmpNode.next;
    }
}

@end
