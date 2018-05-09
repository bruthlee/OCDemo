//
//  LaunchAnimatedController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/16.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "LaunchAnimatedController.h"

#import "UIView+FrameCategory.h"
#import "UIImage+GIF.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kPictureW 750.0 //设计图纸的宽
#define kPictureH 1334.0 //设计图纸的高
#define kDistanceHeightRatio(r) r*SCREEN_HEIGHT/kPictureH
#define kDistanceWidthRatio(r) r*SCREEN_WIDTH/kPictureW

@interface LaunchAnimatedController () {
    CGPoint xingPoint;
    CGPoint bikePoint;
    CGPoint paobuPoint;
    CGPoint outPoint;
    CGPoint exPoint;
}
@property (nonatomic, strong) UIImageView *bikeImageView; //骑
@property (nonatomic, strong) UIImageView *xingImageView;  //行
@property (nonatomic, strong) UIImageView *paobuImageView; //跑步已OUT
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *nowImageView;
@property (nonatomic, strong) UIImageView *mountainImageView;
@property (nonatomic, strong) UIImageView *personImageView;
@property (nonatomic, strong) UIImageView *outImageView;
@property (nonatomic, strong) UIButton *experImageView;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation LaunchAnimatedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动画指引";
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.view.bounds;
    layer.contents = (__bridge id)[UIImage imageNamed:@"welcome_background"].CGImage;
    [self.view.layer addSublayer:layer];
    
    [self.view addSubview:self.paobuImageView];
    [self.view addSubview:self.bikeImageView];
    [self.view addSubview:self.xingImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.nowImageView];
    [self.view addSubview:self.personImageView];
    [self.view addSubview:self.mountainImageView];
    [self.view addSubview:self.outImageView];
    [self.view addSubview:self.experImageView];
    
    _paobuImageView.cy_bottomY = 0;
    _bikeImageView.cy_rightX = 0;
    _xingImageView.cy_originX = SCREEN_WIDTH;
    _outImageView.cy_bottomY = -200;
    _nowImageView.alpha = 0;
    _personImageView.alpha = 0;
    _experImageView.cy_originY = SCREEN_HEIGHT;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animate

- (void)setupAnimated {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"logoAnimate"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 4.0;
    animation.repeatCount = CGFLOAT_MAX;
    [self.logoImageView.layer addAnimation:animation forKey:@"logoAnimate"];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UISnapBehavior *snap1 = [[UISnapBehavior alloc] initWithItem:self.paobuImageView snapToPoint:paobuPoint];
    snap1.damping = 0.8;
    UISnapBehavior *snap2 = [[UISnapBehavior alloc] initWithItem:self.bikeImageView snapToPoint:bikePoint];
    snap2.damping = 0.8;
    UISnapBehavior *snap3 = [[UISnapBehavior alloc] initWithItem:self.xingImageView snapToPoint:xingPoint];
    snap3.damping = 0.8;
    UISnapBehavior *snap4 = [[UISnapBehavior alloc] initWithItem:self.experImageView snapToPoint:exPoint];
    snap4.damping = 0.8;
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.outImageView]];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.xingImageView,self.outImageView]];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.animator addBehavior:snap2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.animator addBehavior:snap3];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.animator addBehavior:snap1];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.animator addBehavior:gravity];
        [weakSelf.animator addBehavior:collision];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.animator addBehavior:snap4];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:3.f animations:^{
            weakSelf.nowImageView.alpha = 1.0;
            weakSelf.personImageView.alpha = 1.0;
        }];
    });
}

#pragma mark - Action

- (void)touchExButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"立即开始体验" message:@"Let's go!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"👌" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Initial

- (UIImageView *)bikeImageView {
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDistanceWidthRatio(140), self.paobuImageView.cy_bottomY + kDistanceHeightRatio(32), kDistanceWidthRatio(162), kDistanceHeightRatio(220))];
        bikePoint = _bikeImageView.center;
        _bikeImageView.image = [UIImage imageNamed:@"welcome_ride"];
    }
    return _bikeImageView;
}

