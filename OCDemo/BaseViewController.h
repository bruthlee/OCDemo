//
//  BaseViewController.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/15.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setupButton:(CGRect)rect title:(NSString *)title color:(UIColor *)color action:(SEL)action;

@end
