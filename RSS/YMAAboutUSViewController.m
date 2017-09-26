//
//  YMAAboutUSViewController.m
//  RSS
//
//  Created by Mikhail Yaskou on 21.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAboutUSViewController.h"
#import "PKRevealController.h"

@interface YMAAboutUSViewController () <PKRevealing>

@end

@implementation YMAAboutUSViewController

- (IBAction)menuTapped:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

@end
