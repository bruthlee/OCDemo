//
//  SocketManager.h
//  OCDemo
//
//  Created by lixy on 2018/1/31.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SocketManagerResult)(NSString *msg);

@interface SocketManager : NSObject

+ (SocketManager *)shareManager;

@property (nonatomic, copy) NSString *token;

- (void)connect;

- (void)disconnect;

- (void)sendMessage:(NSString *)message;

@property (nonatomic, copy) SocketManagerResult result;

@end
