//
//  LoginViewController.m
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "VAManager.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_USERNAME_KEY];
}

- (IBAction)loginButtonTapped:(id)sender {
    NSString *username = self.usernameTextField.text;
    if (username.length <= 0) {
        [self.errorMessageLabel setHidden:NO];
        return;
    }
    
    [self storeUsername:username];
    // Initialize session once username is available
    [[VAManager sharedInstance] initializeSession];
    [self showHomeScreen];
}

- (void)storeUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:USERDEFAULTS_USERNAME_KEY];
}

- (void)showHomeScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadHomeScreen];
}

@end
