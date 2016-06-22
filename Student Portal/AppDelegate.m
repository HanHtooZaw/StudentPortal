//
//  AppDelegate.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 12/1/15.
//  Copyright © 2015 HHZ. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Parse setApplicationId:@"wVRZavzu8nWrCXqARfeDpJuQkmAZ6Y3bCi6oQe6A"
                  clientKey:@"dhCUaW995HXG0Nw7FU8KBc35YrtQ7iWboOxjXO3P"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //one time login implementation
    NSString *storyboardIdentifier;
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
    if (isLoggedIn) {
        
        storyboardIdentifier = @"home";
        
    } else {
        
        storyboardIdentifier = @"login";
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    [self.window setRootViewController:vc];
    
    return YES;
}

@end
