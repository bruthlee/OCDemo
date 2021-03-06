//
//  BaseViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/15.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [self printLayoutInset:@"viewWillLayoutSubviews"];
}

- (void)viewDidLayoutSubviews {
    [self printLayoutInset:@"viewDidLayoutSubviews"];
}

- (void)printLayoutInset:(NSString *)log {
    if (self.showAutolayoutLog == NO) {
        return;
    }
    
    NSLog(@"*****************************************************");
    NSLog(@"***************%@****************",log);
    NSLog(@"[%@]: %@",NSStringFromClass(self.class), self.view);
    NSLog(@"self.topLayoutGuide.length = %f", self.topLayoutGuide.length);
    NSLog(@"self.bottomLayoutGuide.length = %f", self.bottomLayoutGuide.length);
    if (self.navigationController) {
        NSLog(@"self.navigationController.topLayoutGuide.length = %f", self.navigationController.topLayoutGuide.length);
        NSLog(@"self.navigationController.bottomLayoutGuide.length = %f", self.navigationController.bottomLayoutGuide.length);
    }
    if (self.tabBarController) {
        NSLog(@"self.tabBarController.topLayoutGuide.length = %f", self.tabBarController.topLayoutGuide.length);
        NSLog(@"self.tabBarController.bottomLayoutGuide.length = %f", self.tabBarController.bottomLayoutGuide.length);
    }
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = self.view.safeAreaInsets;
        NSLog(@"safeAreaInsets = %f,%f,%f,%f",insets.top, insets.left, insets.bottom, insets.right);
        
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        NSLog(@"guide owningView = %@", guide.owningView);
        NSLog(@"guide identifier = %@", guide.identifier);
        NSLog(@"guide layoutFrame = %@", NSStringFromCGRect(guide.layoutFrame));
    }
    
    NSLog(@"*****************************************************");
}

- (void)setupButton:(CGRect)rect title:(NSString *)title color:(UIColor *)color action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
