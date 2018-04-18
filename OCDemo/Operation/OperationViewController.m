//
//  OperationViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2018/3/7.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "OperationViewController.h"

@interface OperationViewController ()

@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Operation";
    
    CGFloat space = 20.0;
    CGFloat width = CGRectGetWidth(self.view.frame) - space * 2;
    CGFloat height = 50.0;
    CGRect rect = CGRectMake(space, space, width, height);
    [self setupButton:rect title:@"Invocation Operation" color:[UIColor orangeColor] action:@selector(useInvocationOperation)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Block Operation" color:[UIColor redColor] action:@selector(useBlockOperation)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Add Block Operation" color:[UIColor magentaColor] action:@selector(useAddBlockOperation)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Operation Queue" color:[UIColor brownColor] action:@selector(useOperationQueue)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Async Operation Queue" color:[UIColor purpleColor] action:@selector(useAsyncOperationQueue)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Sync Operation Queue" color:[UIColor cyanColor] action:@selector(useSyncOperationQueue)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Max Operation Queue" color:[UIColor magentaColor] action:@selector(testOperationMaxQueue)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"Dependency Operation Queue" color:[UIColor blackColor] action:@selector(useOperationDependency)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)useInvocationOperation {
    int i = 0;
    while (i < 5) {
        NSLog(@"[1]testTask1: %d",i);
        i++;
    }
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testTask1) object:nil];
    [operation start];
    
    while (i < 10) {
        NSLog(@"[2]testTask1: %d",i);
        i++;
    }
}

- (void)testTask1 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"[3]testTask1: %@", [NSThread currentThread]); // 打印当前线程
        }
    });
}

- (void)testTask:(NSNumber *)number {
    for (int i = 1; i < 3; i++) {
        NSLog(@"[%@] testTask[%d]: %@", number, i, [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
    }
}

- (void)useBlockOperation {
    int i = 0;
    while (i < 5) {
        NSLog(@"[4]testTask2: %d",i);
        i++;
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self testTask1];
    }];
    [operation start];
    
    while (i < 10) {
        NSLog(@"[5]testTask2: %d",i);
        i++;
    }
}

- (void)useAddBlockOperation {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"[1]testTask1: %@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"[2]testTask1: %@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"[3]testTask1: %@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"[4]testTask1: %@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"[5]testTask1: %@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op start];
}

- (void)useOperationQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *invop = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testTask:) object:@(6)];
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 1; i < 3; i++) {
            NSLog(@"[7] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperation:invop];
    [queue addOperation:block];
    [queue addOperationWithBlock:^{
        for (int i = 1; i < 3; i++) {
            NSLog(@"[8] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        for (int i = 1; i < 3; i++) {
            NSLog(@"[9] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    NSLog(@"[MAX] = %@", @(queue.maxConcurrentOperationCount));
}

- (void)useAsyncOperationQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    [queue addOperationWithBlock:^{
        for (int i = 1; i < 3; i++) {
            NSLog(@"[1] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 3; i < 5; i++) {
            NSLog(@"[2] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 5; i < 7; i++) {
            NSLog(@"[3] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 7; i < 9; i++) {
            NSLog(@"[4] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
}

- (void)useSyncOperationQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [queue addOperationWithBlock:^{
        for (int i = 1; i < 3; i++) {
            NSLog(@"[1] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 3; i < 5; i++) {
            NSLog(@"[2] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 5; i < 7; i++) {
            NSLog(@"[3] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
}

- (void)testOperationMaxQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 200;
    [queue addOperationWithBlock:^{
        for (int i = 1; i < 3; i++) {
            NSLog(@"[1] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 3; i < 5; i++) {
            NSLog(@"[2] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 5; i < 7; i++) {
            NSLog(@"[3] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 7; i < 9; i++) {
            NSLog(@"[4] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 9; i < 11; i++) {
            NSLog(@"[5] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 11; i < 13; i++) {
            NSLog(@"[6] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 13; i < 15; i++) {
            NSLog(@"[7] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 15; i < 17; i++) {
            NSLog(@"[8] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 17; i < 19; i++) {
            NSLog(@"[9] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 3; i < 5; i++) {
            NSLog(@"[10] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 5; i < 7; i++) {
            NSLog(@"[11] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 7; i < 9; i++) {
            NSLog(@"[12] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    
    NSLog(@"[MAX] = %@", @(queue.maxConcurrentOperationCount));
}

- (void)useOperationDependency {
    NSInvocationOperation *vo = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testTask:) object:@(1)];
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 11; i < 13; i++) {
            NSLog(@"[2] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [block addDependency:vo];
    //此处必须先启动依赖项，否则crash
    [vo start];
    [block start];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testTask:) object:@(3)];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 21; i < 23; i++) {
            NSLog(@"[4] block[%d]: %@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [op1 addDependency:op2];
    //此处没有顺序要求
    [queue addOperation:op2];
    [queue addOperation:op1];
    
    NSLog(@"[MAX] = %@", @(queue.maxConcurrentOperationCount)); //-1
}

@end
