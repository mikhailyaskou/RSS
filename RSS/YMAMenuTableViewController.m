//
//  YMAMenuTableViewController.m
//  
//
//  Created by Mikhail Yaskou on 17.09.17.
//
//

#import "YMAMenuTableViewController.h"

@interface YMAMenuTableViewController ()

@property (strong, nonatomic) NSIndexPath *selectedRowIndexPach;

@end

@implementation YMAMenuTableViewController

- (void)viewDidLoad {
    self.selectedRowIndexPach = [NSIndexPath indexPathForItem:0 inSection:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:self.selectedRowIndexPach animated:YES  scrollPosition:UITableViewScrollPositionNone];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    self.selectedRowIndexPach = indexPath;
}


@end
