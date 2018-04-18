//
//  VideoManager.m
//  OCDemo
//
//  Created by lixy on 2018/2/2.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "VideoManager.h"

#import <AFNetworking.h>

@interface VideoManager() {
    NSInteger _index;
}
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSArray *list;
@end

@implementation VideoManager

+ (VideoManager *)shareManager {
    static VideoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VideoManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager = [[AFURLSessionManager alloc] init];
    }
    return self;
}

- (NSString *)path {
    NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    root = [root stringByAppendingPathComponent:@"video"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:root]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:root withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return root;
}

- (void)downloadVideo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *list = self.list;
    for (NSDictionary *dic in list) {
        NSString *name = [dic valueForKey:@"name"];
        NSString *url = [dic valueForKey:@"url"];
        NSString *path = [[self path] stringByAppendingPathComponent:name];
        if (![fileManager fileExistsAtPath:path]) {
            [self startDownloadVideo:name url:url path:path];
            break;
        }
    }
}

- (void)startDownloadVideo:(NSString *)name url:(NSString *)url path:(NSString *)path {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.sessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"");
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL URLWithString:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"[path]: %@",filePath);
        }];
    });
}

- (NSArray *)list {
    if (!_list) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"plist"];
        _list = [NSArray arrayWithContentsOfFile:path];
    }
    return _list;
}

@end
