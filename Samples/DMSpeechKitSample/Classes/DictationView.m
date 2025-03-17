//
//  DictationView.m
//  DMSpeechKitSample
//
//  Copyright 2011 Nuance Communications, Inc. All rights reserved.
//

#import "DictationView.h"

@implementation DictationView
@synthesize vuiController; 
@synthesize delegate; 
@synthesize recordToggleButton; 
@synthesize editField;
@synthesize textView;

#pragma mark -
#pragma mark UIViewController delegate messages 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload {
	// Warning: 
	// Releasing the vui controller in the viewDidUnload method will not work, as the 
	// vui controller retains your UI view, preventing it from being unloaded by the 
	// framework. Release the vui controller at an earlier point in time to allow the 
	// runtime to unload your view. 
}

- (void) viewWillAppear:(BOOL)animated {
    // Set up our record button 
    [recordToggleButton setTitle: @"Record" forState: UIControlStateNormal];
    [recordToggleButton setTitle: @"Stop" forState: UIControlStateSelected]; 
    
	// Uncomment the code below if you want to create the NUSAVuiController instance 
	// programmatically instead of via a NIB file. In case you create the NUSAVuiController 
	// in this way, the view object (including all of its subviews) needs to be fully 
	// loaded as the vui controller will inspect the view at the time it is created to 
	// create the vui model that is used to speech-enable your UI view. 
	// 
	// Attention: 
	// The current implementation connects the vui controller with our UI view in the 
	// IF Builder XIB file (see DictationView.xib) for reference. 
#if 0
	NUSAVuiController* ourVuiController = [[NUSAVuiController alloc] initWithView: self.view]; 
	self.vuiController = ourVuiController;
#endif
	
	// In order to receive NUSASession delegate messages, set ourselves as the session 
	// delegate. Doing so, will tell the NUSASession instance to send the start recording and 
	// stop recording delegate messages. Doing so is optional and only needed if you want to 
	// present a record toggle button in your UI that updates according to the recording state 
	// of the NUSASession.
	[[NUSASession sharedSession] setDelegate: self]; 
	
	// Enabling named field navigation for the end user. Dragon Medical SpeechKit will automatically create
    // voice commands based on the vuiConceptName property set for speech enabled controls. E.g. 
    // the vuiConceptName properties below will result in the user being able to say "go to reason for admission"
    // and "go to medical history" to set the focus to the editField and textView control. Sequential 
    // voice navigation is enabled by default, e.g. the user will always be able to say "next field" and 
    // "previous field". 
	editField.vuiConceptName = @"reason for admission";
	textView.vuiConceptName = @"medical history";
    
    // create a command set and command placeholder
    NUSACommandSet* commandSet = [[NUSACommandSet alloc] initWithName:@"show things" description:@"show some things"];
    [commandSet createCommand:@"SHOW_ANIMALS" phrase:@"show me <ANIMALS>" displayString:@"" description:@"show animals"];
    [commandSet createCommand:@"SPEAK_ANIMALS" phrase:@"tell me <ANIMALS>" displayString:@"" description:@"speak animals"];
    // create an alternative phrase 
    [commandSet createCommand:@"SPEAK_ANIMALS" phrase:@"speak <ANIMALS>" displayString:@"" description:@"speak animals"];
    NUSACommandPlaceholder* commandPlaceholder = [[NUSACommandPlaceholder alloc] initWithID:@"ANIMALS" label:@"animals"];
    [commandPlaceholder setValues:[NSArray arrayWithObjects:@"DOGS", @"CATS", nil] withSpokenForms:[NSArray arrayWithObjects:@"dogs", @"cats", nil]];
    // assign command set and placeholder to the vuis controller
    [vuiController assignCommandSets:[NSArray arrayWithObjects:commandSet, nil]];
    [vuiController assignCommandPlaceholders:[NSArray arrayWithObjects:commandPlaceholder, nil]];
    // The cui controller must be synchronized to enable the application commands
    [vuiController synchronizeWithView];
    [vuiController setDelegate:self];
}

- (void) viewWillDisappear:(BOOL)animated {
	// Release the vui controller instance, once it is no longer needed. Releasing the 
	// vui controller frees speech recognition resources on the server and disconnects 
	// from the service. If you do not release the vui controller on your own, the SDK 
	// will do so once you create another vui controller in your application. 
	self.vuiController = nil; 
	
	// Also remove ourselves as the NUSASessions delegate 
	[[NUSASession sharedSession] setDelegate: nil]; 

	// We do not need to take care of recording, as the Dragon Medical SpeechKit will
	// automatically stop recording for us if it was still running at the time the vui 
	// controller is released. 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action messages 

- (void) doneAction:(id)sender {
	[delegate dictationViewDidFinish: self]; 
}

- (void) toggleRecordingAction: (id) sender {
	// Implement a simple toggle recording method. For simplicities sake, we use the selected
    // property of the record toggle button to decide which NUSASession method to call. 	
	if (recordToggleButton.selected == NO) {
        [[NUSASession sharedSession] startRecording: nil]; 
    }
    else {
        [[NUSASession sharedSession] stopRecording]; 
    }
    recordToggleButton.selected = !recordToggleButton.selected;
}

#pragma mark -
#pragma mark NUSASessionDelegate messages 

- (void) sessionDidStartRecording {
	// This delegate message is sent in case recording was started by the user. Sending the startRecording: message 
	// to the NUSASession instance does not send trigger this message. We react by changing the toggle record button 
	// state. 
	[recordToggleButton setSelected: YES]; 
}

- (void) sessionDidStopRecording {
	// This delegate message is sent in case recording was stopped by the user or in case of an error. Sending the 
	// stopRecording message to the NUSASession instance does not trigger this message. We react by changing the toggle 
	// record button state. In case an error occured, the user will be informed by the Dragon Medical SpeechKit.
	[recordToggleButton setSelected: NO];  
}

- (void) sessionDidStartStandby {
    [recordToggleButton setSelected: NO];
}

#pragma mark -
#pragma mark NUSAVuiControllerDelegate messages 

- (void) vuiControllerDidRecognizeCommand: (NSString*) id spokenPhrase: (NSString*) spokenPhrase placeholderValues: (NSDictionary *) placeholderValues {
	// This delegate message is sent in case a command was recognized
    // check the command id
    if ([id isEqualToString:@"SHOW_ANIMALS"] || [id isEqualToString:@"SPEAK_ANIMALS"])
    {
        NSString* title = [placeholderValues objectForKey:@"ANIMALS"];
        NSString* text;
        // check the command placeholder
        if ([title isEqualToString:@"DOGS"])
        {
            text = @"poodle\npug\nsausage dog";
        }
        else
        {
            text = @"lion\ntiger\ncougar";
        }
        // trigger different actions depending on the recognized command
        if ([id isEqualToString:@"SHOW_ANIMALS"])
        {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:title
                                               message:text
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];    
            [alert show];
        }
        else
        {
            [[NUSASession sharedSession] startSpeaking:text];
        }
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