- (UIImageView *)xingImageView {
    if (!_xingImageView) {
        
        _xingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDistanceWidthRatio(162), kDistanceHeightRatio(220))];
        _xingImageView.cy_rightX = SCREEN_WIDTH-kDistanceWidthRatio(140);
        _xingImageView.cy_originY = self.bikeImageView.cy_originY;
        _xingImageView.image = [UIImage imageNamed:@"welcome_xing"];
        xingPoint = _xingImageView.center;
    }
    return _xingImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bikeImageView.cy_rightX + kDistanceWidthRatio(12), 0, kDistanceWidthRatio(122), kDistanceWidthRatio(122))];
        _logoImageView.cy_centerY = self.bikeImageView.cy_centerY;
        _logoImageView.image = [UIImage imageNamed:@"welcome_logo"];
    }
    return _logoImageView;
}

- (UIImageView *)nowImageView {
    if (!_nowImageView) {
        _nowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDistanceWidthRatio(347), kDistanceHeightRatio(71))];
        _nowImageView.cy_originY = self.bikeImageView.cy_bottomY + kDistanceHeightRatio(92);
        _nowImageView.cy_centerX = SCREEN_HEIGHT / 2;
        _nowImageView.image = [UIImage imageNamed:@"welcome_atTime"];
    }
    return _nowImageView;
}

- (UIImageView *)paobuImageView {
    if (!_paobuImageView) {
        _paobuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDistanceWidthRatio(161), kDistanceHeightRatio(190), kDistanceWidthRatio(223), kDistanceHeightRatio(81))];
        _paobuImageView.image = [UIImage imageNamed:@"welcome_runed"];
        paobuPoint = _paobuImageView.cy_center;
    }
    return _paobuImageView;
}

- (UIImageView *)mountainImageView {
    if (!_mountainImageView) {
        _mountainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDistanceHeightRatio(148))];
        _mountainImageView.cy_originY = SCREEN_HEIGHT - kDistanceHeightRatio(148) - kDistanceHeightRatio(374);
        _mountainImageView.image = [UIImage imageNamed:@"welcome_jiashan"];
    }
    return _mountainImageView;
}

- (UIImageView *)personImageView {
    if (!_personImageView) {
        NSString *gifName = @"p1_gif.gif";
        NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:gifName ofType:nil];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        _personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDistanceWidthRatio(540), kDistanceHeightRatio(450))];
        _personImageView.cy_originY = self.nowImageView.cy_bottomY;
        _personImageView.cy_centerX = SCREEN_WIDTH / 2;
        _personImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    }
    return _personImageView;
}

- (UIImageView *)outImageView {
    if (!_outImageView) {
        _outImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDistanceWidthRatio(269), kDistanceHeightRatio(170))];
        _outImageView.image = [UIImage imageNamed:@"welcome_OUT"];
        _outImageView.cy_originY = kDistanceHeightRatio(134);
        _outImageView.cy_rightX = SCREEN_WIDTH - kDistanceWidthRatio(90);
        outPoint = _outImageView.cy_center;
    }
    return _outImageView;
}

- (UIButton *)experImageView {
    if (!_experImageView) {
        _experImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _experImageView.frame = CGRectMake(0, 0, 175, 48);
        UIImage *image = [UIImage imageNamed:@"welcome_experience"];
        [_experImageView setBackgroundImage:image forState:UIControlStateNormal];
        [_experImageView addTarget:self action:@selector(touchExButton) forControlEvents:UIControlEventTouchUpInside];
        _experImageView.cy_centerX = self.view.center.x;
        _experImageView.cy_centerY = SCREEN_HEIGHT - 120;
        exPoint = _experImageView.center;
    }
    return _experImageView;
}

@end
