//
//  MathViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/21.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "MathViewController.h"

#import <Masonry/Masonry.h>

@interface MathViewController ()
@property (nonatomic, strong) UITextView *topicView;
@property (nonatomic, strong) UITextView *codeView;
@property (nonatomic, strong) UITextView *resultView;
@end

@implementation MathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self controllerTitle];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.topicView = [[UITextView alloc] init];
    self.topicView.editable = NO;
    self.topicView.backgroundColor = [UIColor brownColor];
    self.topicView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.topicView];
    
    self.codeView = [[UITextView alloc] init];
    self.codeView.editable = NO;
    self.codeView.backgroundColor = [UIColor cyanColor];
    self.codeView.textColor = [UIColor blackColor];
    [self.view addSubview:self.codeView];
    
    self.resultView = [[UITextView alloc] init];
    self.resultView.editable = NO;
    self.resultView.backgroundColor = [UIColor redColor];
    self.resultView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.resultView];
    
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(10, 10, 0, 10));
        make.height.mas_equalTo(80);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topicView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        //make.bottom.mas_equalTo(self.resultView.mas_top).offset(-10);
        make.height.mas_equalTo(100);
    }];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 10, 10));
        //make.height.mas_equalTo(80);
        make.top.mas_equalTo(self.codeView.mas_bottom).offset(10);
    }];
    
    self.topicView.text = [self controllTopic];
    self.codeView.text = @"CODE:";
    self.resultView.text = @"结果:";
    
    [self computerResult];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Computer

- (void)computerResult {
    switch (self.type) {
        case MathTypeSegmentTree:
            [self segmentTree];
            break;
            
        default:
            break;
    }
}

#pragma mark - Segment Tree

- (NSInteger)getTreeMid:(NSInteger)start end:(NSInteger)end {
    return start + (end - start) / 2;
}

/*
 获取数组给定区间之和的递归函数
 array    --> 线段树的指针
 index --> 线段树当前节点的下标。 初始传入根节点的下标为0
 根节点的下标值不会变更
 start & end  --> 线段树当前节点表示的原数组起止下标
 亦即，array[index]的起止下标
 segStart & segEnd  --> 查询区间的起止下标
*/
- (NSInteger)getSegmentTreeSum:(NSArray *)array start:(NSInteger)start end:(NSInteger)end segStart:(NSInteger)segStart segEnd:(NSInteger)segEnd index:(NSInteger)index {
    // 如果当前节点存储的线段是区间的一部分，返回当前线段的和
    if (segStart <= start && segEnd >= end) {
        return [array[index] integerValue];
    }
    
    // 如果节点存储的线段不在给定区间之内
    if (end < segStart || start > segEnd) {
        return 0;
    }
    
    // 如果节点的线段与区间的一部分有交集
    NSInteger mid = [self getTreeMid:start end:end];
    NSInteger left = [self getSegmentTreeSum:array start:start end:mid segStart:segStart segEnd:segEnd index:2*index+1];
    NSInteger right = [self getSegmentTreeSum:array start:(mid+1) end:end segStart:segStart segEnd:segEnd index:2*index+2];
    return left + right;
}

/**
  返回下标qs（查询起点）到qe（查询终点）的元素之和。
  主要使用了函数getSegmentTreeSum()
*/
- (NSInteger)getTreeSum:(NSArray *)array count:(NSInteger)count segStart:(NSInteger)segStart segEnd:(NSInteger)segEnd {
    if (segStart < 0 || segEnd > count - 1 || segStart > segEnd) {
        NSLog(@"invalid input : start & end");
        return -1;
    }
    
    return [self getSegmentTreeSum:array start:0 end:count-1 segStart:segStart segEnd:segEnd index:0];
}

/*
 更新下标位于给定区间内节点值的递归函数，
 array, index, start and end 与getSegmentTreeSum() 一致
 updateIndex  --> 待更新元素的下标，指的是输入数组的下标。
 diff --> 区间需要增加的值
*/
- (void)updateSegmentTreeValue:(NSMutableArray *)array start:(NSInteger)start end:(NSInteger)end updateIndex:(NSInteger)updateIndex diff:(NSInteger)diff index:(NSInteger)index {
    if (updateIndex < start || updateIndex > end) {
        return;
    }
    
    array[index] = [NSNumber numberWithInteger:([array[index] integerValue] + diff)];
    if (end != start) {
        NSInteger mid = [self getTreeMid:start end:end];
        [self updateSegmentTreeValue:array start:start end:mid updateIndex:updateIndex diff:diff index:(2*index+1)];
        [self updateSegmentTreeValue:array start:(mid + 1) end:end updateIndex:updateIndex diff:diff index:(2*index+2)];
    }
}

