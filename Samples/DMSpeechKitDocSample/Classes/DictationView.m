//
//  DictationView.m
//  DMSpeechKitDocSample
//
//  Copyright 2015 Nuance Communications, Inc. All rights reserved.
//

@import DragonMedicalSpeechKit;

#import "DictationView.h"

@implementation DictationView
@synthesize documenttype;
@synthesize vuiController;
@synthesize delegate;
@synthesize recordToggleButton;
@synthesize editField;
@synthesize textView;
@synthesize docAOpen;
@synthesize docBOpen;
@synthesize field1StringA;
@synthesize field1StringB;
@synthesize field2StringA;
@synthesize field2StringB;

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
//#if 0
    NUSAVuiController* ourVuiController = [[NUSAVuiController alloc] initWithView: self.view];
    vuiController = ourVuiController;
//#endif
    
    // In order to receive NUSASession delegate messages, set ourselves as the session
    // delegate. Doing so, will tell the NUSASession instance to send the start recording and
    // stop recording delegate messages. Doing so is optional and only needed if you want to
    // present a record toggle button in your UI that updates according to the recording state
    // of the NUSASession. 
    [[NUSASession sharedSession] setDelegate: self];
    
    // The vui controller must be synchronized to enable the application commands
    [vuiController synchronizeWithView];
    [vuiController setDelegate:self];
    
    // Initialize members with default values
    field1StringA = @"";
    field2StringA = @"";
    field1StringB = @"";
    field2StringB = @"";
    
    docAOpen = NO;
    docBOpen = NO;
    
    [self openDocumentA];
    [self updateDocumentName];
    
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
#pragma mark Document handling management

-(void) closeDocumentA {
    // Set the appropriate metadata key-value pairs
    [self.vuiController setDocumentMetadata:@"valueA" forKey:@"keyA"];
    
    // Close the document on the VuiController. The user's corrections are save by Dragon Medical SpeechKit.
    // From this point on up to the next "open" call, the VuiController is not associated with any document hence speech recognition doesn't work.
    // The status is "InWork", because in the sample application's workflow, it is possible to reopen this document and continue working on it.
    // See the SDK documentation for the other states which may better cover the workflow of your application.
    [self.vuiController closeWithDocumentId:@"DocumentA" andState:kNUSADocumentStateUndefined];
    
    // saving text from the fields of this document
    field1StringA = editField.text;
    field2StringA = textView.text;
    
    // clear fields
    editField.text = @"";
    textView.text = @"";
    
    // keep track if the document is opened/closed
    docAOpen = NO;
}

-(void) closeDocumentB {
    // Set the appropriate metadata key-value pairs
    [self.vuiController setDocumentMetadata:@"valueB" forKey:@"keyB"];
    
    // Close the document on the VuiController. The user's corrections are save by Dragon Medical SpeechKit.
    // From this point on up to the next "open" call, the VuiController is not associated with any document hence speech recognition doesn't work.
    // The status is "InWork", because in the sample application's workflow, it is possible to reopen this document and continue working on it.
    // See the SDK documentation for the other states which may better cover the workflow of your application.
    [self.vuiController closeWithDocumentId:@"DocumentB" andState:kNUSADocumentStateUndefined];
    
    // saving text from the fields of this document
    field1StringB = editField.text;
    field2StringB = textView.text;
    
    // clear fields
    editField.text = @"";
    textView.text = @"";
    
    // keep track if the document is opened/closed
    docBOpen = NO;
}

-(void) openDocumentA {
    // load the document into the speech-enabled fields in the UI
    editField.text = field1StringA;
    textView.text = field2StringA;
    
    // Set the mapping between the speech-enabled text fields and the fields of the underlying document
    editField.vuiDocumentFieldId = @"documentField1"; // This field identifier exists in both documents
    textView.vuiDocumentFieldId = @"field2InDocumentA"; // This field identifier is unique to document A
    
    // open the document on the VuiController - from this point on speech recognition is usable
    [self.vuiController openWithDocumentId:@"DocumentA"];
    
    // to keep track if the document is opened/closed
    docAOpen = YES;
}

-(void) openDocumentB {
    // load the document into the speech-enabled fields in the UI
    editField.text = field1StringB;
    textView.text = field2StringB;
    
    // Set the mapping between the speech-enabled text fields and the fields of the underlying document
    editField.vuiDocumentFieldId = @"documentField1"; // This field identifier exists in both documents
    textView.vuiDocumentFieldId = @"field2InDocumentB"; // This field identifier is unique to document B
    
    // open the document on the VuiController - from this point on speech recognition is usable
    [self.vuiController openWithDocumentId:@"DocumentB"];
    
    // to keep track if the document is opened/closed
    docBOpen = YES;
}

-(void) updateDocumentName {
    if (docAOpen) {
        documenttype.text = @"Document A";
    } else if (docBOpen) {
        documenttype.text = @"Document B";
    } else {
        documenttype.text = @"";
    }
}

-(void) toggleBetweenDocs {
    // Implement a simple toggle recording method. Depending on which document is open.
    if (docAOpen) {
        [self closeDocumentA];
        [self openDocumentB];
    } else {
        [self closeDocumentB];
        [self openDocumentA];
    }
    
    [self updateDocumentName];
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
}

-(void) switchDocumentAction:(id)sender {
    [self toggleBetweenDocs];
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

#pragma mark -
#pragma mark NUSAVuiControllerDelegate messages

- (void) vuiControllerDidRecognizeCommand: (NSString*) id spokenPhrase: (NSString*) spokenPhrase placeholderValues: (NSDictionary *) placeholderValues {
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
