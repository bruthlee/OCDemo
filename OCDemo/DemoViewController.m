//
//  DemoViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "DemoViewController.h"

#import <objc/runtime.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>

#import "PersonObject.h"
#import "DemoObject.h"
#import "DataCenter.h"

#import "MasonaryViewController.h"
#import "FetchedResultViewController.h"
#import "DynamicAnimatorViewController.h"
#import "CollisionBehaviorController.h"
#import "LaunchAnimatedController.h"
#import "MathViewController.h"
#import "LLLinkViewController.h"
#import "JHChartViewController.h"
#import "FontViewController.h"
#import "VideoViewController.h"
#import "YUMainTableViewController.h"
#import "SocketViewController.h"
#import "SchemaViewController.h"
#import "OperationViewController.h"
#import "WeakSelfViewController.h"
#import "KVOViewController.h"
#import "WebViewController.h"
#import "TabBarTestController.h"
#import "LifeCycleViewController.h"

@interface DemoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self demoDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)runTimer {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        while (1) {
            NSLog(@"date1: %@",[NSDate date]);
            sleep(1);
        }
    }];
    [queue addOperation:block];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (1) {
            NSLog(@"date2: %@",[NSDate date]);
            sleep(1);
        }
    });
}

#pragma mark - Masonary

- (void)showMasonarySimpleDemo {
    [self showMasonaryDemo:0];
}

- (void)showMasonaryRelative {
    [self showMasonaryDemo:1];
}

- (void)showMasonaryDemo:(NSInteger)type {
    MasonaryViewController *ctrl = [[MasonaryViewController alloc] init];
    ctrl.type = type;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - Runtime

- (void)testRuntimeMethods {
    [self testMethodImp:@selector(testRuntimeMethods)];
}

- (void)testMethodImp:(SEL)selector {
    NSString *className = NSStringFromClass([self class]);
    const char * classChar = [className UTF8String];
    
    //class_getMethodImplementation
    IMP instanceImp1 = class_getMethodImplementation(objc_getClass(classChar), selector);
    NSLog(@"[instanceImp1] : %p",instanceImp1);
    
    IMP instanceImp2 = class_getMethodImplementation(objc_getMetaClass(classChar), selector);
    NSLog(@"[instanceImp2] : %p",instanceImp2);
    
    //class_getInstanceMethod
    Method instanceMethod1 = class_getInstanceMethod(objc_getClass(classChar), selector);
    IMP instanceImp3 = method_getImplementation(instanceMethod1);
    NSLog(@"[instanceImp3] : %p",instanceImp3);
    
    Method instanceMethod2 = class_getInstanceMethod(objc_getMetaClass(classChar), selector);
    IMP instanceImp4 = method_getImplementation(instanceMethod2);
    NSLog(@"[instanceImp4] : %p",instanceImp4);
}

#pragma mark - Equal

- (void)testCustomEqual {
    NSMutableSet *mutSet = [NSMutableSet set];
    PersonObject *person1 = [[PersonObject alloc] initWithID:1 name:@"nihao"];
    PersonObject *person2 = [[PersonObject alloc] initWithID:2 name:@"nihao2"];
    //hash = 1,addressValue = 105827994405984,address = 0x604000038c60
    [mutSet addObject:person1];
    //add 0x604000038c60(1,nihao)
    NSLog(@"add %@",person1);
    
    //hash = 2,addressValue = 105827994406016,address = 0x604000038c80
    [mutSet addObject:person2];
    //add 0x604000038c80(2,nihao2)
    NSLog(@"add %@",person2);
    
    //2
    NSLog(@"count = %ld",mutSet.count);
    
    PersonObject *person3 = [[PersonObject alloc] initWithID:1 name:@"nihao"];
    //hash = 1,addressValue = 105553116472608,address = 0x600000032520
    [mutSet addObject:person3];
    //add 0x600000032520(1,nihao)
    NSLog(@"add %@",person3);
    
    //2
    NSLog(@"count = %ld",mutSet.count);
    
    UIColor *color1 = [UIColor redColor];
    NSLog(@"color1 = %@",color1);//(UICachedDeviceRGBColor *) $0 = 0x000060400046de40; UIExtendedSRGBColorSpace 1 0 0 1
    UIColor *color2 = [UIColor redColor];
    NSLog(@"color2 = %@",color2);//(UICachedDeviceRGBColor *) $0 = 0x000060400046de40; UIExtendedSRGBColorSpace 1 0 0 1
    //color1 == color2 = YES
    NSLog(@"color1 == color2 = %@", color1 == color2 ? @"YES" : @"NO");
    //[color1 isEqual:color2] = YES
    NSLog(@"[color1 isEqual:color2] = %@", [color1 isEqual:color2] ? @"YES" : @"NO");
    
    UIColor *color3 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    NSLog(@"color3 = %@",color3);
    UIColor *color4 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    NSLog(@"color4 = %@",color4);
    //color3 == color4 = NO
    NSLog(@"color3 == color4 = %@", color3 == color4 ? @"YES" : @"NO");
    //[color3 isEqual:color4] = YES
    NSLog(@"[color3 isEqual:color4] = %@", [color3 isEqual:color4] ? @"YES" : @"NO");
}

#pragma mark - Grand Central Dispatch

- (void)testDispatchQueue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"任务1.");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"任务2.");
        });
        NSLog(@"任务3.");
    });
    
    NSLog(@"任务4.");
    /*
     while (1) {
     
     }
     */
}

