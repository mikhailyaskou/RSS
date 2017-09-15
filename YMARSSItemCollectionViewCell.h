//
//  YMARSSItemCollectionViewCell.h
//  RSS
//
//  Created by Mikhail Yaskou on 14.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMARSSItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemDate;
@property (weak, nonatomic) IBOutlet UILabel *itemTime;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@end
