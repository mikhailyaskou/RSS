//
//  YMAMainVC.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import "YMAMainVC.h"
#import "YMARSSItem+CoreDataClass.h"
#import "RFQuiltLayout.h"
#import "YMARSSItemCollectionViewCell.h"
#import "YMADateHelper.h"
#import "AsyncImageView.h"
#import "NSManagedObject+MagicalAggregation.h"
#import "PKRevealController.h"
#import "YMAController.h"

@interface YMAMainVC () <UICollectionViewDelegate, UICollectionViewDataSource, RFQuiltLayoutDelegate, PKRevealing>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) NSArray *items;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) BOOL isNextLong;

@end

@implementation YMAMainVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake((self.view.frame.size.width / 2)-10, 200);
    layout.delegate = self;

    self.items = [YMARSSItem MR_findAll];
    
    //select first tabItem 
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    
    
    [[YMAController sharedInstance] addObserver:self forKeyPath:@"rssItems" options:0 context:nil];
    
    [[YMAController sharedInstance] updateAllChannels];
    
    [[YMAController sharedInstance] applySelectedParameters];
    
}



#pragma mark - Actions

- (IBAction)showLeftMenuTapped:(id)sender {
   [self.revealController showViewController:self.revealController.leftViewController];
}


- (void)tabBarTapped {
    
    [self.navigationItem setTitle:@"В мире"];
    [self.tabBar setSelectedItem:0];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"rssItems"])
    {
        NSLog(@"observerTriggered");
        [self.collectionView reloadData];
    }
}

#pragma mark - TabBar Delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.navigationBarTitle.title = [item valueForKey:@"tabTitle"];
    
    //set array reload collection
    
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ///
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    YMARSSItemCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"YMARSSItemCell" forIndexPath:indexPath];
    
   
    if (cell == nil)
    {
        
    }
    else
    {
      //cancel loading previous image for cell
      [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.itemImage];
    }
    
    YMARSSItem *item = self.items[indexPath.row];
    cell.itemTitle.text = item.title;
    //set placeholder image or cell show old image for new reuuse cell
    cell.itemImage.image = [UIImage imageNamed:@"Placeholder.png"];
    cell.itemImage.imageURL = [NSURL URLWithString:[item imageUrl]];

    return cell;
}


#pragma mark - RFQuiltLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 3) {
        return CGSizeMake(1, 2);
    }
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}



@end