- (void)testDispatchSemaphore1 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int count = 1;
    dispatch_async(queue, ^{
        count = 100;
        NSLog(@"[1] count = %d",count);
        dispatch_semaphore_signal(semaphore);
    });
    //加上semaphore，保证block异步执行后的数据count能被后面的代码正常访问
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //如果不加此句代码，count输出为1，否则是异步执行后的结果100
    NSLog(@"[2] count = %d",count);
}

- (void)testDispatchSemaphore2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            // 相当于加锁，保证按顺序执行queue
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"i = %d", i);
            // 相当于解锁
            dispatch_semaphore_signal(semaphore);
        });
    }
}

- (void)testDispatchSemaphore3 {
    //create的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}

- (void)testDispatchApply {
    int count = 10;
    int stride = 3;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(count / stride, queue, ^(size_t index) {
        size_t j = index * stride;
        size_t j_stop = index;
        printf("=============1========[j=%zu]=======\n",j);
        printf("=============2========[j_stop=%zu]=======\n",j_stop);
        do {
            printf("%u\n",(unsigned int)j);
        }while (j < j_stop);
    });
    
    printf("==============3==============\n");
    printf("==============4==============\n");
    size_t i;
    for (i = count - (count % stride); i < count; i++) {
        printf("%u\n",(unsigned int)i);
    }
}

#pragma mark - ARC

- (void)testWeakRetain {
    NSObject *ob = [[NSObject alloc] init];
    __weak NSObject *weakOb = ob;
    NSLog(@"[1] %@",weakOb);
    NSLog(@"[2] %@",weakOb);
    NSLog(@"[3] %@",weakOb);
    NSLog(@"[4] %@",weakOb);
    NSLog(@"[5] %@",weakOb);
    
    NSObject *ot = [[NSObject alloc] init];
    __weak NSObject *weakOt = ot;
    __strong NSObject *strongOt = weakOt;
    NSLog(@"[11] %@",strongOt);
    NSLog(@"[22] %@",strongOt);
    NSLog(@"[33] %@",strongOt);
    NSLog(@"[44] %@",strongOt);
    NSLog(@"[55] %@",strongOt);
}

- (void)testObjectCount {
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"abc",@"123", nil];
    NSLog(@"array1 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array1));//1
    
    NSArray *array13 = [[NSArray alloc] initWithObjects:@"abc",@"123",@"abc",@"123", nil];
    NSLog(@"array13 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array13));//1
    
    NSArray *array2 = [NSArray arrayWithObjects:@"abc",@"123",nil];
    NSLog(@"array2 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array2));//2
    
    NSArray *array12 = [NSArray arrayWithObjects:@"abc",@"123",@"abc",@"123",nil];
    NSLog(@"array12 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array12));//2
    
    NSMutableArray *array3 = [[NSMutableArray alloc] init];
    NSLog(@"array3 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array3));//1
    
    NSMutableArray *array4 = [NSMutableArray array];
    NSLog(@"array4 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array4));//1
    
    NSMutableArray *array5 = [NSMutableArray arrayWithCapacity:2];
    NSLog(@"array5 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array5));//1
    
    NSMutableArray *array6 = [NSMutableArray arrayWithObjects:@"123",@"abc", nil];
    NSLog(@"array6 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array6));//2
    
    NSMutableArray *array7 = [NSMutableArray arrayWithObjects:array1, nil];
    NSLog(@"array7 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array7));//2
    
    NSMutableArray *array8 = [NSMutableArray arrayWithObjects:@"hgh",array1, nil];
    NSLog(@"array8 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array8));//2
    
    NSArray *array9 = [NSArray arrayWithArray:array1];
    NSLog(@"array9 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array9));//1
    
    NSMutableArray *array10 = [NSMutableArray arrayWithArray:array1];
    NSLog(@"array10 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array10));//1
    
    NSMutableArray *array11 = [NSMutableArray arrayWithObjects:array2,array1, nil];
    NSLog(@"array11 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array11));//2
    
    NSArray *array14 = [NSArray array];
    NSLog(@"array14 count : %ld",CFGetRetainCount((__bridge CFTypeRef)array14));//-1
}

- (void)testFtoCoreF {
    CFMutableArrayRef cfArrayRef = NULL;
    {
        id obj = [[NSMutableArray alloc] init];
        cfArrayRef = (__bridge_retained CFMutableArrayRef)obj;
        printf("retain count = %ld \n",CFGetRetainCount(cfArrayRef));
    }
    printf("retain count = %ld",CFGetRetainCount(cfArrayRef));
    CFRelease(cfArrayRef);
}

#pragma mark - Query With SQL Options

- (void)queryWithSQLTemplate {
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSManagedObjectModel *model = context.persistentStoreCoordinator.managedObjectModel;
    
    //studentAge
    NSFetchRequest *studentRequest = [model fetchRequestTemplateForName:@"studentAge"];
    NSError *error;
    NSArray *list = [context executeFetchRequest:studentRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"[Student] : %@, %d",obj.name,obj.age);
    }];
    
    //teacherName
    NSFetchRequest *teacherRequest = [model fetchRequestTemplateForName:@"teacherName"];
    list = [context executeFetchRequest:teacherRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Teacher *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"[Teacher] : %@",obj.name);
    }];
    
    NSLog(@"error : %@",error);
}

- (void)queryWithSQLOperation {
    NSLog(@"查询总数:");
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *request = [Student fetchRequest];
    NSError *error;
    NSInteger count = [context countForFetchRequest:request error:&error];
    NSLog(@"[count] = %@, [error] = %@",@(count),error);
    
    NSLog(@"查询年龄总和:");
    //设置运算参与对象，必须
    NSString *sumKey = @"sumOperation";
    request.resultType = NSDictionaryResultType;
    //设置运算描述对象
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = sumKey;
    expressionDescription.expressionResultType = NSInteger16AttributeType;
    //创建具体的运算
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"age"]]];
    //关联描述对象
    expressionDescription.expression = expression;
    //关联查询条件
    request.propertiesToFetch = @[expressionDescription];
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (result && result.count > 0) {
        NSDictionary *dic = [result firstObject];
        NSNumber *sum = [dic objectForKey:sumKey];
        NSLog(@"[sum] = %@, [error] = %@",sum, error);
    }
}

#pragma mark - Relation SQLTable Action

- (void)testRelationSQL {
    //插入数据耗时: 0.070775
    [self testRelationInsertDataToSQL];
    //更新数据耗时: 0.003871
    [self testRelationUpdateDataToSQL];
    //查询数据耗时: 0.049533
    [self testRelationQueryDataFromSQL];
    //删除数据耗时: 0.054115
    //[self testRelationDeleteDataFromSQL];
    
    //反向测试
    [self testRelationNoReverseInsertDataToSQL];
    [self testRelationNoReverseQueryDataFromSQL];
    //[self testRelationNoreverseDeleteDataFromSQL];
}

- (void)testRelationInsertDataToSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    NSInteger number = 1000;
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    for (NSInteger i = 0; i < number; i++) {
        Employee *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class]) inManagedObjectContext:context];
        item.birthday = [[NSDate date] dateByAddingTimeInterval:(-86400 * (i + 1))];
        item.name = [NSString stringWithFormat:@"name%@",@(i+1)];
        
        Department *department = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Department class]) inManagedObjectContext:context];
        department.name = [NSString stringWithFormat:@"dep%@",@(i+1)];
        department.address = [NSString stringWithFormat:@"address%@",@(i+1)];
        department.employee = [NSSet setWithObject:item];
    }
    
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"插入数据耗时: %f",(end - begin));
}

- (void)testRelationNoReverseInsertDataToSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    NSInteger number = 5;
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    for (NSInteger i = 0; i < number; i++) {
        Student *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Student class]) inManagedObjectContext:context];
        item.name = [NSString stringWithFormat:@"name%@",@(i+1)];
        item.age = arc4random() % 6 + 12;
        item.sex = i % 2;
        
        Teacher *department = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Teacher class]) inManagedObjectContext:context];
        department.name = [NSString stringWithFormat:@"dep%@",@(i+1)];
        department.subject = [NSString stringWithFormat:@"subject%@",@(i+1)];
        department.students = item;
    }
    
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"noreverse插入数据耗时: %f",(end - begin));
}

- (void)testRelationQueryDataFromSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *request = [Employee fetchRequest];
    request.fetchLimit = 5;
    NSError *error = nil;
    NSArray *list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Employee *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"[%@ - Employee] \n%@",@(idx),obj);
    }];
    
    request = [Department fetchRequest];
    request.fetchLimit = 5;
    list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Department *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"[%@ - Department] \n%@",@(idx),obj);
    }];
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"查询数据耗时: %f",(end - begin));
}

- (void)testRelationNoReverseQueryDataFromSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *request = [Student fetchRequest];
    NSError *error = nil;
    NSArray *list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"[%@ - Student] \n%@",@(idx),obj);
    }];
    
    request = [Teacher fetchRequest];
    list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Teacher *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"[%@ - Teacher] \n%@",@(idx),obj);
    }];
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"noreverse查询数据耗时: %f",(end - begin));
}

