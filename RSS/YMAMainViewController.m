//
//  YMAMainViewController.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAController.h"
#import "YMAMainViewController.h"
#import "YMARSSItem+CoreDataClass.h"
#import "YMARSSItemCollectionViewCell.h"
#import "RFQuiltLayout.h"
#import "PKRevealController.h"
#import "UIImageView+HighlightedWebCache.h"
#import "YMAConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const int YMAMainVCCellInsets = 5;
static const int YMAMainVCCellMultiplierByOne = 1;
static const int YMAMainVCCellMultiplierByTwo = 2;
static const int YMAMainVCLongCellDivider = 3;
static const int YMAMainVCFirstIndex = 0;
static NSString * const YMARSSItemCellIdentifier = @"YMARSSItemCell";
static NSString * const YMACustomTabTabTitleKey = @"tabTitle";
static NSString * const YMAMainVCNoPhotoImageName = @"no-photo-available.png";
static NSString * const YMAMainVCIdentifier = @"YMAMainViewController";

@interface YMAMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, RFQuiltLayoutDelegate, PKRevealing>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation YMAMainViewController

#pragma mark - Initialization

+ (YMAMainViewController *)sharedInstance {
    static YMAMainViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:YMAMainStoryboardName bundle:nil];
        _sharedInstance = [sb instantiateViewControllerWithIdentifier:YMAMainVCIdentifier];
    });
    return _sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    RFQuiltLayout *layout = (id) [self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.prelayoutEverything = YES;
    layout.blockPixels = CGSizeMake((CGRectGetWidth(self.view.frame) / 2) - YMAMainVCCellInsets*2, 200);
    layout.delegate = self;
    //select first tabItem
    [self.tabBar setSelectedItem:self.tabBar.items[YMAMainVCFirstIndex]];
    //set observers
    [YMAController.sharedInstance setObserverForRSSItems:self];
    [YMAController.sharedInstance setObserverForUpdateProgress:self];
    //load and show first channel
    [YMAController.sharedInstance updateChannelForIndex:@(YMAMainVCFirstIndex) withCompletionBlock:^{
        [YMAController.sharedInstance applySelectedParameters];
    }];
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshCollectionView) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Actions

- (void)refreshCollectionView {
    [YMAController.sharedInstance updateSelectedChannelWithCompletionBlock:^{
        [YMAController.sharedInstance applySelectedParameters];
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)showLeftMenuTapped:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:YMAControllerRSSItemsArrayPropertyName]) {
        [self.collectionView reloadData];
    }
    if ([keyPath isEqualToString:YMAControllerUpdateProgressPropertyName]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YMAController.sharedInstance.isUpdateInProgress];
    }
}

#pragma mark - TabBar Action

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.navigationBarTitle.title = [item valueForKey:YMACustomTabTabTitleKey];
    [[YMAController sharedInstance] setSelectedCategoryIndex:@(item.tag)];
    [[YMAController sharedInstance] applySelectedParameters];
    [self resetScrollCollectionView];
}

#pragma mark - Methods

- (void)resetScrollCollectionView {
    //reset collection view scroll
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YMARSSItem *item = YMAController.sharedInstance.rssItems[indexPath.row];

    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[[NSURL alloc] initWithString:item.link] options:@{} completionHandler:nil];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return YMAController.sharedInstance.rssItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMARSSItemCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:YMARSSItemCellIdentifier forIndexPath:indexPath];
    YMARSSItem *item = YMAController.sharedInstance.rssItems[indexPath.row];
    cell.itemTitle.text = item.title;
    if (item.imageUrl != nil) {
        //set animated indicator
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator setCenter:cell.itemImage.center];
        [activityIndicator startAnimating];
        [cell.itemImage addSubview:activityIndicator];
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     [activityIndicator stopAnimating];
                                     if (error) {
                                         //if has problem with image loading data about image.
                                         cell.itemImage.image = [UIImage imageNamed:YMAMainVCNoPhotoImageName];
                                     }
                                 }];
    }
    else {
        //if in xml no data about image (lenta.ru).
        cell.itemImage.image = [UIImage imageNamed:YMAMainVCNoPhotoImageName];
    }
    return cell;
}

#pragma mark - RFQuiltLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   //all cell with index which the divides by YMAMainVCLongCellDivider wil be big
    if (indexPath.row % YMAMainVCLongCellDivider) {
        return CGSizeMake(YMAMainVCCellMultiplierByOne, YMAMainVCCellMultiplierByTwo);
    }
    return CGSizeMake(YMAMainVCCellMultiplierByOne, YMAMainVCCellMultiplierByOne);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(YMAMainVCCellInsets, YMAMainVCCellInsets, YMAMainVCCellInsets, YMAMainVCCellInsets);
}

@end
