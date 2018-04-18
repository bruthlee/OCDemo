//
//  DynamicAnimatorViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "DynamicAnimatorViewController.h"

#import <Masonry/Masonry.h>

@interface DynamicAnimatorViewController () {
    CGPoint _secondImageViewPoint;
    CGPoint _thirdImageViewPoint;
}
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation DynamicAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Dynamic Animator";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.firstImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.firstImageView];
    self.secondImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.secondImageView];
    self.thirdImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.thirdImageView];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).insets(UIEdgeInsetsMake(-100, 50, 0, 0));
        make.width.height.mas_equalTo(100);
    }];
    
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view).insets(UIEdgeInsetsMake(-100, 0, 0, 20));
        make.width.height.mas_equalTo(100);
    }];
    
    self.firstImageView.image = [UIImage imageNamed:@"header1.jpg"];
    self.secondImageView.image = [UIImage imageNamed:@"header2.jpg"];
    _secondImageViewPoint = CGPointMake(100, 120);
    self.thirdImageView.image = [UIImage imageNamed:@"header3.jpg"];
    _thirdImageViewPoint = CGPointMake(CGRectGetWidth(self.view.frame) - 120, 180);
    [self keyframeAnimation];
}

- (void)keyframeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(-20/180.0*M_PI),@(10/180.0*M_PI),@(-20/180.0*M_PI)];
    animation.removedOnCompletion = NO;
    animation.duration = 0.5;
    animation.repeatCount = MAXFLOAT;
    [self.firstImageView.layer addAnimation:animation forKey:nil];
    
    //吸附效果
    UISnapBehavior *secondSnap = [[UISnapBehavior alloc] initWithItem:self.secondImageView snapToPoint:_secondImageViewPoint];
    secondSnap.damping = 1.0;
    UISnapBehavior *thirdSnap = [[UISnapBehavior alloc] initWithItem:self.thirdImageView snapToPoint:_thirdImageViewPoint];
    thirdSnap.damping = 1.0;
    
    //重力效果
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.secondImageView];
    [gravity addItem:self.thirdImageView];
    
    //弹性效果
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    [collision addItem:self.secondImageView];
    [collision addItem:self.thirdImageView];
    
    //添加到动画
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animator addBehavior:secondSnap];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animator addBehavior:thirdSnap];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
