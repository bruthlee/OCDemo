//
//  KVOViewController.m
//  OCDemo
//
//  Created by lixy on 2018/4/25.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "KVOViewController.h"

@interface KVOTest : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@end

@implementation KVOTest

@end

@interface KVOViewController ()
@property (nonatomic, strong) KVOTest *testObject;
@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.testObject = [KVOTest new];
    self.testObject.name = @"initName";
    self.testObject.age = @"initAge";
    
    [self.testObject addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self.testObject addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld context:nil];
    
    CGRect frame = CGRectMake(20, 20, CGRectGetWidth(self.view.frame) - 40, 50);
    [self setupButton:frame title:@"主线程修改" color:[UIColor brownColor] action:@selector(syncChangeValues)];
    
    frame.origin.y = CGRectGetMaxY(frame) + 10.0;
    [self setupButton:frame title:@"异步修改" color:[UIColor purpleColor] action:@selector(asyncChangeValues)];
}

- (void)dealloc {
    [self removeObserver:self.testObject forKeyPath:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)syncChangeValues {
    NSLog(@"thread: %@",[NSThread currentThread]);
    int random = arc4random_uniform(100);
    NSString *str = [NSString stringWithFormat:@"value%d",random];
    self.testObject.name = str;
    self.testObject.age = [NSString stringWithFormat:@"%d",random];
}

- (void)asyncChangeValues {
    __weak KVOViewController *weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"thread: %@",[NSThread currentThread]);
        int random = arc4random_uniform(100);
        NSString *str = [NSString stringWithFormat:@"value%d",random];
        weak.testObject.name = str;
        weak.testObject.age = [NSString stringWithFormat:@"%d",random];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"thread: %@",[NSThread currentThread]);
    NSLog(@"keyPath: %@", keyPath);
    NSLog(@"object: %@", object);
    NSLog(@"change: %@", change);
}

@end