/**
  更新输入数组与线段树值的函数。
  使用了函数 updateSegmentTreeValue() 来更新线段树的值
*/
- (void)updateTreeValue:(NSArray *)array segArray:(NSMutableArray *)segArray count:(NSInteger)count index:(NSInteger)index updateValue:(NSInteger)updateValue {
    // 检查错误的输入下标
    if (index < 0 || index > count - 1) {
        NSLog(@"invalid input : index");
        return;
    }
    
     // 计算新值与老值之间的差值
    NSInteger diff = updateValue - [array[index] integerValue];
    
    // 更新数组的值
    NSMutableArray *replace = [[NSMutableArray alloc] initWithArray:array];
    replace[index] = [NSNumber numberWithInteger:updateValue];
    array = [NSArray arrayWithArray:replace];
    
    // 更新线段树节点的值
    [self updateSegmentTreeValue:segArray start:0 end:count-1 updateIndex:index diff:diff index:0];
}

// 递归函数，为数组[start...end]构建线段树
// index 是线段树st内当前节点的下标
- (NSInteger)setupTreeSegment:(NSArray *)array start:(NSInteger)start end:(NSInteger)end index:(NSInteger)index sumArray:(NSMutableArray *)sumArray {
    // 如果数组只包含一个元素 将其存储与线段树的当前节点并返回
    if (start == end) {
        sumArray[index] = array[start];
        return [array[start] integerValue];
    }
    
    // 如果有不止一个元素， 则递归计算左右子树，并将两者之和存储与节点内，并返回
    NSInteger mid = [self getTreeMid:start end:end];
    NSInteger left = [self setupTreeSegment:array start:start end:mid index:(index * 2 + 1) sumArray:sumArray];
    NSInteger right = [self setupTreeSegment:array start:(mid + 1) end:end index:(index * 2 + 2) sumArray:sumArray];
    sumArray[index] = [NSNumber numberWithInteger:(left + right)];
    return [sumArray[index] integerValue];
}

/*
 从给定数组构建线段树的函数。
 函数为线段树分配内存空间，并调用函数setupTreeSegment()
 来填充分配的内存
*/
- (NSMutableArray *)setupConstruct:(NSArray *)array count:(NSInteger)count {
    NSInteger x = ceilf(log2f(count));//3
    NSInteger max = ceilf(2 * powf(2, x)) - 1;//15
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:max];
    for (NSInteger i = 0; i < max; i++) {
        [list addObject:[NSNumber numberWithInteger:0]];
    }
    [self setupTreeSegment:array start:0 end:(count-1) index:0 sumArray:list];
    return list;
}

- (void)segmentTree {
    NSString *html = @"var list = [1, 3, 5, 7, 9, 11]";
    NSArray *list = @[@1, @3, @5, @7, @9, @11];
    NSInteger count = list.count;
    
    NSMutableArray *segments = [self setupConstruct:list count:count];
    NSLog(@"segments: %@",segments);
    html = [html stringByAppendingFormat:@"\n生成的线段树:%@",segments];
    
    NSInteger sum = [self getTreeSum:segments count:count segStart:1 segEnd:3];
    NSLog(@"输出下标1 到 3的元素之和: %@",@(sum));
    html = [html stringByAppendingFormat:@"\n输出下标1 到 3的元素之和: %@",@(sum)];
    
    // 更新: 令 arr[1] = 10  并更新相应的线段树节点
    [self updateTreeValue:list segArray:segments count:count index:1 updateValue:10];
    NSLog(@"令 arr[1] = 10  并更新相应的线段树节点: %@\n %@\n",list,segments);
    html = [html stringByAppendingFormat:@"\n令 arr[1] = 10  并更新相应的线段树节点: %@\n %@\n",list,segments];
    
    // 输出更新后的和值
    sum = [self getTreeSum:segments count:count segStart:1 segEnd:3];
    NSLog(@"输出更新后下标1 到 3的元素之和: %@",@(sum));
    html = [html stringByAppendingFormat:@"\n输出更新后下标1 到 3的元素之和: %@",@(sum)];
    self.resultView.text = html;
}

#pragma mark - Topic

- (NSString *)controllTopic {
    NSString *topic = @"";
    switch (self.type) {
        case MathTypeSegmentTree:
            topic = @"给定一个数组arr[0 . . . n-1]，我们要对数组执行这样的操作：\n计算从下标l到r的元素之和，其中 0 <= l <= r <= n-1;\n修改数组指定元素的值arr[i] = x，其中 0 <= i <= n-1";
            break;
            
        default:
            break;
    }
    return topic;
}

#pragma mark - Title

- (NSString *)controllerTitle {
    NSString *title = @"算法DEMO";
    switch (self.type) {
        case MathTypeSegmentTree:
            title = @"线段树算法";
            break;
            
        default:
            break;
    }
    return title;
}

@end
