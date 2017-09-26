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
#import "YMAMainVC.h"

@interface YMAMenuTableViewController () <PKRevealing>

@property(strong, nonatomic) NSIndexPath *selectedRowIndexPatch;

@end

@implementation YMAMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRowIndexPatch = [NSIndexPath indexPathForItem:0 inSection:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:self.selectedRowIndexPatch animated:YES scrollPosition:UITableViewScrollPositionNone];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRowIndexPatch = indexPath;

    UIViewController *nextFrontViewController;

    switch (indexPath.row) {
        case 0:
        case 1:
        case 2: {
            nextFrontViewController = YMAMainVC.sharedInstance;
            [YMAController.sharedInstance setSelectedChannelIndex:@(indexPath.row)];
            [YMAController.sharedInstance applySelectedParameters];
            [YMAMainVC.sharedInstance resetScrollCollectionView];
            [YMAController.sharedInstance updateSelectedChannelWithCompletionBlock:^{
                [YMAController.sharedInstance applySelectedParameters];
            }];
        }
            break;
        case 3: {
            nextFrontViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAOfferNewsViewController"];
        }
            break;
        case 5: {
            nextFrontViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAboutUSViewController"];
        }
            break;
        default:
            break;
    }
    self.revealController.frontViewController = nextFrontViewController;
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
