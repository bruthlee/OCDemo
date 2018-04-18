//
//  MathViewController.h
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/21.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MathType) {
    MathTypeSegmentTree
};

@interface MathViewController : BaseViewController

@property (nonatomic, assign) MathType type;

@end
