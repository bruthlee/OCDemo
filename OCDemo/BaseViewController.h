//
//  BaseViewController.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/15.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseTableViewCell.h"

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL showAutolayoutLog;

- (void)setupButton:(CGRect)rect title:(NSString *)title color:(UIColor *)color action:(SEL)action;

@end
