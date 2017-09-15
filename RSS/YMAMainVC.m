//
//  YMAMainVC.m
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <MagicalRecord/NSManagedObject+MagicalAggregation.h>
#import "YMAMainVC.h"
#import "YMARSSItem+CoreDataClass.h"
#import "RFQuiltLayout.h"
#import "YMARSSItemCollectionViewCell.h"
#import "YMADateHelper.h"
#import "AsyncImageView.h"

@interface YMAMainVC () <UICollectionViewDelegate, UICollectionViewDataSource, RFQuiltLayoutDelegate>

@property (nonatomic, strong) NSArray *items;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YMAMainVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;



    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake((self.view.frame.size.width / 2)-8, 150);
    layout.delegate = self;


    self.items = [YMARSSItem MR_findAll];
    NSLog(@"Count  1 %u", [self.items count]);

    NSLog(@"Count  2 %@", [YMARSSItem MR_numberOfEntities]);
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

    cell.itemDate.text = [YMADateHelper stringFromDate:[item date]];
    cell.itemTime.text = [YMADateHelper stringFromTime:[item date]];
    cell.itemImage.imageURL = [NSURL URLWithString:[item imageUrl]];
    cell.itemTitle.text = item.title;
    cell.itemImage.image = nil;
    
    
    


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
