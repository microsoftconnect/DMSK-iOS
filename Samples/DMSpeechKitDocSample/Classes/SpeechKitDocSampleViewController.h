//
//  SpeechKitDocSampleViewController.h
//  DMSpeechKitDocSample
//
//  Copyright 2015 Nuance Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h" 
#import "DictationView.h" 

@interface SpeechKitDocSampleViewController : UIViewController <DictationViewDelegate, LoginViewControllerDelegate> {
	// Simple flag to show the LoginViewController view when we are displayed for 
	// the first time. 
	BOOL userLoggedIn; 
}

@property (nonatomic, assign) BOOL userLoggedIn; 

@end

