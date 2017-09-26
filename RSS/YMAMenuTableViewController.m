//
//  YMAMenuTableViewController.m
//  
//
//  Created by Mikhail Yaskou on 17.09.17.
//
//

#import <PKRevealController/PKRevealController.h>
#import "YMAMenuTableViewController.h"
#import "YMAController.h"
#import "YMAMainVC.h"

static NSString *const YMAOfferNewsVCIdentifier = @"YMAOfferNewsViewController";

static NSString *const YMAAboutUsVCIdentifier = @"YMAAboutUSViewController";

@interface YMAMenuTableViewController () <PKRevealing>

@property (strong, nonatomic) NSIndexPath *selectedRowIndexPatch;

@end

@implementation YMAMenuTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.selectedRowIndexPatch) {
        self.selectedRowIndexPatch = [NSIndexPath indexPathForItem:0 inSection:0];
    }
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
            nextFrontViewController = [self.storyboard instantiateViewControllerWithIdentifier:YMAOfferNewsVCIdentifier];
        }
            break;
        case 5: {
            nextFrontViewController = [self.storyboard instantiateViewControllerWithIdentifier:YMAAboutUsVCIdentifier];
        }
            break;
        default:
            break;
    }
    self.revealController.frontViewController = nextFrontViewController;
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
