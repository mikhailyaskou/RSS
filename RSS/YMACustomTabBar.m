//
//  YMACustomTabBar.m
//  RSS
//
//  Created by Mikhail Yaskou on 16.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMACustomTabBar.h"

@interface YMACustomTabBar ()

@property(nonatomic, strong) UIView *buttonView;
@property(nonatomic, strong) UIImageView *buttonImage;

@end

@implementation YMACustomTabBar

//return UIView for selected item
- (UIView *)selectedItemView {
    return [self.selectedItem valueForKey:@"view"];
}

//replace and recalculate button View if size changed (device rotated)
- (CGRect)bounds {
    if ((self.selectedItemView.frame.size.width) != (self.buttonView.frame.size.width - (YMACustomTabBarSelectedItemInset * 2))) {
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
        viewFrame.origin.x = selectedItemView.frame.origin.x - YMACustomTabBarSelectedItemInset;
        viewFrame.origin.y = selectedItemView.frame.origin.y - YMACustomTabBarSelectedItemHighDifference;
        viewFrame.size.height = viewFrame.size.height + (YMACustomTabBarSelectedItemInset * 2);
        viewFrame.size.width = viewFrame.size.width + (YMACustomTabBarSelectedItemInset * 2);
        // crate frame for image
        CGRect imageFrame = viewFrame;
        imageFrame.origin.x = YMACustomTabBarSelectedItemImageInset;
        imageFrame.origin.y = YMACustomTabBarSelectedItemImageInset;
        imageFrame.size.height = viewFrame.size.height - (YMACustomTabBarSelectedItemImageInset * 2);
        imageFrame.size.width = viewFrame.size.width - (YMACustomTabBarSelectedItemImageInset * 2);
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
        self.buttonView.layer.cornerRadius = viewFrame.size.width / 2;
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
