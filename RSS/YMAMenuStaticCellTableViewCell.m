//
//  YMAMenuStaticCellTableViewCell.m
//  RSS
//
//  Created by Mikhail Yaskou on 17.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAMenuStaticCellTableViewCell.h"

@implementation YMAMenuStaticCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
