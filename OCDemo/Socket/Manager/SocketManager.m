//
//  SocketManager.m
//  OCDemo
//
//  Created by lixy on 2018/1/31.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "SocketManager.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#import <UIKit/UIKit.h>

#import "NSDictionary+Parse.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>


@interface SocketManager() <GCDAsyncSocketDelegate> {
    BOOL _connectStatus;
}
@property (nonatomic, strong) NSThread *socketThread;
@property (nonatomic, copy) NSString *serHost;
@property (nonatomic, copy) NSString *serPort;
@property (nonatomic, assign) NSInteger heartbeat;
@property (nonatomic, assign) int clientSocket;
@property (nonatomic, strong) GCDAsyncSocket *cocoaSocket;
@end

@implementation SocketManager

+ (SocketManager *)shareManager {
    static SocketManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SocketManager alloc] init];
    });
    return manager;
}

- (void)connect {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getSocketServiceAddress];
        while (1) {
            if (self.serHost && self.serPort) {
                [self initCocoaAsyncSocket];
                break;
            }
        }
    });
}

- (void)disconnect {
    close(self.clientSocket);
    _connectStatus = NO;
}

- (void)sendMessage:(NSString *)message {
    if (_connectStatus == NO) {
        [self returnMessage:@"无法连接socket"];
        return;
    }
    
    [self returnMessage:[NSString stringWithFormat:@"[发送消息]: %@", message]];
    const char * send_Message = [message UTF8String];
    ssize_t size = send(self.clientSocket,send_Message,strlen(send_Message)+1,0);
    if (size < 0) {
        [self returnMessage:[NSString stringWithFormat:@"[消息发送失败]: %@", @(size)]];
        _connectStatus = NO;
    }
    else {
        [self returnMessage:[NSString stringWithFormat:@"[消息发送成功]: %@", @(size)]];
    }
}

- (void)receiveMessage {
    while (1) {
        char message[1024] = {0};
        recv(self.clientSocket, message, sizeof(message), 0);
        printf("[接收消息]: %s\n",message);
        NSString *msg = [NSString stringWithCString:message encoding:NSUTF8StringEncoding];
        [self returnMessage:msg];
        
        if (!msg || msg.length == 0) {
            _connectStatus = NO;
        }
        
        if (_connectStatus == NO) {
            break;
        }
    }
}

#pragma mark - GCDAsyncSocketDelegate

