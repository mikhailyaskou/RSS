//
//  YMAAppDelegate.m
//  RSS
//
//  Created by Mikhail Yaskou on 09.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAppDelegate.h"
#import "YMAMainViewController.h"
#import "YMALeftMenuVC.h"
#import "YMAConstants.h"
#import <MagicalRecord/MagicalRecord.h>
#import <PKRevealController/PKRevealController.h>

static const int YMALeftMenuWidth = 207;

@interface YMAAppDelegate ()
@end

@implementation YMAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Instantiate.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:YMAMainStoryboardName bundle:nil];
    UIViewController *mainVC = YMAMainViewController.sharedInstance;
    UIViewController *leftMenuVC = [storyboard instantiateViewControllerWithIdentifier:YMALeftMenuVCIdentifier];
    self.revealController = [PKRevealController revealControllerWithFrontViewController:mainVC leftViewController:leftMenuVC];
    //Configure.
    [self.revealController setMinimumWidth:YMALeftMenuWidth maximumWidth:YMALeftMenuWidth forViewController:leftMenuVC];
    //Apply.
    self.window.rootViewController = self.revealController;
    //setupCoreDataStack
    [MagicalRecord setupCoreDataStack];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

@end
