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

@interface YMAMainVC () <UICollectionViewDelegate, UICollectionViewDataSource, RFQuiltLayoutDelegate, PKRevealing>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *customBigTabButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *customBigImage;
@property (nonatomic, strong) NSArray *items;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    layout.blockPixels = CGSizeMake((self.view.frame.size.width / 2)-8, 200);
    layout.delegate = self;

    self.items = [YMARSSItem MR_findAll];
    
    //select first tabItem 
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];

    
}



#pragma mark - Actions

- (IBAction)showLeftMenuTapped:(id)sender {
   [self.revealController showViewController:self.revealController.leftViewController];
}


- (void)tabBarTapped {
    
    [self.navigationItem setTitle:@"В мире"];
    [self.tabBar setSelectedItem:0];
    
}

#pragma mark - TabBar Delegate

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
 
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
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = UIColor.darkGrayColor.CGColor;
        
    }
    else
    {
        //cancel loading previous image for cell
      [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.itemImage];
    }
    
    YMARSSItem *item = self.items[indexPath.row];
    
    cell.itemTitle.text = item.title;
    
    //set placeholder image or cell won't update when image is loaded
    cell.itemImage.image = [UIImage imageNamed:@"Placeholder.png"];
    
    cell.itemImage.imageURL = [NSURL URLWithString:[item imageUrl]];

    if (indexPath.row % 2 == 0){
        cell.backgroundColor = UIColor.grayColor;
    } else
    {
        cell.backgroundColor = [UIColor redColor];
    }


    return cell;
}


#pragma mark - RFQuiltLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{


       /* if (indexPath.row % 10 == 0)
            return CGSizeMake(1, 2);
        if (indexPath.row % 11 == 0)
            return CGSizeMake(2, 1);
        else if (indexPath.row % 7 == 0)
            return CGSizeMake(1, 2);
      else if (indexPath.row % 8 == 0)
            return CGSizeMake(1, 2);
        else if(indexPath.row % 11 == 0)
            return CGSizeMake(2, 2);
        if (indexPath.row == 0) return CGSizeMake(5, 5);*/

        return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(8, 8, 0, 0);
}



@end