- (nullable dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock {
    NSLog(@"[1]newSocketQueueForConnectionFromAddress");
    return dispatch_get_main_queue();
}

/**
 * Called when a socket accepts a connection.
 * Another socket is automatically spawned to handle it.
 *
 * You must retain the newSocket if you wish to handle the connection.
 * Otherwise the newSocket instance will be released and the spawned connection will be closed.
 *
 * By default the new socket will have the same delegate and delegateQueue.
 * You may, of course, change this at any time.
 **/
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"[2]didAcceptNewSocket");
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"[3]didConnectToHost");
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToUrl:(NSURL *)url {
    NSLog(@"[4]didConnectToUrl");
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"[5]didReadData: %@",data);
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"[6]didReadPartialDataOfLength");
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"[7]didWriteDataWithTag");
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"[8]didWritePartialDataOfLength");
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length {
    NSLog(@"[9]shouldTimeoutReadWithTag");
    return -1;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length {
    NSLog(@"[10]shouldTimeoutWriteWithTag");
    return -1;
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock {
    NSLog(@"[11]socketDidCloseReadStream");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"[12]socketDidDisconnect: %@",err);
    [self returnMessage:[NSString stringWithFormat:@"socket连接被服务器拒绝:%@",err.localizedDescription]];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock {
    NSLog(@"[13]socketDidSecure");
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler {
    NSLog(@"[14]didReceiveTrust");
}

#pragma mark - Init

- (void)initCocoaAsyncSocket {
    if (_connectStatus) {
        return;
    }
    
    self.cocoaSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    uint16_t port = [self.serPort intValue];
    [self.cocoaSocket connectToHost:self.serHost onPort:port error:&error];
    if (error) {
        [self returnMessage:@"连接socket失败."];
    }
    else {
        [self returnMessage:@"连接socket可行."];
        _connectStatus = YES;
    }
}

- (int)initSocket {
    [self returnMessage:@"开始连接socket..."];
    //每次连接前，先断开连接
    if (_clientSocket != 0) {
        [self disconnect];
        _clientSocket = 0;
    }
    
    //创建客户端socket
    _clientSocket = CreateClientSocket();
    
    const char * ip = [self.serHost UTF8String];
    unsigned short port = [self.serPort intValue];
    
    //连接到服务器
    int result = ConnectToService(_clientSocket, ip, port);
    if (result == 0) {
        [self returnMessage:@"连接socket失败."];
    }
    else {
        [self returnMessage:@"连接socket成功."];
        _connectStatus = YES;
    }
    return result;
}

- (void)initThread {
    __weak typeof(self) weakSelf = self;
    dispatch_sync(SocketQueue(), ^{
        weakSelf.socketThread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveMessage) object:nil];
        [weakSelf.socketThread start];
    });
}

- (void)getSocketServiceAddress {
    [self returnMessage:@"正在获取服务器地址..."];
    NSString *url = @"https://apitest.yutong.com:20443/shake/center/api/conf/setting.do";
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dic && [dic theValueForKey:@"data"]) {
                NSDictionary *data = [dic theValueForKey:@"data"];
                NSString *servAddr = [data theValueForKey:@"servAddr"];
                weakSelf.heartbeat = [[data theValueForKey:@"heartBeatTimeSecond"] integerValue];
                if (servAddr) {
                    NSArray *list = [servAddr componentsSeparatedByString:@","];
                    NSString *addr = [list firstObject];
                    list = [addr componentsSeparatedByString:@":"];
                    weakSelf.serHost = [list firstObject];
                    weakSelf.serPort = [list lastObject];
                }
                [self returnMessage:[NSString stringWithFormat:@"服务器地址获取成功: %@", [dic JSONLocalString]]];
            }
            else {
                [self returnMessage:@"服务器返回空"];
            }
        }
        else if (error) {
            [self returnMessage:[NSString stringWithFormat:@"服务器返回错误: [%@]%@",@(error.code),error.localizedDescription]];
        }
    }];
    [task resume];
}

- (void)returnMessage:(NSString *)msg {
    if (self.result) {
        self.result(msg);
    }
}

#pragma mark - Socket

static dispatch_queue_t SocketQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.demo.socket.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

static int CreateClientSocket() {
    //创建一个socket,返回值为Int。（注scoket其实就是Int类型）
    //第一个参数addressFamily IPv4(AF_INET) 或 IPv6(AF_INET6)。
    //第二个参数 type 表示 socket 的类型，通常是流stream(SOCK_STREAM) 或数据报文datagram(SOCK_DGRAM)
    //第三个参数 protocol 参数通常设置为0，以便让系统自动为选择我们合适的协议，对于 stream socket 来说会是 TCP 协议(IPPROTO_TCP)，而对于 datagram来说会是 UDP 协议(IPPROTO_UDP)。
    return socket(AF_INET, SOCK_STREAM, 0);
}

static int ConnectToService(int socket, const char * ip, unsigned short port) {
    //生成一个sockaddr_in类型结构体
    struct sockaddr_in addr = {0};
    addr.sin_len = sizeof(addr);
    
    //设置IPv4
    addr.sin_family = AF_INET;
    
    //inet_aton是一个改进的方法来将一个字符串IP地址转换为一个32位的网络序列IP地址
    //如果这个函数成功，函数的返回值非零，如果输入地址不正确则会返回零
    inet_aton(ip, &addr.sin_addr);
    
    //htons是将整型变量从主机字节顺序转变成网络字节顺序，赋值端口号
    addr.sin_port = htons(port);
    
    //用scoket和服务端地址，发起连接。
    //客户端向特定网络地址的服务器发送连接请求，连接成功返回0，失败返回 -1。
    //注意：该接口调用会阻塞当前线程，直到服务器返回
    int result = connect(socket, (struct sockaddr *)&addr, sizeof(addr));
    if (result == 0) {
        return socket;
    }
    return 0;
}

@end
