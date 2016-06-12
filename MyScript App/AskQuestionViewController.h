//
//  AskQuestionViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TAOverlay.h"
#import "QuestionObject.h"

@interface AskQuestionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) PFObject *question;

@property (strong, nonatomic) IBOutlet UITextField *questionTopicTextField;
@property (strong, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *questionImageView;

- (void) removeVC;
- (void) postQuestionButtonPressed;

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)postQuestionButtonPressed:(UIBarButtonItem *)sender;

@end
