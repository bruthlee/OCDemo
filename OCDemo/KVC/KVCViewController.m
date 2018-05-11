//
//  KVCViewController.m
//  OCDemo
//
//  Created by hollywater on 2018/5/11.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "KVCViewController.h"

#import "KVCModel.h"
#import "DemoObject.h"

@interface KVCViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *operationList;
@property (nonatomic, strong) NSArray *unionList;
@end

@implementation KVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"KVC";
    
    /*
     *  https://juejin.im/post/5ac5f4b46fb9a028d5675645
     */
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)normalSetValue {
    //查找_name
    KVCModel *obj = [[KVCModel alloc] init];
    [obj setValue:@"normalSetValue" forKey:@"name"];
    NSString *name = [obj valueForKey:@"name"];
    NSLog(@"normalSetValue name is %@",name);
}

- (void)normalSetValueByIs {
    //查找_isName
    KVCModel *obj = [[KVCModel alloc] init];
    [obj setValue:@"normalSetValueByIs" forKey:@"name"];
    NSString *name = [obj valueForKey:@"name"];
    NSLog(@"normalSetValueByIs name is %@",name);
}

- (void)undirectlyInstanceValiables {
    //禁止查找时会直接调用setValue forUndefinedKey
    KVCModel *obj = [[KVCModel alloc] init];
    obj.shouldInstanceVariablesDirectly = NO;
    [obj setValue:@"undirectlyInstanceValiables" forKey:@"name"];
    NSString *name = [obj valueForKey:@"name"];
    NSLog(@"undirectlyInstanceValiables name is %@",name);
}

- (void)undirectlyInstanceValiablesAndPermitSet {
    //禁止查找时会直接调用setValue forUndefinedKey
//    KVCModel *obj = [[KVCModel alloc] init];
//    obj.shouldInstanceVariablesDirectly = NO;
//    obj.canSetValue = YES;
//    [obj setValue:@"undirectlyInstanceValiablesAndPermitSet" forKey:@"name"];
//    NSString *name = [obj valueForKey:@"name"];
//    NSLog(@"undirectlyInstanceValiablesAndPermitSet name is %@",name);
    NSLog(@"死循环了.....");
}

#pragma mark - KVC Operation(sum,avg,count,max,min)

- (void)kvcOperationSumTest {
    NSArray *list = self.operationList;
    NSNumber *sum = [list valueForKeyPath:@"@sum.price"];
    NSLog(@"sum of price is %@",sum);
}

- (void)kvcOperationAverageTest {
    NSArray *list = self.operationList;
    NSNumber *sum = [list valueForKeyPath:@"@avg.price"];
    NSLog(@"average of price is %@",sum);
}

- (void)kvcOperationCountTest {
    NSArray *list = self.operationList;
    NSNumber *sum = [list valueForKeyPath:@"@count"];
    NSLog(@"count of list is %@",sum);
}

- (void)kvcOperationMaxTest {
    NSArray *list = self.operationList;
    NSNumber *sum = [list valueForKeyPath:@"@max.price"];
    NSLog(@"max of price is %@",sum);
}

- (void)kvcOperationMinTest {
    NSArray *list = self.operationList;
    NSNumber *sum = [list valueForKeyPath:@"@min.price"];
    NSLog(@"min of price is %@",sum);
}

#pragma mark - KVC Union(@distinctUnionOfObjects, @unionOfObjects)

- (void)kvcDistinctUnionOfObjectsTest {
    NSLog(@"==========================");
    /**
     *  对集合的指定属性去重操作
     */
    NSArray *list = self.unionList;
    NSArray *result = [list valueForKeyPath:@"@distinctUnionOfObjects.price"];
    NSLog(@"distinctUnionOfObjects.price result is:");
    for (NSNumber *item in result) {
        NSLog(@"price is %@",item);
    }
    //result = @[@2, @4]
}

- (void)kvcUnionOfObjectsTest {
    NSLog(@"==========================");
    /**
     *  通过集合的指定属性生成新的集合，不做去重
     */
    NSArray *list = self.unionList;
    NSArray *result = [list valueForKeyPath:@"@unionOfObjects.price"];
    NSLog(@"unionOfObjects.price result is:");
    for (NSNumber *item in result) {
        NSLog(@"price is %@",item);
    }
    //result = @[@2, @4, @2, @4]
}

#pragma mark - KVC NSDictionary

- (void)modelToDicTest {
    KVCModel *model = [KVCModel new];
    model.name = @"hollywater";
    model.price = 100.0;
    NSArray *keys = @[@"name", @"price"];
    NSDictionary *dic = [model dictionaryWithValuesForKeys:keys];
    NSLog(@"model to dic is : %@",dic);
}

#pragma mark - 进阶用法

- (void)kvoForStringTest {
    NSLog(@"======================");
//    NSArray *languages = @[@"chinese", @"english", @"french", @"russia"];
    NSArray *languages = @[@"chiNese", @"engLish", @"frEnch", @"rusSia"];
    NSArray *result = [languages valueForKey:@"capitalizedString"];
    NSLog(@"变换前: %@", [languages componentsJoinedByString:@", "]);
    NSLog(@"变化后: %@", [result componentsJoinedByString:@", "]);
    result = [languages valueForKey:@"uppercaseString"];
    NSLog(@"变化后: %@", [result componentsJoinedByString:@", "]);
    result = [languages valueForKey:@"lowercaseString"];
    NSLog(@"变化后: %@", [result componentsJoinedByString:@", "]);
    
    NSArray *strLength = [languages valueForKeyPath:@"capitalizedString.length"];
    NSLog(@"获取到的字符串长度分别是: %@",[strLength componentsJoinedByString:@", "]);
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DemoSection *sec = [self.dataSource objectAtIndex:section];
    return sec.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell instanceWithTableView:tableView identifier:@"kvcTestCell"];
    DemoSection *section = [self.dataSource objectAtIndex:indexPath.section];
    DemoObject *obj = [section.list objectAtIndex:indexPath.row];
    cell.titleLabel.text = obj.name;
    cell.bgView.backgroundColor = (UIColor *)(obj.data);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DemoSection *sec = [self.dataSource objectAtIndex:section];
    return sec.title;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoSection *section = [self.dataSource objectAtIndex:indexPath.section];
    DemoObject *obj = [section.list objectAtIndex:indexPath.row];
    if (obj.method) {
        SEL selector = NSSelectorFromString(obj.method);
        [self performSelector:selector withObject:nil afterDelay:0.0];
    }
}

