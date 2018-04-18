//
//  SchemaViewController.m
//  OCDemo
//
//  Created by lixy on 2018/3/12.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "SchemaViewController.h"

@interface SchemaViewController ()

@end

@implementation SchemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat space = 20.0;
    CGFloat width = CGRectGetWidth(self.view.frame) - space * 2;
    CGFloat height = 50.0;
    CGRect rect = CGRectMake(space, space, width, height);
    [self setupButton:rect title:@"打开掌上宇通" color:[UIColor orangeColor] action:@selector(openMainEyutong)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"打开掌上宇通顺风车" color:[UIColor cyanColor] action:@selector(openTestEyutong)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"打开掌上宇通任务汇报详情" color:[UIColor magentaColor] action:@selector(openMailEyutong)];
    
    rect.origin.y += rect.size.height + space;
    [self setupButton:rect title:@"打开掌上宇通远端页面" color:[UIColor purpleColor] action:@selector(openRemoteUrl)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openMainEyutong {
    [self openEyutong:@"main" identifier:nil params:nil];
}

- (void)openTestEyutong {
    [self openEyutong:@"app" identifier:@"com.yutong.ride.new" params:nil];
}

- (void)openMailEyutong {
    [self openEyutong:@"app" identifier:@"com.yutong.sven" params:@"#/mission/detail/263?from=card"];
}

- (void)openRemoteUrl {
    [self openEyutong:@"remote" identifier:@"https://www.baidu.com" params:nil];
}

- (void)openEyutong:(NSString *)host identifier:(NSString *)identifier params:(NSString *)params {
    NSString *schema = @"eyutong://";
    if (host) {
        schema = [schema stringByAppendingString:host];
        if (identifier) {
            schema = [schema stringByAppendingFormat:@"/%@",identifier];
            if (params) {
                schema = [schema stringByAppendingFormat:@"/%@",params];
            }
        }
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schema] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"打开结果: %@",success ? @"成功" : @"失败");
    }];
}

@end
