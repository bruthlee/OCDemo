//
//  KVCModel.h
//  OCDemo
//
//  Created by hollywater on 2018/5/11.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCModel : NSObject

@property (nonatomic, assign) BOOL shouldInstanceVariablesDirectly;

@property (nonatomic, assign) BOOL canSetValue;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) float price;

@end
