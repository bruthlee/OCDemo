//
//  JHChartViewController.m
//  OCDemo
//
//  Created by lixy on 2017/12/4.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "JHChartViewController.h"

#import <JHLineChart.h>
#import <JHPieChart.h>
#import <JHRingChart.h>
#import <JHWaveChart.h>
#import <JHRadarChart.h>
#import <JHTableChart.h>
#import <JHColumnChart.h>
#import <JHScatterChart.h>


@interface JHChartViewController () <JHColumnChartDelegate, JHTableChartDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation JHChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"JHCharts Demo";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGRect rect = self.view.bounds;
    rect.size.height -= 64.0;
    if (@available(iOS 11.0, *)) {
        rect.size.height -= self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    switch (self.type) {
        case JHChartTypeLine:
            [self testLineChart];
            break;
        case JHChartTypePie:
            [self setupPieChart];
            break;
        case JHChartTypeRing:
            [self setupRingChart];
            break;
        case JHChartTypeColumn:
            [self setupColumnChart];
            break;
        case JHChartTypeRadar:
            [self setupRadarChart];
            break;
        case JHChartTypeTable:
            [self setupTableChart];
            break;
        case JHChartTypeScatter:
            [self setupScatterChart];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Line Chart

- (void)testLineChart {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGRect rect = CGRectMake(10, 10, width - 20, 300);
    [self setupLineChart:rect type:JHLineChartQuadrantTypeFirstQuardrant];
    
    rect.origin.y += rect.size.height + 20;
    [self setupLineChart:rect type:JHLineChartQuadrantTypeFirstAndSecondQuardrant];
    
    rect.origin.y += rect.size.height + 20;
    [self setupLineChart:rect type:JHLineChartQuadrantTypeFirstAndFouthQuardrant];
    
    rect.origin.y += rect.size.height + 20;
    [self setupLineChart:rect type:JHLineChartQuadrantTypeAllQuardrant];
    
    self.scrollView.contentSize = CGSizeMake(width, CGRectGetMaxY(rect) + 20);
}

- (void)setupLineChart:(CGRect)rect type:(JHLineChartQuadrantType)type {
    JHLineChart *chart = [[JHLineChart alloc] initWithFrame:rect andLineChartType:JHChartLineValueNotForEveryX];
    chart.lineChartQuadrantType = type;
    [self setupLineChartData:chart];
    chart.valueLineColorArr = @[[UIColor purpleColor], [UIColor brownColor]];
    chart.pointColorArr = @[[UIColor orangeColor], [UIColor yellowColor]];
    chart.xAndYLineColor = [UIColor grayColor];
    chart.xAndYNumberColor = [UIColor blackColor];
    [self.scrollView addSubview:chart];
    [chart showAnimation];
}

- (void)setupLineChartData:(JHLineChart *)chart {
    switch (chart.lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:
            chart.xLineDataArr = @[@"0",@"1",@"2",@3,@4,@5,@6,@7];
            chart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6,@7],@[@"3",@"1",@"2",@16,@2,@3,@5,@10]];
            break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
            chart.xLineDataArr = @[@[@"-3",@"-2",@"-1"], @[@"0",@"1",@"2",@"3"]];
            chart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@7],@[@"3",@"1",@"2",@16,@2,@5,@10]];
            break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
            chart.xLineDataArr = @[@"",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份"];
            chart.valueArr = @[@[@"5",@"-220",@"170",@(-4),@25,@5,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];
            break;
        case JHLineChartQuadrantTypeAllQuardrant:
            chart.xLineDataArr = @[@[@"-3",@"-2",@"-1"],@[@0,@1,@2,@3]];
            chart.valueArr = @[@[@"5",@"-22",@"70",@(-4),@25,@15,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];
            break;
            
        default:
            break;
    }
}

#pragma mark - Pie Chart

- (void)setupPieChart {
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(100, 100, 321, 421)];
    pie.backgroundColor = [UIColor groupTableViewBackgroundColor];
    /* Pie chart value, will automatically according to the percentage of numerical calculation */
    pie.valueArr = @[@18,@14,@25,@40,@18,@18,@25,@40];
    /* The description of each sector must be filled, and the number must be the same as the pie chart. */
    pie.descArr = @[@"第一个元素",@"第二个元素",@"第三个元素",@"第四个元素",@"5",@"6",@"7",@"8"];
    //    pie.backgroundColor = [UIColor whiteColor];
    pie.didClickType = JHPieChartDidClickTranslateToBig;
    pie.animationDuration = 1.0;
    [self.scrollView addSubview:pie];
    /*    When touching a pie chart, the animation offset value     */
    pie.positionChangeLengthWhenClick = 15;
    pie.showDescripotion = NO;
    pie.animationType = JHPieChartAnimationByOrder;
    //    pie.colorArr = @[[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor yellowColor]];
    pie.center = self.scrollView.center;
    /*        Start animation         */
    [pie showAnimation];
}

