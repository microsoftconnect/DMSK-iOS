//
//  DictationView.h
//  DMSpeechKitDocSample
//
//  Copyright 2015 Nuance Communications, Inc. All rights reserved.
//

@import DragonMedicalSpeechKit;

@protocol DictationViewDelegate;
@class NUSAVuiController;

@interface DictationView : UIViewController <NUSASessionDelegate, NUSAVuiControllerDelegate> {
    UIButton* recordToggleButton;
    IBOutlet UITextField*	editField;
    IBOutlet UITextView*	textView;
    IBOutlet UILabel*       documenttype;
    NUSAVuiController*	vuiController;
    id<DictationViewDelegate> delegate;
}

@property (nonatomic) id<DictationViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIButton* recordToggleButton;
@property (nonatomic, retain) IBOutlet NUSAVuiController* vuiController;
@property (nonatomic, retain) UITextField*	editField;
@property (nonatomic, retain) UITextView*	textView;
@property (nonatomic, retain) UILabel*	documenttype;
@property bool docAOpen;
@property bool docBOpen;
@property (nonatomic, retain) NSString* field1StringA;
@property (nonatomic, retain) NSString* field2StringA;
@property (nonatomic, retain) NSString* field1StringB;
@property (nonatomic, retain) NSString* field2StringB;

- (IBAction) doneAction: (id) sender;
- (IBAction) toggleRecordingAction: (id) sender;
- (IBAction) switchDocumentAction: (id) sender;

@end

@protocol DictationViewDelegate <NSObject>
- (void) dictationViewDidFinish: (DictationView*) dictationView;
@end

