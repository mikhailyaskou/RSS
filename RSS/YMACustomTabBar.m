//
//  YMACustomTabBar.m
//  RSS
//
//  Created by Mikhail Yaskou on 16.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMACustomTabBar.h"

static const CGFloat YMACustomTabBarSelectedItemInset = 7.5;
static const CGFloat YMACustomTabBarSelectedItemImageInset = 12.5;
static const CGFloat YMACustomTabBarSelectedItemHighDifference = 15;
static NSString *const YMACustomBarViewKey = @"view";
static const int YMACustomTabBarMultiplier = 2;

@interface YMACustomTabBar ()

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIImageView *buttonImage;

@end

@implementation YMACustomTabBar

//return UIView for selected item
- (UIView *)selectedItemView {
    return [self.selectedItem valueForKey:YMACustomBarViewKey];
}

//replace and recalculate button view if size changed (device rotated)
- (CGRect)bounds {
    if (CGRectGetWidth(self.selectedItemView.frame) != (CGRectGetWidth(self.buttonView.frame) - (YMACustomTabBarSelectedItemInset * YMACustomTabBarMultiplier))) {
        [self placeBigSelectedItem];
    }
    return [super bounds];
}

/*
 create UIView then on this view crate UIImageView, and place it
 on front selected UITabBarItem - every time when it tapped.
*/
- (void)placeBigSelectedItem {
    if (self.selectedItem) {
        //get selectedItem view
        UIView *selectedItemView = self.selectedItemView;
        //create view frame
        CGRect viewFrame = selectedItemView.frame;
        viewFrame.origin.x = CGRectGetMinX(selectedItemView.frame) - YMACustomTabBarSelectedItemInset;
        viewFrame.origin.y = CGRectGetMinY(selectedItemView.frame) - YMACustomTabBarSelectedItemHighDifference;
        viewFrame.size.height = CGRectGetHeight(viewFrame) + (YMACustomTabBarSelectedItemInset * YMACustomTabBarMultiplier);
        viewFrame.size.width = CGRectGetWidth(viewFrame) + (YMACustomTabBarSelectedItemInset * YMACustomTabBarMultiplier);
        // crate frame for image
        CGRect imageFrame = viewFrame;
        imageFrame.origin.x = YMACustomTabBarSelectedItemImageInset;
        imageFrame.origin.y = YMACustomTabBarSelectedItemImageInset;
        imageFrame.size.height = CGRectGetHeight(viewFrame) - (YMACustomTabBarSelectedItemImageInset * YMACustomTabBarMultiplier);
        imageFrame.size.width = CGRectGetWidth(viewFrame) - (YMACustomTabBarSelectedItemImageInset * YMACustomTabBarMultiplier);
        if (!self.buttonView) {
            //create view - set color
            self.buttonView = [[UIView alloc] initWithFrame:viewFrame];
            self.buttonView.backgroundColor = self.barTintColor;
            // create image - set contentMode
            self.buttonImage = [[UIImageView alloc] initWithFrame:imageFrame];
            self.buttonImage.contentMode = UIViewContentModeScaleAspectFit;
            //add image on view
            [self.buttonView addSubview:self.buttonImage];
            //add view on tabBar
            [self addSubview:self.buttonView];
        }
        else {
            //if view already initialized set current frame (for current selectedItem)
            [self.buttonView setFrame:viewFrame];
            [self.buttonImage setFrame:imageFrame];
        }
        //make view round
        self.buttonView.layer.cornerRadius = CGRectGetWidth(viewFrame) / YMACustomTabBarMultiplier;
        //set image on view from item
        self.buttonImage.image = self.selectedItem.image;
    }
}

//place bigItem every time when Item selected
- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    [super setSelectedItem:selectedItem];
    [self placeBigSelectedItem];
}

@end
