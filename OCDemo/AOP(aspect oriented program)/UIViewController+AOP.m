//
//  UIViewController+AOP.m
//  OCDemo
//
//  Created by hollywater on 2018/5/13.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "UIViewController+AOP.h"

#import <objc/runtime.h>
#import <Aspects/Aspects.h>

@implementation UIViewController (AOP)

+ (void)load {
    /**
     *  方案二 利用AOP直接统计，无需继承
     */
    /*
     [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
     NSLog(@"View Controller %@ will appear animated: %tu", aspectInfo.instance, animated);
     } error:NULL];
     */
    
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        //NSLog(@"View Controller %@ did appear animated: %tu", aspectInfo.instance, animated);
        UIViewController *ctrl = aspectInfo.instance;
        if (![ctrl isKindOfClass:UINavigationController.class]) {
            ctrl.inDate = [NSDate date];
        }
    } error:NULL];
    
    /*
     [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
     NSLog(@"View Controller %@ will disappear animated: %tu", aspectInfo.instance, animated);
     } error:NULL];
     */
    
    [UIViewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        //NSLog(@"View Controller %@ did disappear animated: %tu", aspectInfo.instance, animated);
        UIViewController *ctrl = aspectInfo.instance;
        if (![ctrl isKindOfClass:UINavigationController.class]) {
            NSDate *outDate = [NSDate date];
            NSTimeInterval time = [outDate timeIntervalSinceDate:ctrl.inDate];
            NSLog(@"页面[%@]停留时长: %f",aspectInfo.instance,time);
        }
    } error:NULL];
}

static char kAssociatedInDateObjectKey;

- (void)setInDate:(NSDate *)inDate {
    objc_setAssociatedObject(self, &kAssociatedInDateObjectKey, inDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)inDate {
    return objc_getAssociatedObject(self, &kAssociatedInDateObjectKey);
}

@end
