//
//  LoginViewController.m
//  DMSpeechKitDocSample
//
//  Copyright 2015 Nuance Communications, Inc. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize userNameField; 
@synthesize delegate; 

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) loginAction: (id) sender {
	NSString* userName; 
	
	if (userNameField.text.length > 0) {
		userName = userNameField.text; 
	}
	else {
		userName = userNameField.placeholder; 
	}

	[delegate loginViewController: self didLoginUser: userName]; 
}

@end