#pragma mark - Data

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if (812.0 == [UIScreen mainScreen].bounds.size.height) {
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 34.0, 0);
        }
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[[self firstSection], [self secondSection],
                        [self thirdSection], [self fourthSection],
                        [self fifthSection]];
    }
    return _dataSource;
}

- (DemoSection *)firstSection {
    DemoObject *normal = [DemoObject initWithName:@"normalSetValue" method:@"normalSetValue"];
    normal.data = [UIColor brownColor];
    DemoObject *findByIs = [DemoObject initWithName:@"normalSetValueByIs" method:@"normalSetValueByIs"];
    findByIs.data = [UIColor yellowColor];
    DemoObject *noInstance = [DemoObject initWithName:@"undirectlyInstanceValiables" method:@"undirectlyInstanceValiables"];
    noInstance.data = [UIColor purpleColor];
    DemoObject *noInstanceBySet = [DemoObject initWithName:@"undirectlyInstanceValiablesAndPermitSet" method:@"undirectlyInstanceValiablesAndPermitSet"];
    noInstanceBySet.data = [UIColor cyanColor];
    DemoSection *first = [DemoSection initWithTitle:@"Base" list:@[normal, findByIs, noInstance, noInstanceBySet]];
    return first;
}

- (DemoSection *)secondSection {
    DemoObject *sum = [DemoObject initWithName:@"Operation - Sum(@sum)" method:@"kvcOperationSumTest"];
    sum.data = [UIColor redColor];
    DemoObject *avg = [DemoObject initWithName:@"Operation - Average(@avg)" method:@"kvcOperationAverageTest"];
    avg.data = [UIColor blueColor];
    DemoObject *count = [DemoObject initWithName:@"Operation - Count(@count)" method:@"kvcOperationCountTest"];
    count.data = [UIColor greenColor];
    DemoObject *max = [DemoObject initWithName:@"Operation - Max(@max)" method:@"kvcOperationMaxTest"];
    max.data = [UIColor magentaColor];
    DemoObject *min = [DemoObject initWithName:@"Operation - Min(@min)" method:@"kvcOperationMinTest"];
    min.data = [UIColor grayColor];
    DemoSection *second = [DemoSection initWithTitle:@"Operation" list:@[sum, avg, count, max, min]];
    return second;
}

- (DemoSection *)thirdSection {
    DemoObject *dis = [DemoObject initWithName:@"DistinctUnionOfObjects" method:@"kvcDistinctUnionOfObjectsTest"];
    dis.data = [UIColor orangeColor];
    DemoObject *uni = [DemoObject initWithName:@"UnionOfObjects" method:@"kvcUnionOfObjectsTest"];
    uni.data = [UIColor lightGrayColor];
    DemoSection *third = [DemoSection initWithTitle:@"Union & Distinct Objects" list:@[dis, uni]];
    return third;
}

- (DemoSection *)fourthSection {
    DemoObject *model = [DemoObject initWithName:@"Model to Dictionary" method:@"modelToDicTest"];
    model.data = [UIColor cyanColor];
    DemoSection *fourth = [DemoSection initWithTitle:@"Change" list:@[model]];
    return fourth;
}

- (DemoSection *)fifthSection {
    DemoObject *obj1 = [DemoObject initWithName:@"字符串整合" method:@"kvoForStringTest"];
    obj1.data = [UIColor colorWithDisplayP3Red:1.0 green:0.376 blue:0.412 alpha:1.0];
    DemoSection *fifth = [DemoSection initWithTitle:@"进阶" list:@[obj1]];
    return fifth;
}

- (NSArray *)operationList {
    if (!_operationList) {
        KVCModel *obj1 = [KVCModel new];
        obj1.name = @"obj1";
        obj1.price = 2.;
        KVCModel *obj2 = [KVCModel new];
        obj2.name = @"obj2";
        obj2.price = 4.;
        KVCModel *obj3 = [KVCModel new];
        obj3.name = @"obj3";
        obj3.price = 6.;
        KVCModel *obj4 = [KVCModel new];
        obj4.name = @"obj4";
        obj4.price = 8.;
        _operationList = @[obj1, obj2, obj3, obj4];
        NSLog(@"price is 2.0, 4.0, 6.0, 8.0");
    }
    return _operationList;
}

- (NSArray *)unionList {
    if (!_unionList) {
        KVCModel *obj1 = [KVCModel new];
        obj1.name = @"obj1";
        obj1.price = 2.;
        KVCModel *obj2 = [KVCModel new];
        obj2.name = @"obj2";
        obj2.price = 4.;
        KVCModel *obj3 = [KVCModel new];
        obj3.name = @"obj3";
        obj3.price = 2.;
        KVCModel *obj4 = [KVCModel new];
        obj4.name = @"obj4";
        obj4.price = 4.;
        _unionList = @[obj1, obj2, obj3, obj4];
        NSLog(@"price is 2.0, 4.0, 2.0, 4.0");
    }
    return _unionList;
}

@end
