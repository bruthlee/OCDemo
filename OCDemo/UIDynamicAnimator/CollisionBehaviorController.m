//
//  CollisionBehaviorController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "CollisionBehaviorController.h"

#import <Masonry/Masonry.h>

@interface CollisionView : UIView

@property (nonatomic, strong) UIColor *fillColor;

@end

@implementation CollisionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat length = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, length, length)];
    UIColor *color = self.fillColor ? self.fillColor : [UIColor orangeColor];
    [color setFill];
    [path fill];
}

@end


#pragma mark -

@interface CollisionBehaviorController () {
    UICollisionBehaviorMode _currentMode;
}
@property (nonatomic, assign) CGPoint orangeCenter;
@property (nonatomic, assign) CGPoint purpleCenter;
@property (nonatomic, strong) CollisionView *collisionView;
@property (nonatomic, strong) CollisionView *otherCollisionView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation CollisionBehaviorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Collision Behavior";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"Items",@"Boundaries",@"Everything"]];
    seg.frame = CGRectMake(20, 10, CGRectGetWidth(self.view.frame) - 40, 50.0);
    seg.tintColor = [UIColor magentaColor];
    [seg addTarget:self action:@selector(touchChangeCollisionEffiective:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    seg.selectedSegmentIndex = 0;
    _currentMode = UICollisionBehaviorModeItems;
    
    CGFloat y = CGRectGetMaxY(seg.frame);
    self.collisionView = [[CollisionView alloc] initWithFrame:CGRectMake(20, y + 20, 80, 80)];
    [self.view addSubview:self.collisionView];
    self.orangeCenter = self.collisionView.center;
    
    self.otherCollisionView = [[CollisionView alloc] initWithFrame:CGRectMake(100, y + 30, 100, 100)];
    self.otherCollisionView.fillColor = [UIColor purpleColor];
    [self.view addSubview:self.otherCollisionView];
    _purpleCenter = self.otherCollisionView.center;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self addAnimate];
}

- (void)touchChangeCollisionEffiective:(UISegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    UICollisionBehaviorMode mode = UICollisionBehaviorModeEverything;
    switch (index) {
        case 0:
            mode = UICollisionBehaviorModeItems;
            break;
        case 1:
            mode = UICollisionBehaviorModeBoundaries;
            break;
        default:
            break;
    }
    if (_currentMode != mode) {
        _currentMode = mode;
        [self.animator removeAllBehaviors];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.collisionView.center = weakSelf.orangeCenter;
            weakSelf.otherCollisionView.center = weakSelf.purpleCenter;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addAnimate];
            });
        }];
    }
}

- (void)addAnimate {
    [self.animator removeAllBehaviors];
    
    UICollisionBehavior *behavior = [[UICollisionBehavior alloc] initWithItems:@[_collisionView,_otherCollisionView]];
    behavior.translatesReferenceBoundsIntoBoundary = YES;
    behavior.collisionMode = _currentMode;
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_collisionView,_otherCollisionView]];
    gravity.gravityDirection = CGVectorMake(1.0, 1.0); //(0,0) -> (1.0,1.0)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animator addBehavior:behavior];
        [self.animator addBehavior:gravity];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        gravity.gravityDirection = CGVectorMake(0.0, 1.0);
//        [self.animator addBehavior:gravity];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
