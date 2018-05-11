//
//  BaseTableViewCell.h
//  OCDemo
//
//  Created by hollywater on 2018/5/11.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)instanceWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bgView;

@end
