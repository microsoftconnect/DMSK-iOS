//
//  LoginViewController.h
//  DMSpeechKitSample
//
//  Copyright 2011 Nuance Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate; 

@interface LoginViewController : UIViewController {
	UITextField* userNameField; 
	id<LoginViewControllerDelegate> delegate; 
}

@property (nonatomic, retain) IBOutlet UITextField* userNameField; 
@property (nonatomic) id<LoginViewControllerDelegate> delegate; 

- (IBAction) loginAction: (id) sender; 

@end

@protocol LoginViewControllerDelegate <NSObject> 
- (void) loginViewController: (LoginViewController*) controller didLoginUser: (NSString*) userName; 
@end

