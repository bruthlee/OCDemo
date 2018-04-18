//
//  FontViewController.m
//  OCDemo
//
//  Created by lixy on 2017/12/12.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "FontViewController.h"

@interface FontViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Fonts";
    
    CGRect rect = self.view.bounds;
    rect.size.height -= 64.0;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [UIFont familyNames].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *family = [[UIFont familyNames] objectAtIndex:section];
    NSArray *list = [UIFont fontNamesForFamilyName:family];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoFontsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demoFontsCell"];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *family = [[UIFont familyNames] objectAtIndex:section];
    NSArray *list = [UIFont fontNamesForFamilyName:family];
    NSString *font = [list objectAtIndex:row];
    cell.textLabel.text = font;
    cell.textLabel.font = [UIFont fontWithName:font size:16.0];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[UIFont familyNames] objectAtIndex:section];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

@end
