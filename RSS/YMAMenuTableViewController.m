//
//  YMAMenuTableViewController.m
//  
//
//  Created by Mikhail Yaskou on 17.09.17.
//
//

#import "YMAMenuTableViewController.h"
#import "YMAController.h"
#import "PKRevealController.h"
#import "YMAOfferNewsViewController.h"
#import "YMAMainVC.h"
@interface YMAMenuTableViewController () <PKRevealing>

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
    
    UIViewController *nextFronViewController;
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            nextFronViewController = YMAMainVC.sharedInstance;
            [YMAController.sharedInstance setSelectedChannelIndex:@(indexPath.row)];
            [YMAController.sharedInstance applySelectedParameters];
            break;
        case 3: {
            
            nextFronViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAOfferNewsViewController"];
            }
            break;
        case 4:
            
            break;
        case 5:
            
            break;
    }
    self.revealController.frontViewController = nextFronViewController;
    [self.revealController showViewController:self.revealController.frontViewController];
    
   }


@end
