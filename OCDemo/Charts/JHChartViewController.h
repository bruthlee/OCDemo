//
//  JHChartViewController.h
//  OCDemo
//
//  Created by lixy on 2017/12/4.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, JHChartType) {
    JHChartTypeLine,
    JHChartTypePie,
    JHChartTypeRing,
    JHChartTypeColumn,
    JHChartTypeTable,
    JHChartTypeRadar,
    JHChartTypeScatter
};

@interface JHChartViewController : BaseViewController

@property (nonatomic, assign) JHChartType type;

@end
