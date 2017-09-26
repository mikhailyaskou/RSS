//
//  YMAMainVC.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import "YMAController.h"
#import "YMAMainVC.h"
#import "YMARSSItem+CoreDataClass.h"
#import "YMARSSItemCollectionViewCell.h"
#import "RFQuiltLayout.h"
#import "PKRevealController.h"
#import "UIImageView+HighlightedWebCache.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YMAMainVC () <UICollectionViewDelegate, UICollectionViewDataSource, RFQuiltLayoutDelegate, PKRevealing>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation YMAMainVC

+ (YMAMainVC *)sharedInstance {
    static YMAMainVC *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _sharedInstance = [sb instantiateViewControllerWithIdentifier:@"YMAMainVC"];
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
    layout.blockPixels = CGSizeMake((self.view.frame.size.width / 2) - 10, 200);
    layout.delegate = self;
    //select first tabItem 
    [self.tabBar setSelectedItem:self.tabBar.items[0]];
    //set observer
    [YMAController.sharedInstance addObserver:self forKeyPath:@"rssItems" options:0 context:nil];
    //load and show first channel
    [YMAController.sharedInstance updateChannelForIndex:@0 withCompletionBlock:^{
        [YMAController.sharedInstance applySelectedParameters];
    }];
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshCollectionView) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Actions

- (void)refreshCollectionView {
    NSLog(@"refresh Triggered");
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
    if ([keyPath isEqualToString:@"rssItems"]) {
        NSLog(@"observerTriggered");
        [self.collectionView reloadData];
    }
}

- (void)resetScrollCollectionView {
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - TabBar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.navigationBarTitle.title = [item valueForKey:@"tabTitle"];
    [[YMAController sharedInstance] setSelectedCategoryIndex:@(item.tag)];
    [[YMAController sharedInstance] applySelectedParameters];
    [self resetScrollCollectionView];
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
    YMARSSItemCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"YMARSSItemCell" forIndexPath:indexPath];
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
                                 }];
    }
    else {
        //sometimes in xml no data about image (lenta.ru).
        cell.itemImage.image = [UIImage imageNamed:@"no-photo-available.png"];
    }
    return cell;
}

#pragma mark - RFQuiltLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 3) {
        return CGSizeMake(1, 2);
    }
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
