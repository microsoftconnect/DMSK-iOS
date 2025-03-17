//
//  SpeechKitSampleViewController.h
//  DMSpeechKitSample
//
//  Copyright 2011 Nuance Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h" 
#import "DictationView.h" 

@interface SpeechKitSampleViewController : UIViewController <DictationViewDelegate, LoginViewControllerDelegate> {
	// Simple flag to show the LoginViewController view when we are displayed for 
	// the first time. 
	BOOL userLoggedIn; 
}

@property (nonatomic, assign) BOOL userLoggedIn;

@end

