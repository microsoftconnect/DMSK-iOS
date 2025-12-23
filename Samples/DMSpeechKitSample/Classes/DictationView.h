//
//  DictationView.h
//  DMSpeechKitSample
//
//  Copyright 2011 Nuance Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import DragonMedicalSpeechKit;

@protocol DictationViewDelegate;
@class NUSAVuiController; 

@interface DictationView : UIViewController <NUSASessionDelegate, NUSAVuiControllerDelegate> {
	UIButton* recordToggleButton;
    IBOutlet UITextField*	editField;
	IBOutlet UITextView*	textView;
	NUSAVuiController*	vuiController;
	id<DictationViewDelegate> delegate; 
}

@property (nonatomic) id<DictationViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton* recordToggleButton;
@property (nonatomic, retain) IBOutlet NUSAVuiController* vuiController;
@property (nonatomic, retain) UITextField*	editField;
@property (nonatomic, retain) UITextView*	textView;

- (IBAction) doneAction: (id) sender;
- (IBAction) toggleRecordingAction: (id) sender; 

@end

@protocol DictationViewDelegate <NSObject>
- (void) dictationViewDidFinish: (DictationView*) dictationView;
@end

