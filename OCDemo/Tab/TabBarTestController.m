//
//  TabBarTestController.m
//  OCDemo
//
//  Created by hollywater on 2018/5/9.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "TabBarTestController.h"

#import "BaseNavigationController.h"
#import "TabSubFirstController.h"
#import "TabSubSecondController.h"

@interface TabBarTestController ()

@end

@implementation TabBarTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TabSubFirstController *first = [[TabSubFirstController alloc] init];
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:first];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"First" image:[UIImage imageNamed:@"tea"] selectedImage:[UIImage imageNamed:@"tea_on"]];
    
    TabSubSecondController *second = [[TabSubSecondController alloc] init];
//    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:second];
    second.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Second" image:[UIImage imageNamed:@"windmill"] selectedImage:[UIImage imageNamed:@"windmill_on"]];
    
//    self.viewControllers = @[nav1, nav2];
//    self.viewControllers = @[first, second];
    self.viewControllers = @[nav1, second];
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

@end
