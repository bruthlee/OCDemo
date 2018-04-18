//
//  MasonaryViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "MasonaryViewController.h"

#import <Masonry/Masonry.h>

@interface MasonaryViewController ()

@end

@implementation MasonaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Masonary";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (self.type == 1) {
        [self testRelativeMoreViewMasonary];
    }
    else {
        [self testSimpleMasonary];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Masonary

- (void)testSimpleMasonary {
    //等高等宽
    CGFloat padding = 10.0, topOffset = 20.0;
    CGFloat height = 120.0;
    UIView *first_yellow = [[UIView alloc] init];
    first_yellow.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:first_yellow];
    UIView *first_red = [[UIView alloc] init];
    first_red.backgroundColor = [UIColor redColor];
    [self.view addSubview:first_red];
    UIView *first_blue = [[UIView alloc] init];
    first_blue.backgroundColor = [UIColor blueColor];
    [self.view addSubview:first_blue];
    [first_yellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).insets(UIEdgeInsetsMake(topOffset, padding, 0, 0));
        make.right.equalTo(first_red.mas_left).offset(-padding);
    }];
    [first_red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(UIEdgeInsetsMake(topOffset, 0, 0, 0));
        make.right.equalTo(first_blue.mas_left).offset(-padding);
    }];
    [first_blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view).insets(UIEdgeInsetsMake(topOffset, 0, 0, padding));
        make.height.mas_equalTo(height);
        make.width.height.equalTo(@[first_yellow,first_red]);
    }];
    
    //垂直居中等宽等高
    UIView *second_brown = [[UIView alloc] init];
    second_brown.backgroundColor = [UIColor brownColor];
    [self.view addSubview:second_brown];
    UIView *second_cyan = [[UIView alloc] init];
    second_cyan.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:second_cyan];
    [second_brown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(padding);
        make.right.equalTo(second_cyan.mas_left).with.offset(-padding);
        make.height.mas_equalTo(height);
    }];
    [second_cyan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(-padding);
        make.width.height.equalTo(second_brown);
    }];
    
    //
}

- (void)testRelativeMoreViewMasonary {
    UIView *innerView = [[UIView alloc] init];
    innerView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:innerView];
    NSInteger type = 0;
    if (type == 0) {
        //通过上下左右设置inset
        [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);//.with.offset(10);
            make.right.equalTo(self.view);//.with.offset(-10);
            make.top.equalTo(self.view).with.offset(20);
            make.height.mas_equalTo(120);
        }];
    }
    else if (type == 1) {
        //通过edge设置inset
        [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(20, 0, 300, 0));
        }];
    }
    else if (type == 2) {
        //通过center设置size
        [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        
        //2秒后更新该约束
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [innerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 100));
            }];
        });
    }
    
    //不定行数文本
    UILabel *txtLabel = [[UILabel alloc] init];
    txtLabel.backgroundColor = [UIColor redColor];
    txtLabel.textColor = [UIColor whiteColor];
    txtLabel.numberOfLines = 0;
    [self.view addSubview:txtLabel];
    [txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(innerView.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_greaterThanOrEqualTo(@(30));
    }];
    txtLabel.text = @"这是测试的字符串。能看到1、2、3个步骤，第一步当然是上传照片了，要上传正面近照哦。上传后，网站会自动识别你的面部，如果觉得识别的不准，你还可以手动修改一下。左边可以看到16项修改参数，最上面是整体修改，你也可以根据自己的意愿单独修改某项，将鼠标放到选项上面，右边的预览图会显示相应的位置。";
    
    //约束优先级
    UIView *priorityView = [[UIView alloc] init];
    priorityView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:priorityView];
    [priorityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(txtLabel.mas_bottom).with.offset(10);
        make.width.equalTo(self.view).priorityLow();
        make.width.mas_equalTo(200).priorityHigh();
        make.height.mas_equalTo(120).priorityLow();
        make.height.equalTo(txtLabel).priorityHigh();
        make.centerX.equalTo(self.view);
    }];
    
    //通过比例设置size
    UIView *scaleView = [[UIView alloc] init];
    scaleView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:scaleView];
    [scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priorityView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.equalTo(priorityView).multipliedBy(0.4);
    }];
}

@end
