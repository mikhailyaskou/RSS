//
//  YMAMainViewController.h
//  RSS
//
//  Created by Mikhail Yaskou on 11.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMAMainViewController : UIViewController

+ (YMAMainViewController *)sharedInstance;

- (void)resetScrollCollectionView;

@end
