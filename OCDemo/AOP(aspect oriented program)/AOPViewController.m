//
//  AOPViewController.m
//  OCDemo
//
//  Created by hollywater on 2018/5/13.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "AOPViewController.h"

#import <Aspects/Aspects.h>

@interface AOPViewController ()

@end

@implementation AOPViewController

/**
 *  方案二 利用AOP直接统计，无需继承
 */
/*
+ (void)load {
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ will appear animated: %tu", aspectInfo.instance, animated);
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ did appear animated: %tu", aspectInfo.instance, animated);
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ will disappear animated: %tu", aspectInfo.instance, animated);
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ did disappear animated: %tu", aspectInfo.instance, animated);
    } error:NULL];
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  方案一 利用父类来计算，这样要求需要统计的Ctrl继承此类
 */
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.inDate = [NSDate date];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.outDate = [NSDate date];
    NSTimeInterval time = [self.outDate timeIntervalSinceDate:self.inDate];
    NSLog(@"页面停留时长: %f",time);
}
*/
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
