//
//  LifeCycleViewController.m
//  OCDemo
//
//  Created by hollywater on 2018/5/10.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "LifeCycleViewController.h"

@interface LifeCycleViewController ()

@end

@implementation LifeCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

#pragma mark - StatusBar

- (BOOL)prefersStatusBarHidden {
    NSLog(@"prefersStatusBarHidden");
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    NSLog(@"preferredStatusBarStyle");
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    NSLog(@"preferredStatusBarUpdateAnimation");
    return UIStatusBarAnimationFade;
}

#pragma mark - Segue

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    NSLog(@"performSegueWithIdentifier");
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    NSLog(@"shouldPerformSegueWithIdentifier");
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSLog(@"prepareForSegue");
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"canPerformUnwindSegueAction");
    return YES;
}

- (void)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC {
    NSLog(@"unwindForSegue");
}

@end
