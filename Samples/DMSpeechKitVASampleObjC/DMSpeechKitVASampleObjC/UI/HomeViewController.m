//
//  ViewController.m
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "VAManager.h"
#import "Logger.h"
#import "VADelegate.h"

@interface HomeViewController () <LoggerDelegate, IntentDelegate, VADelegate>
@property (weak, nonatomic) IBOutlet UITextView *dictationTextView;
@property (weak, nonatomic) IBOutlet UITextView *logsTextView;
@property (nonatomic) NUSAVuiController *vuiController;
@end

@implementation HomeViewController

#pragma mark -
#pragma mark ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize logger with 'delegate' for updates
    [Logger initLogger:self];
    [[IntentManager sharedInstance] setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[VAManager sharedInstance] setVaDelegate:self];
    [self initializeVA];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)copyButtonPressed:(id)sender {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.logsTextView.text];
}

- (IBAction)clearButtonPressed:(id)sender {
    self.logsTextView.text = @"";
    [Logger resetLoggerDump];
}

#pragma mark -
#pragma mark Other utility methods

- (void)initializeVA {
    [[VAManager sharedInstance] initializeVAController];
}

- (void)initializeVuiController {
    // Initializing the VuiController in viewDidLoad
    self.vuiController = [[NUSAVuiController alloc] initWithView:self.view andDisableSpeechViews:NO];
    self.logsTextView.vuiEnabled = NO;
    [self.dictationTextView becomeFirstResponder];
    [self.vuiController synchronizeWithView];
}

- (void) updateTextView {
    NSString* logText = [Logger getLoggerDump];
    self.logsTextView.text = logText;
    NSRange bottom = NSMakeRange(logText.length - 1, 1);
    [self.logsTextView scrollRangeToVisible:bottom];
}

#pragma mark -
#pragma mark LoggerDelegate

- (void) loggerBufferUpdated {
    [self updateTextView];
}

#pragma mark -
#pragma mark IntentDelegate

- (void) focusDictation {
    [self.dictationTextView becomeFirstResponder];
}

#pragma mark -
#pragma mark VADelegate

- (void) onVAInitializationSucceeded {
    [self initializeVuiController];
}

@end