- (void)testRelationUpdateDataToSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *request = [Employee fetchRequest];
    request.fetchLimit = 5;
    NSError *error = nil;
    NSArray *list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Employee *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.name = [obj.name stringByAppendingFormat:@"-%@",@(idx)];
    }];
    
    request = [Department fetchRequest];
    request.fetchLimit = 5;
    list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Department *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.name = [obj.name stringByAppendingFormat:@"-%@",@(idx)];
    }];
    
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"更新数据耗时: %f",(end - begin));
}

- (void)testRelationDeleteDataFromSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *request = [Employee fetchRequest];
    NSError *error = nil;
    NSArray *list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Employee *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [context deleteObject:obj];
    }];
    
    request = [Department fetchRequest];
    list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Department *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [context deleteObject:obj];
    }];
    
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"删除数据耗时: %f",(end - begin));
}

- (void)testRelationNoreverseDeleteDataFromSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *request = [Student fetchRequest];
    NSError *error = nil;
    NSArray *list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [context deleteObject:obj];
    }];
    
    request = [Teacher fetchRequest];
    list = [context executeFetchRequest:request error:&error];
    [list enumerateObjectsUsingBlock:^(Teacher *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [context deleteObject:obj];
    }];
    
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"noreverse删除数据耗时: %f",(end - begin));
}

