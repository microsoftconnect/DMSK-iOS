//
//  SpeechKitSampleViewController.m
//  DMSpeechKitSample
//
//  Copyright 2011 Nuance Communications, Inc. All rights reserved.
//

@import DragonMedicalSpeechKit;

#import "SpeechKitSampleViewController.h"

#define kMyApplicationName	@"DMSpeechKitSample"

// Convenience defines used for opening the NUSASession instance and pass it the licensing
// information needed. Partner GUID and organization token will be made available to you via the
// Nuance order desk.

// It is ok to hard-code the partner GUID - should be "hidden" within your application,
// usually will not need to be changed.
#define kMyPartnerGuid		@"ENTER_YOUR_PARTNER_GUID"

// THIS IS CUSTOMER SPECIFIC - MUST *NOT* BE HARD-CODED!
// THIS IS EQUIVALENT TO A LICENSE KEY - MUST BE KEPT SECRET FROM UNAUTHORIZED USERS!
// Make it configurable via user settings or download it from your server if you have a client-server app.
#define kMyOrganizationToken		@"ENTER_YOUR_ORGANIZATION_TOKEN"

@implementation SpeechKitSampleViewController
@synthesize userLoggedIn;

#pragma mark -
#pragma mark UIViewController delegate messages

- (void)viewDidAppear:(BOOL)animated {
    if (userLoggedIn == NO) {
        if(self.storyboard!=nil)
        {
            LoginViewController *loginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            if(loginViewController!=nil){
                loginViewController.delegate = self;
                [self presentViewController:loginViewController animated:TRUE completion:nil];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userLoggedIn = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"DictationViewSegue"]){
        DictationView *dictationView = [segue destinationViewController];
        dictationView.delegate = self;
    }
}

#pragma mark -
#pragma mark LoginViewControllerDelegate messages

- (void) loginViewController:(LoginViewController *)controller didLoginUser:(NSString *)userName {
    [self dismissViewControllerAnimated:YES completion:nil];
    userLoggedIn = YES;
    
    // The loginViewController:didLoginUser message is sent to us once the user logged in via the
    // LoginViewController view presented to him at the start of the application. We will use the
    // user name as given in that view for licensing information passed to the Dragon Medical SpeechKit
    [[NUSASession sharedSession] openForApplication: kMyApplicationName partnerGuid: kMyPartnerGuid licenseGuid: kMyOrganizationToken userId: userName];
}

#pragma mark -
#pragma mark DictationViewDelegate messages

- (void) dictationViewDidFinish: (DictationView*) dictationView {
    [dictationView dismissViewControllerAnimated:YES completion:nil];
}

@end
