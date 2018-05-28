//
//  KVCModelDicController.m
//  OCDemo
//
//  Created by hollywater on 2018/5/14.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "KVCModelDicController.h"

#import "NSObject+EnumDicOneLevel.h"
#import "NSObject+EnumDicWithIvar.h"
#import "KVCDicSimpleModel.h"

@interface KVCModelDicController ()

@end

@implementation KVCModelDicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"嵌套model转换";
    
    CGRect rect = CGRectMake(20, 20, CGRectGetWidth(self.view.frame) - 40, 44);
    [self setupButton:rect title:@"Simple Dictionary To Model" color:[UIColor cyanColor] action:@selector(testSimpleDicToModel)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"Undefined Dictionary Key" color:[UIColor purpleColor] action:@selector(testUndefinedDicKey)];
    
    rect.origin.y += rect.size.height + 40.0;
    [self setupButton:rect title:@"Use Runtime With One Level" color:[UIColor orangeColor] action:@selector(useRuntimeWithOneLevel)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"Use Runtime With Object Ival" color:[UIColor brownColor] action:@selector(useRuntimeWithObjectIval)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"Multi-level Array To Model" color:[UIColor magentaColor] action:@selector(parseMultiArrayModelWithRuntime)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"Multi-level Dictionary To Model" color:[UIColor redColor] action:@selector(parseMultiDicModelWithRuntime)];
    
    rect.origin.y += rect.size.height + 10.0;
    [self setupButton:rect title:@"Multi-level Data To Model" color:[UIColor blueColor] action:@selector(parseMultiModelWithRuntime)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)testSimpleDicToModel {
    NSLog(@"=========================");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas1" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [KVCDicSimpleModel datasWithDictionary:array];
    for (KVCDicSimpleModel *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

- (void)testUndefinedDicKey {
    NSLog(@"=========================");
    /**
     如果model中不存在dic中的key，就会crash，需要重写model的setValue:forUndefinedKey:方法
     *** Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<KVCDicSimpleModel 0x600000253bc0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key work.'
     */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas2" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [KVCDicSimpleModel1 datasWithDictionary:array];
    for (KVCDicSimpleModel1 *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

- (void)useRuntimeWithOneLevel {
    NSLog(@"=========================");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas2" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [NSArray cc_modelWithClass:KVCDicSimpleModel2.class list:array];
    for (KVCDicSimpleModel2 *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

- (void)useRuntimeWithObjectIval {
    NSLog(@"=========================");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas2" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [NSArray ll_modelWithClass:KVCDicSimpleModel2.class datas:array];
    for (KVCDicSimpleModel2 *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

- (void)parseMultiArrayModelWithRuntime {
    NSLog(@"=========================");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas3" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [NSArray ll_modelWithClass:KVCStudentModel.class datas:array];
    for (KVCStudentModel *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

- (void)parseMultiDicModelWithRuntime {
    NSLog(@"=========================");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas4" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [NSArray ll_modelWithClass:KVCStudentOtherModel.class datas:array];
    for (KVCStudentOtherModel *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

- (void)parseMultiModelWithRuntime {
    NSLog(@"=========================");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KVCDicSimpleDatas5" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *result = [NSArray ll_modelWithClass:KVCStudentAgainModel.class datas:array];
    for (KVCStudentAgainModel *obj in result) {
        NSLog(@"obj: %@",obj.description);
    }
}

@end