#pragma mark - Single SQLTable Action

- (void)testSingleSQL {
    //插入数据耗时: 0.051705
    [self testSingleInsertDataToSQL];
    //查询数据耗时: 0.060307
    [self testSingleQueryDataFromSQL];
    //更新数据耗时: 0.005341
    [self testSingleUpdateDataToSQL];
    //删除数据耗时: 0.035900
    [self testSingleDeleteDataFromSQL];
}

- (void)testSingleInsertDataToSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    NSInteger number = 1000;
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    for (NSInteger i = 0; i < number; i++) {
        Employee *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class]) inManagedObjectContext:context];
        item.birthday = [[NSDate date] dateByAddingTimeInterval:(-86400 * (i + 1))];
        item.name = [NSString stringWithFormat:@"name%@",@(i+1)];
    }
    for (NSInteger i = 0; i < number; i++) {
        Student *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Student class]) inManagedObjectContext:context];
        item.name = [NSString stringWithFormat:@"stu%@",@(i+1)];
        item.sex = i % 2;
        item.age = arc4random() % 30 + 20;
    }
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"插入数据耗时: %f",(end - begin));
}

- (void)testSingleQueryDataFromSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    
    NSError *error;
    NSFetchRequest *studentRequest = [Student fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age > 48"];
    [studentRequest setPredicate:predicate];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [studentRequest setSortDescriptors:@[sort]];
    
    NSArray *list = [context executeFetchRequest:studentRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //该block如果有代码执行，会降低执行时间，延长耗时
        NSLog(@"[Student] %@, %d",obj.name,obj.age);
    }];
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"查询数据耗时: %f",(end - begin));
}

- (void)testSingleUpdateDataToSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    
    NSError *error;
    NSFetchRequest *studentRequest = [Student fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age > 40"];
    [studentRequest setPredicate:predicate];
    NSArray *list = [context executeFetchRequest:studentRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.age = arc4random() % 40 + 20;
    }];
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [studentRequest setSortDescriptors:@[sort]];
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"更新数据耗时: %f",(end - begin));
    
    list = [context executeFetchRequest:studentRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //该block如果有代码执行，会降低执行时间，延长耗时
        NSLog(@"[Student] %@, %d",obj.name,obj.age);
    }];
}

- (void)testSingleDeleteDataFromSQL {
    double begin = CFAbsoluteTimeGetCurrent();
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    NSFetchRequest *employeeRequest = [Employee fetchRequest];
    NSError *error;
    NSArray *list = [context executeFetchRequest:employeeRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //NSLog(@"[Employee] %@, %@",obj.name,obj.birthday);
        [context deleteObject:obj];
    }];
    NSFetchRequest *studentRequest = [Student fetchRequest];
    list = [context executeFetchRequest:studentRequest error:&error];
    [list enumerateObjectsUsingBlock:^(Student *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //NSLog(@"[Student] %@, %d",obj.name,obj.age);
        [context deleteObject:obj];
    }];
    
    if ([context hasChanges]) {
        NSError *error;
        [context save:&error];
    }
    
    double end = CFAbsoluteTimeGetCurrent();
    NSLog(@"删除数据耗时: %f",(end - begin));
}

#pragma mark - NSFetchedResultsController

