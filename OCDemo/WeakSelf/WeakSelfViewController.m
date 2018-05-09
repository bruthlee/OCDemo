//
//  WeakSelfViewController.m
//  OCDemo
//
//  Created by lixy on 2018/4/23.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "WeakSelfViewController.h"

typedef void(^BlockTableBlock)(void);

@interface BlockTable : NSObject

@property (nonatomic, copy) BlockTableBlock block;

- (void)reloadData;

@end

@implementation BlockTable

- (void)dealloc {
    NSLog(@"释放BlockTable...");
    self.block = nil;
}

- (void)setBlock:(BlockTableBlock)block {
    /// 弱引用还是会执行dealloc释放
    __weak BlockTableBlock weak = block;
    _block = weak;
    /// 造成强引用
    //_block = block;
}

- (void)reloadData {
    if (self.block) {
        self.block();
        self.block();
    }
}

@end


#pragma mark -
#pragma mark -

@interface WeakSelfViewController ()

@end

@implementation WeakSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WeakSelf";
    
    CGRect rect = CGRectMake(20, 20, CGRectGetWidth(self.view.bounds) - 40, 44);
    [self setupButton:rect title:@"initAndNoBlock" color:[UIColor yellowColor] action:@selector(initAndNoBlock)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"initAndBlock" color:[UIColor purpleColor] action:@selector(initAndBlock)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"initAndTypeBlock" color:[UIColor cyanColor] action:@selector(initAndTypeBlock)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"initAndWeakBlock" color:[UIColor brownColor] action:@selector(initAndWeakBlock)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"initAndOutsideNilBlock" color:[UIColor orangeColor] action:@selector(initAndOutsideNilBlock)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)initAndNoBlock {
    BlockTable *table = [BlockTable new];
    table.block = ^{
        
    };
    NSLog(@"[initAndNoBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)table));
}

- (void)initAndBlock {
    BlockTable *table = [BlockTable new];
    table.block = ^{
        
    };
    NSLog(@"[initAndBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)table));
}

- (void)initAndTypeBlock {
    BlockTable *table = [BlockTable new];
    table.block = ^{
#if 0
        __weak typeof(table) weak = table;
#endif
    };
    NSLog(@"[initAndTypeBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)table));
}

- (void)initAndWeakBlock {
    BlockTable *table = [BlockTable new];
    __weak BlockTable *weak = table;
    table.block = ^{
        __strong BlockTable *strong = weak;
        NSLog(@"[initAndTypeNilBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)strong));
    };
    NSLog(@"[initAndTypeNilBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)table));
}

- (void)initAndOutsideNilBlock {
    BlockTable *table = [BlockTable new];
    table.block = ^{
//        __weak typeof(table) weak = table;
//        NSLog(@"weak: %@, %ld",weak, (long)CFGetRetainCount((__bridge CFTypeRef)weak));
        /// 死循环
        //[weak reloadData];
    };
    NSLog(@"[initAndOutsideNilBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)table));
    [table reloadData];
    NSLog(@"[initAndOutsideNilBlock] table retain = %ld",CFGetRetainCount((__bridge CFTypeRef)table));
}

@end