#pragma mark - Ring Chart

- (void)setupRingChart {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, width, width)];
    /*        background color         */
    ring.backgroundColor = [UIColor whiteColor];
    /*        Data source array, only the incoming value, the corresponding ratio will be automatically calculated         */
    ring.valueDataArr = @[@"0.5",@"5",@"2",@"10",@"6",@"6"];
    /*         Width of ring graph        */
    ring.ringWidth = 35.0;
    /*        Fill color for each section of the ring diagram         */
    ring.fillColorArray = @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]];
    /*        Start animation             */
    [ring showAnimation];
    [self.scrollView addSubview:ring];
}

#pragma mark - Column Chart

- (void)setupColumnChart {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 64, width, 320)];
    /*        Create an array of data sources, each array is a module data. For example, the first array can represent the average score of a class of different subjects, the next array represents the average score of different subjects in another class        */
    column.valueArr = @[
                        @[@[@15,@10]],//第一组元素 如果有多个元素，往该组添加，每一组只有一个元素，表示是单列柱状图| | | | |
                        @[@[@15,@20]],//第二组元素
                        @[@[@10,@5]],//第三组元素
                        @[@[@21,@12]],
                        @[@19],
                        @[@12],
                        @[@15],
                        @[@9],
                        @[@8],
                        @[@6],
                        @[@9],
                        @[@18],
                        @[@11],
                        ];
    /*       This point represents the distance from the lower left corner of the origin.         */
    column.originSize = CGPointMake(30, 20);
    /*    The first column of the distance from the starting point     */
    column.drawFromOriginX = 20;
    column.backgroundColor = [UIColor yellowColor];
    column.typeSpace = 10;
    column.isShowYLine = NO;
    column.contentInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    /*        Column width         */
    column.columnWidth = 30;
    /*        Column backgroundColor         */
    column.bgVewBackgoundColor = [UIColor yellowColor];
    /*        X, Y axis font color         */
    column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    column.colorForXYLine = [UIColor darkGrayColor];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    column.columnBGcolorsArr = @[@[[UIColor redColor],[UIColor greenColor]],@[[UIColor redColor],[UIColor greenColor]],@[[UIColor redColor],[UIColor greenColor]]];//如果为复合型柱状图 即每个柱状图分段 需要传入如上颜色数组 达到同时指定复合型柱状图分段颜色的效果
    /*        Module prompt         */
    column.xShowInfoText = @[@"A班级",@"B班级",@"C班级",@"D班级",@"E班级",@"F班级",@"G班级",@"H班级",@"i班级",@"J班级",@"L班级",@"M班级",@"N班级"];
    column.isShowLineChart = YES;
    column.lineValueArray =  @[
                               @6,
                               @12,
                               @10,
                               @1,
                               @9,
                               @5,
                               @9,
                               @9,
                               @5,
                               @6,
                               @4,
                               @8,
                               @11
                               ];
    
    column.delegate = self;
    /*       Start animation        */
    [column showAnimation];
    [self.scrollView addSubview:column];
}

