//
//  SocketViewController.m
//  OCDemo
//
//  Created by lixy on 2018/1/31.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "SocketViewController.h"

#import "SocketManager.h"

#import <Masonry.h>

@interface SocketViewController () {
    NSDateFormatter *_dateFormatter;
}
@property (nonatomic, strong) UITextView *textView;
@end

@implementation SocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Socket";
    
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.bottom.mas_equalTo(-20);
    }];
    self.textView.text = @"";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发消息" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    
    __weak SocketViewController *weakSelf = self;
    [SocketManager shareManager].result = ^(NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.textView.text = [weakSelf.textView.text stringByAppendingFormat:@"\n%@",msg];
        });
    };
    [[SocketManager shareManager] connect];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[SocketManager shareManager] disconnect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessage {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *date = [_dateFormatter stringFromDate:[NSDate date]];
    
    NSString *msg = [NSString stringWithFormat:@"hello%@",date];
    [[SocketManager shareManager] sendMessage:msg];
}

@end
