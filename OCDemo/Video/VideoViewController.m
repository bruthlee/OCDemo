//
//  VideoViewController.m
//  OCDemo
//
//  Created by lixy on 2018/1/8.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "VideoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import <UIImageView+WebCache.h>

#import "DemoObject.h"
#import "VideoManager.h"

@interface VideoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频播放";
    
    /**
     https://nightlies.videolan.org/build/iOS/
     https://www.jianshu.com/p/3618a9116660
     */
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(downloadVideo)];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self setupDataSource];
    
    CGRect rect = self.view.bounds;
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 120;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadVideo {
    [[VideoManager shareManager] downloadVideo];
}

- (void)setupDataSource {
    DemoObject *mpmovie = [DemoObject initWithName:@"MPMoviePlayerViewController" method:@""];
    DemoSection *sys = [DemoSection initWithTitle:@"系统播放器" list:@[mpmovie]];
    [self.dataSource addObject:sys];
    
    DemoObject *vlckit = [DemoObject initWithName:@"MobileVLCKit" method:@""];
    DemoSection *third = [DemoSection initWithTitle:@"第三方" list:@[vlckit]];
    [self.dataSource addObject:third];
}

#pragma mark - Table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DemoSection *item = [self.dataSource objectAtIndex:section];
    return item.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoStyleCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoStyleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DemoSection *item = [self.dataSource objectAtIndex:section];
    return item.title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://content.viki.com/test_ios/ios_240.m3u8"]];
            [self presentMoviePlayerViewControllerAnimated:player];
        }
    }
    else {
        
    }
}

@end
