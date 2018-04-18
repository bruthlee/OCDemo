//
//  LLLinkViewController.m
//  OCDemo
//
//  Created by lixiaoyong on 2017/11/23.
//  Copyright © 2017年 greencici. All rights reserved.
//

#import "LLLinkViewController.h"

#import "LLSingleLinkedList.h"
#import "LLDoubleLinkedList.h"

@interface LLLinkViewController ()
@property (nonatomic, strong) LLSingleLinkedList *singleList;
@property (nonatomic, strong) LLDoubleLinkedList *doubleList;
@end

@implementation LLLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"链表";
    
    self.singleList = [[LLSingleLinkedList alloc] init];
    self.doubleList = [[LLDoubleLinkedList alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        switch (row) {
            case 0:
                [self.singleList insertNode:[LLSingleLinkedNode nodeWithKey:@"node1" value:@"value1"]];
                break;
            case 1:
                [self.singleList insertNodeAtHead:[LLSingleLinkedNode nodeWithKey:@"node2" value:@"value2"]];
                break;
            case 2:
                [self.singleList insertNode:[LLSingleLinkedNode nodeWithKey:@"node3" value:@"value3"] beforeNodeForKey:@"node1"];
                break;
            case 3:
                [self.singleList insertNode:[LLSingleLinkedNode nodeWithKey:@"node4" value:@"value4"] afterNodeForKey:@"node3"];
                break;
            case 4:
                [self.singleList bringNodeToHead:[LLSingleLinkedNode nodeWithKey:@"node1" value:@"value1"]];
                break;
            case 5:
                [self.singleList removeNode:@"node3"];
                break;
            case 6:
            case 7:
            case 8:
                break;
            case 9:
                [self.singleList reverse];
                break;
                
            default:
                break;
        }
        [self.singleList readAllNode];
    }
    else {
        if (row == 9) {
            NSInteger length = [self.doubleList length];
            NSLog(@"链表长度是:[%@]",@(length));
            return;
        }
        
        switch (row) {
            case 0:
                [self.doubleList insertNode:[LLDoubleLinkedNode nodeWithKey:@"node1" value:@"value1"]];
                break;
            case 1:
                [self.doubleList insertNodeAtHead:[LLDoubleLinkedNode nodeWithKey:@"node2" value:@"value2"]];
                break;
            case 2:
                [self.doubleList insertNode:[LLDoubleLinkedNode nodeWithKey:@"node3" value:@"value3"] beforeNodeForKey:@"node1"];
                break;
            case 3:
                [self.doubleList insertNode:[LLDoubleLinkedNode nodeWithKey:@"node4" value:@"value4"] afterNodeForKey:@"node3"];
                break;
            case 4:
                [self.doubleList bringNodeToHead:[LLDoubleLinkedNode nodeWithKey:@"node1" value:@"value1"]];
                break;
            case 5:
                [self.doubleList removeNodeForKey:@"node4"];
                break;
                
            default:
                break;
        }
        [self.doubleList readAllNode];
    }
    
    NSLog(@"================================================");
}

@end
