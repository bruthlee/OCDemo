//
//  FetchedResultViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/14.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "FetchedResultViewController.h"

#import "DataCenter.h"

@interface FetchedResultViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSFetchedResultsController *fetchedController;
@end

@implementation FetchedResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FetchedResultsController";
    [self createFetchedResultComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched Controller Test

- (void)createFetchedResultComponent {
    CGRect rect = self.view.bounds;
    UITableView *table = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    self.tableView = table;
    
    NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
    for (int i = 0; i < 100; i++) {
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class]) inManagedObjectContext:context];
        employee.name = [NSString stringWithFormat:@"name%d",i];
        employee.birthday = [[NSDate date] dateByAddingTimeInterval:(-86400 * i)];
        employee.sectionName = [NSString stringWithFormat:@"sec%d",(i%10)];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"MOC save error : %@", error);
    }
    
    NSFetchRequest *request = [Employee fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthday" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    self.fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"sectionName" cacheName:nil];
    self.fetchedController.delegate = self;
    [self.fetchedController performFetch:&error];
    NSLog(@"[error] = %@",error);
    
    [self.tableView reloadData];
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fetchedResultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fetchedResultCell"];
    }
    Employee *item = [self.fetchedController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.fetchedController.sections[section].indexTitle;
}

// 是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 这里是简单模拟UI删除cell后，本地持久化区数据和UI同步的操作。在调用下面MOC保存上下文方法后，FRC会回调代理方法并更新UI
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除托管对象
        NSManagedObjectContext *context = [DataCenter shareDataCenter].mainContext;
        Employee *emp = [self.fetchedController objectAtIndexPath:indexPath];
        [context deleteObject:emp];
        // 保存上下文环境，并做错误处理
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"tableView delete cell error : %@", error);
        }
    }
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Fetched Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

// Section数据源发生改变回调此方法，例如修改section title等
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

// Cell数据源发生改变会回调此方法，例如添加新的托管对象等
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate: {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            Employee *emp = [self.fetchedController objectAtIndexPath:indexPath];
            cell.textLabel.text = emp.name;
        }
            break;
    }
}

//返回section的title，可以在这里对title做进一步处理。这里修改title后，对应section的indexTitle属性会被更新
- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    return [NSString stringWithFormat:@"sectionName %@", sectionName];
}

@end