#pragma mark - Table Chart

- (void)setupTableChart {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(10, 84, width-20, width * 2)];
    /*       Table name         */
    //    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
    //    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"",@"",@"",@"",@"",@""];
    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"专业评价"];
    /*        The width of the column array, starting with the first column         */
    table.colWidthArr = @[@80.0,@100.0,@70,@40,@100];
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    UIColor *textColor = [UIColor redColor];
    /*        Text color of the table body         */
    table.bodyTextColor = textColor;
    
    table.bodyTextFont = [UIFont systemFontOfSize:5];
    /*        Text color for every column         */
    table.bodyTextColorArr = @[textColor,textColor,textColor,textColor,[UIColor blueColor]];
    /*        Minimum grid height         */
    table.minHeightItems = 35;
    /*        The height of the column title*/
    table.colTitleHeight = 80;
    /*        Text color of the column title*/
    table.colTitleColor = [UIColor grayColor];
    /*        Font of the column title*/
    table.colTitleFont = [UIFont systemFontOfSize:15];
    /*        Text color for every column title        */
    //    table.colTitleColorArr = @[textColor,textColor,textColor,textColor,[UIColor greenColor]];
    /*        Font of the table body*/
    //    table.bodyTextFont = [UIFont systemFontOfSize:14];
    /*        Table line color         */
    table.lineColor = [UIColor orangeColor];
    table.tableTitleString = @"库存";
    table.backgroundColor = [UIColor whiteColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    table.dataArr = @[
                      @[@"2.4L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"],@"价格十分优惠，相信市场会非常好"],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"],@"性价比还不错，内部配置较为不错，值得入手"]                      ];
    table.delegate = self;
    /*        show                            */
    [table showAnimation];
    [self.scrollView addSubview:table];
    
    /*        Automatic calculation table height        */
    table.frame = CGRectMake(10, 64, width-20, [table heightFromThisDataSource]);
    
    [table clear];
    table.dataArr = @[
                      @[@"2.0L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"],@"价格十分优惠，相信市场会非常好"],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"],@"性价比还不错，内部配置较为不错，值得入手"]                      ];
    [table showAnimation];
}

#pragma mark - Radar Chart

- (void)setupRadarChart {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    JHRadarChart *radarChart = [[JHRadarChart alloc] initWithFrame:CGRectMake(10, 74, width - 20, width - 20)];
    radarChart.backgroundColor = [UIColor whiteColor];
    /*       Each point of the description text, according to the number of the array to determine the number of basic modules         */
    radarChart.valueDescArray = @[@"击杀",@"能力",@"生存",@"推塔",@"补兵",@"其他"];
    
    /*         Number of basic module layers        */
    radarChart.layerCount = 5;
    
    /*        Array of data sources, the need to add an array of arrays         */
    radarChart.valueDataArray = @[@[@"80",@"40",@"100",@"76",@"75",@"50"],@[@"50",@"80",@"30",@"46",@"35",@"50"]];
    
    /*        Color of each basic module layer         */
    radarChart.layerFillColor = [UIColor colorWithRed:94/ 256.0 green:187/256.0 blue:242 / 256.0 alpha:0.5];
    
    /*        The fill color of the value module is required to specify the color for each value module         */
    radarChart.valueDrawFillColorArray = @[[UIColor colorWithRed:57/ 256.0 green:137/256.0 blue:21 / 256.0 alpha:0.5],[UIColor colorWithRed:149/ 256.0 green:68/256.0 blue:68 / 256.0 alpha:0.5]];
    
    /*       show        */
    [radarChart showAnimation];
    
    [self.scrollView addSubview:radarChart];
}

#pragma mark - Scatter Chart