- (void)fetchedResultCtrl {
    FetchedResultViewController *ctrl = [[FetchedResultViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - DynamicAnimator

- (void)showDynamicAnimator {
    DynamicAnimatorViewController *ctrl = [[DynamicAnimatorViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)showCollisionAnimator {
    CollisionBehaviorController *ctrl = [[CollisionBehaviorController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)showLaunchAnimator {
    LaunchAnimatedController *launch = [[LaunchAnimatedController alloc] init];
    [self.navigationController pushViewController:launch animated:YES];
}

#pragma mark - Math

- (void)showMathController {
    MathViewController *math = [[MathViewController alloc] init];
    math.type = MathTypeSegmentTree;
    [self.navigationController pushViewController:math animated:YES];
}

#pragma mark - LinkList

- (void)showLinkList {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LLLinkViewController *link = [sb instantiateViewControllerWithIdentifier:@"LLLinkViewController"];
    [self.navigationController pushViewController:link animated:YES];
}

#pragma mark - Charts

- (void)showJHChartDemo:(NSString *)type {
    JHChartViewController *chart = [[JHChartViewController alloc] init];
    chart.type = [type integerValue];
    [self.navigationController pushViewController:chart animated:YES];
}

#pragma mark - Font

- (void)showFonts {
    FontViewController *font = [[FontViewController alloc] init];
    [self.navigationController pushViewController:font animated:YES];
}

#pragma mark - Video

- (void)showVideo {
    VideoViewController *video = [[VideoViewController alloc] init];
    [self.navigationController pushViewController:video animated:YES];
}

#pragma mark - Third Animation

- (void)showYUAnimation {
    YUMainTableViewController *main = [[YUMainTableViewController alloc] init];
    [self.navigationController pushViewController:main animated:YES];
}

#pragma mark - Socket

- (void)showSocketDemo {
    SocketViewController *socket = [[SocketViewController alloc] init];
    [self.navigationController pushViewController:socket animated:YES];
}

#pragma mark - Schema

- (void)showSchemaDemo {
    SchemaViewController *schema = [[SchemaViewController alloc] init];
    [self.navigationController pushViewController:schema animated:YES];
}

#pragma mark - Operation

- (void)showOperationDemo {
    OperationViewController *operation = [[OperationViewController alloc] init];
    [self.navigationController pushViewController:operation animated:YES];
}

#pragma mark - WeakSelf

- (void)showWeakSelfDemo {
    WeakSelfViewController *weakCtrl = [[WeakSelfViewController alloc] init];
    [self.navigationController pushViewController:weakCtrl animated:YES];
}

#pragma mark - KVO

- (void)showKVODemo {
    KVOViewController *ctrl = [[KVOViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - WebView

- (void)showWebDemo {
    WebViewController *ctrl = [[WebViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - TabBar

- (void)showTabBarDemo {
    TabBarTestController *ctrl = [[TabBarTestController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - LifeCycle

- (void)showLifeCycleDemo {
    LifeCycleViewController *ctrl = [[LifeCycleViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - Datas

- (void)demoDatas {
    DemoObject *font = [DemoObject initWithName:@"Fonts" method:@"showFonts"];
    DemoSection *secFont = [DemoSection initWithTitle:@"系统字体" list:@[font]];
    [self.dataSource addObject:secFont];
    
    DemoObject *tab = [DemoObject initWithName:@"Normal TabBar Controller" method:@"showTabBarDemo"];
    DemoSection *secTab = [DemoSection initWithTitle:@"TabBar" list:@[tab]];
    [self.dataSource addObject:secTab];
    
    DemoObject *ctrlCycle = [DemoObject initWithName:@"ViewController Life Cycle" method:@"showLifeCycleDemo"];
    DemoSection *secCycle = [DemoSection initWithTitle:@"Life Cycle" list:@[ctrlCycle]];
    [self.dataSource addObject:secCycle];
    
    DemoObject *web = [DemoObject initWithName:@"UIWebView" method:@"showWebDemo"];
    DemoSection *webSection = [DemoSection initWithTitle:@"Web" list:@[web]];
    [self.dataSource addObject:webSection];
    
    DemoObject *equal = [DemoObject initWithName:@"自定义Equal & Hash" method:@"testCustomEqual"];
    DemoSection *section0 = [DemoSection initWithTitle:@"值相等" list:@[equal]];
    [self.dataSource addObject:section0];
    
    DemoObject *gcd1 = [DemoObject initWithName:@"GCD测试" method:@"testDispatchQueue"];
    DemoObject *gcd2 = [DemoObject initWithName:@"GCD_semaphore测试" method:@"testDispatchSemaphore1"];
    DemoObject *gcd3 = [DemoObject initWithName:@"GCD_semaphore加锁测试" method:@"testDispatchSemaphore2"];
    DemoObject *gcd4 = [DemoObject initWithName:@"GCD_semaphore资源控制测试" method:@"testDispatchSemaphore3"];
    DemoObject *gcd5 = [DemoObject initWithName:@"GCD_Apply测试" method:@"testDispatchApply"];
    DemoSection *section1 = [DemoSection initWithTitle:@"GCD" list:@[gcd1,gcd2,gcd3,gcd4,gcd5]];
    [self.dataSource addObject:section1];
    
    DemoObject *arc1 = [DemoObject initWithName:@"weak & retain" method:@"testWeakRetain"];
    DemoObject *arc2 = [DemoObject initWithName:@"Object Count" method:@"testObjectCount"];
    DemoObject *arc3 = [DemoObject initWithName:@"CFCount" method:@"testFtoCoreF"];
    DemoSection *section2 = [DemoSection initWithTitle:@"引用计数" list:@[arc1,arc2,arc3]];
    [self.dataSource addObject:section2];
    
    DemoObject *runtime = [DemoObject initWithName:@"runTimeMethods & Address" method:@"testRuntimeMethods"];
    DemoSection *section3 = [DemoSection initWithTitle:@"Runtime" list:@[runtime]];
    [self.dataSource addObject:section3];
    
    DemoObject *masonary1 = [DemoObject initWithName:@"Base Use" method:@"showMasonarySimpleDemo"];
    DemoObject *masonary2 = [DemoObject initWithName:@"Relative & Lable" method:@"showMasonaryRelative"];
    DemoSection *section4 = [DemoSection initWithTitle:@"Masonary" list:@[masonary1,masonary2]];
    [self.dataSource addObject:section4];
    
    DemoObject *sqlOption1 = [DemoObject initWithName:@"Simple Test" method:@"testSingleSQL"];
    DemoObject *sqlOption2 = [DemoObject initWithName:@"Relation Table Test" method:@"testRelationSQL"];
    DemoObject *sqlOption3 = [DemoObject initWithName:@"SQL Operation" method:@"queryWithSQLOperation"];
    DemoObject *sqlOption4 = [DemoObject initWithName:@"SQL With Template" method:@"queryWithSQLTemplate"];
    DemoObject *sqlOption5 = [DemoObject initWithName:@"Fetched Results Controller" method:@"fetchedResultCtrl"];
    DemoSection *section5 = [DemoSection initWithTitle:@"CoreData" list:@[sqlOption1,sqlOption2,sqlOption3,sqlOption4,sqlOption5]];
    [self.dataSource addObject:section5];
    
    DemoObject *dynamic1 = [DemoObject initWithName:@"Simple" method:@"showDynamicAnimator"];
    DemoObject *dynamic2 = [DemoObject initWithName:@"Collision Behavior" method:@"showCollisionAnimator"];
    DemoObject *dynamic3 = [DemoObject initWithName:@"Launch Animated" method:@"showLaunchAnimator"];
    DemoSection *section6 = [DemoSection initWithTitle:@"Dynamic Animator" list:@[dynamic1,dynamic2,dynamic3]];
    [self.dataSource addObject:section6];
    
    DemoObject *math1 = [DemoObject initWithName:@"Segment tree" method:@"showMathController"];
    DemoSection *section7 = [DemoSection initWithTitle:@"Math" list:@[math1]];
    [self.dataSource addObject:section7];
    
    DemoObject *link = [DemoObject initWithName:@"Linklist Test" method:@"showLinkList"];
    DemoSection *session8 = [DemoSection initWithTitle:@"Link-List" list:@[link]];
    [self.dataSource addObject:session8];
    
    DemoObject *jhLine = [DemoObject initWithName:@"JHChart-Line" method:@"showJHChartDemo" params:@"0"];
    DemoObject *jhPie = [DemoObject initWithName:@"JHChart-Pie" method:@"showJHChartDemo" params:@"1"];
    DemoObject *jhRing = [DemoObject initWithName:@"JHChart-Ring" method:@"showJHChartDemo" params:@"2"];
    DemoObject *jhColumn = [DemoObject initWithName:@"JHChart-Column" method:@"showJHChartDemo" params:@"3"];
    DemoObject *jhTable = [DemoObject initWithName:@"JHChart-Table" method:@"showJHChartDemo" params:@"4"];
    DemoObject *jhRadar = [DemoObject initWithName:@"JHChart-Radar" method:@"showJHChartDemo" params:@"5"];
    DemoObject *jhScatter = [DemoObject initWithName:@"JHChart-Scatter" method:@"showJHChartDemo" params:@"6"];
    DemoSection *charts = [DemoSection initWithTitle:@"Charts" list:@[jhLine,jhPie,jhRing,jhColumn,jhTable,jhRadar,jhScatter]];
    [self.dataSource addObject:charts];
    
    DemoObject *video = [DemoObject initWithName:@"Video Player" method:@"showVideo"];
    DemoSection *videoSection = [DemoSection initWithTitle:@"视频播放" list:@[video]];
    [self.dataSource addObject:videoSection];
    
    DemoObject *yuAnimation = [DemoObject initWithName:@"YUAnimation" method:@"showYUAnimation"];
    DemoSection *thirdAnimation = [DemoSection initWithTitle:@"第三方动画效果" list:@[yuAnimation]];
    [self.dataSource addObject:thirdAnimation];
    
    DemoObject *socketDemo = [DemoObject initWithName:@"OC Socket" method:@"showSocketDemo"];
    DemoSection *socket = [DemoSection initWithTitle:@"Socket" list:@[socketDemo]];
    [self.dataSource addObject:socket];
    
    DemoObject *schemaDemo = [DemoObject initWithName:@"URL Open Schema" method:@"showSchemaDemo"];
    DemoSection *schema = [DemoSection initWithTitle:@"Schema" list:@[schemaDemo]];
    [self.dataSource addObject:schema];
    
    DemoObject *operationDemo = [DemoObject initWithName:@"OC Operation" method:@"showOperationDemo"];
    DemoSection *operation = [DemoSection initWithTitle:@"Operation" list:@[operationDemo]];
    [self.dataSource addObject:operation];
    
    DemoObject *weakDemo = [DemoObject initWithName:@"weak & cyncle" method:@"showWeakSelfDemo"];
    DemoSection *weakSection = [DemoSection initWithTitle:@"Retain Count" list:@[weakDemo]];
    [self.dataSource addObject:weakSection];
    
    DemoObject *kvoDemo = [DemoObject initWithName:@"Simple KVO Testing" method:@"showKVODemo"];
    DemoSection *kvoSection = [DemoSection initWithTitle:@"KVO" list:@[kvoDemo]];
    [self.dataSource addObject:kvoSection];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DemoSection *item = [self.dataSource objectAtIndex:section];
    return item.list ? item.list.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demoCell"];
    }
    DemoSection *section = [self.dataSource objectAtIndex:indexPath.section];
    DemoObject *item = [section.list objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DemoSection *item = [self.dataSource objectAtIndex:section];
    return item.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DemoSection *section = [self.dataSource objectAtIndex:indexPath.section];
    DemoObject *item = [section.list objectAtIndex:indexPath.row];
    NSLog(@"======================================");
    NSLog(@"===============%@==============",item.name);
    if (item.params && item.params.length > 0) {
        SEL selector = NSSelectorFromString([item.method stringByAppendingString:@":"]);
        [self performSelector:selector withObject:item.params afterDelay:0.0];
    }
    else {
        SEL selector = NSSelectorFromString(item.method);
        [self performSelector:selector withObject:nil afterDelay:0.0];
    }
    NSLog(@"======================================");
}

@end
