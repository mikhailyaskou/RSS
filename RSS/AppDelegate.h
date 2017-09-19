//
//  AppDelegate.h
//  RSS
//
//  Created by Mikhail Yaskou on 09.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PKRevealController.h"

@class RFViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) RFViewController *viewController;

- (void)saveContext;


@end