- (void)setupScatterChart {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    /*        创建对象         */
    JHScatterChart *scatterChart = [[JHScatterChart alloc] initWithFrame:CGRectMake(0, 64, width, 320)];
    
    /*        X轴刻度值         */
    scatterChart.xLineDataArray = @[@0,@1,@2,@3,@4,@5];
    
    /*        点的数组         */
    scatterChart.valueDataArray = @[
                                    [NSValue valueWithCGPoint:P_M(0, 1)],
                                    [NSValue valueWithCGPoint:P_M(0.5, 5.7)],
                                    [NSValue valueWithCGPoint:P_M(0.6, 5)],
                                    [NSValue valueWithCGPoint:P_M(0.7, 5)],
                                    [NSValue valueWithCGPoint:P_M(1, 3)],
                                    [NSValue valueWithCGPoint:P_M(0.2, 9)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.5, 7.5)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5,4)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 2)],
                                    [NSValue valueWithCGPoint:P_M(4.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(3.2, 8.3)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 5.3)],
                                    [NSValue valueWithCGPoint:P_M(2, 3)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5)],
                                    [NSValue valueWithCGPoint:P_M(2, 11)],
                                    [NSValue valueWithCGPoint:P_M(6, 15)],
                                    [NSValue valueWithCGPoint:P_M(1, 3)],
                                    [NSValue valueWithCGPoint:P_M(1, 1)],
                                    [NSValue valueWithCGPoint:P_M(2.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(3.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(4, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(1.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 6.5)],
                                    [NSValue valueWithCGPoint:P_M(2.2,4)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(1.2, 9.8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 7)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]  ,
                                    
                                    [NSValue valueWithCGPoint:P_M(0.7, 14)],
                                    [NSValue valueWithCGPoint:P_M(0.9, 2)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 12.7)],
                                    [NSValue valueWithCGPoint:P_M(0.1, 3)],
                                    [NSValue valueWithCGPoint:P_M(0.3, 2)],
                                    [NSValue valueWithCGPoint:P_M(0.3, 2.3)],
                                    [NSValue valueWithCGPoint:P_M(0.5, 2.5)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(1.2, 7)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(1.4, 3)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 8)],
                                    [NSValue valueWithCGPoint:P_M(1.3, 1.3)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 1.8)],
                                    [NSValue valueWithCGPoint:P_M(1.7, 1.4)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)],
                                    
                                    [NSValue valueWithCGPoint:P_M(0.7, 7.5)],
                                    [NSValue valueWithCGPoint:P_M(0.6, 11)],
                                    [NSValue valueWithCGPoint:P_M(0.8, 15)],
                                    [NSValue valueWithCGPoint:P_M(4, 3)],
                                    [NSValue valueWithCGPoint:P_M(5, 8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(4.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 7)],
                                    [NSValue valueWithCGPoint:P_M(4.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(3.2, 8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 7)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]];
    scatterChart.contentInsets = UIEdgeInsetsMake(10, 40, 20, 10);
    [scatterChart showAnimation];
    [self.scrollView addSubview:scatterChart];
}

#pragma mark - Column Chart Delegate

-(void)columnChart:(JHColumnChart*)chart columnItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

-(void)columnChart:(JHColumnChart*)chart columnItem:(JHColumnItem *)item didClickAtIndexPath:(JHIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

#pragma mark - Table Chart Delegate

-(UIView *)tableChart:(JHTableChart*)chart viewForContentAtRow:(NSInteger)row column:(NSInteger)column subRow:(NSInteger)subRow contentSize:(CGSize)contentSize{
    
    if (1) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        vi.backgroundColor = [UIColor greenColor];
        return vi;
    }
    return nil;
}

-(UIView *)tableChart:(JHTableChart*)chart viewForPropertyAtColumn:(NSInteger)column contentSize:(CGSize)contentSize{
    if (1) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        vi.backgroundColor = [UIColor greenColor];
        return vi;
    }
    return nil;
}

-(UIView *)tableChart:(JHTableChart*)chart viewForTableHeaderWithContentSize:(CGSize)contentSize{
    
    //    return nil;
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    vi.backgroundColor = [UIColor greenColor];
    return vi;
}

@end
