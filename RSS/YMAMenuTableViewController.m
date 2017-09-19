//
//  YMAMenuTableViewController.m
//  
//
//  Created by Mikhail Yaskou on 17.09.17.
//
//

#import "YMAMenuTableViewController.h"
#import "YMAController.h"
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRowIndexPach = indexPath;
    
    switch (indexPath.row) {
        case 0:
            [[YMAController sharedInstance] setSelectedChannelIndex:@(indexPath.row)];

            break;
        case 1:
            [[YMAController sharedInstance] setSelectedChannelIndex:@(indexPath.row)];
            break;
        case 2:
            [[YMAController sharedInstance] setSelectedChannelIndex:@(indexPath.row)];
            break;
        case 3:

            break;
        case 4:

            break;
        case 5:


        default:
            break;
    }

    [[YMAController sharedInstance] applySelectedParameters];

}



@end
