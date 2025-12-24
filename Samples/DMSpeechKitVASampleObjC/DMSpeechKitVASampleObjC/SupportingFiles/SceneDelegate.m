//
//  SceneDelegate.m
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2025 Nuance Communications Inc. All rights reserved.
//

#import "SceneDelegate.h"
#import "Constants.h"

@implementation SceneDelegate

- (void)loadHomeScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN_STORY_BOARD bundle:NULL];
    UINavigationController *homeNavController = [storyboard instantiateViewControllerWithIdentifier:HOMESCREEN_NAV_CONTROLLER];
    self.window.rootViewController = homeNavController;
    [self.window makeKeyAndVisible];
}

@end
