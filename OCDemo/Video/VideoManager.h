//
//  VideoManager.h
//  OCDemo
//
//  Created by lixy on 2018/2/2.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

+ (VideoManager *)shareManager;

- (void)downloadVideo;

@end
