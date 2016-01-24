//
//  AskQuestionViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "AskQuestionViewController.h"

@interface AskQuestionViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) CGRect prevFrame;

@end

@implementation AskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCamera target: self action: @selector(cameraButtonPressed)];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle: @"Post" style: UIBarButtonItemStyleDone target: self action: @selector(postQuestionButtonPressed)];
    
    self.navigationItem.rightBarButtonItems = @[postButton, cameraButton];
    
    self.questionImageView.userInteractionEnabled = YES;
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.delegate = self;
    
    [self.questionImageView addGestureRecognizer: self.singleTap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    BOOL shouldReceiveTouch = YES;
    
    if (gestureRecognizer == self.singleTap) {
        shouldReceiveTouch = (touch.view == self.questionImageView);
    }
    return shouldReceiveTouch;
}

- (void) handleSingleTap: (id) sender {
    if (!self.isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            self.prevFrame = self.questionImageView.frame;
            [self.questionImageView setFrame:[[UIScreen mainScreen] bounds]];
        }completion:^(BOOL finished){
            self.isFullScreen = true;
        }];
    }
    else {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [self.questionImageView setFrame: self.prevFrame];
        }completion:^(BOOL finished){
            self.isFullScreen = false;
        }];
    }
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate 

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) cameraButtonPressed {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"Photo Selection" delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Take Photo", @"Select Photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView: self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    int i = buttonIndex;
    switch(i) {
        case 0: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController: picker animated: YES completion: nil];
        }
        case 1: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController: picker animated: YES completion: nil];
        }
        default: {
            break;
        }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (! image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    self.questionImageView.image = image;
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) postQuestionButtonPressed {
    if (self.questionTopicTextField.text.length == 0) {
        [TAOverlay showOverlayWithLabel: @"Put in a question topic!" Options: TAOverlayOptionOverlayTypeError | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAutoHide];
    }
    else if (self.questionTextView.text.length == 0) {
        [TAOverlay showOverlayWithLabel: @"Put in your question!!" Options: TAOverlayOptionOverlayTypeError | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAutoHide];
    }
    else {
        QuestionObject *questionAsked = [[QuestionObject alloc] initWithQuestionTopic: self.questionTopicTextField.text andQuestion: self.questionTextView.text andImage: self.questionImageView];
        NSLog(@"POST BUTTON TAPPED WITH CORRECT PRE-CONDITIONS");
        self.question = [PFObject objectWithClassName: @"Question"];
        self.question[@"questionTopic"] = questionAsked.questionTopic;
        self.question[@"questionString"] = questionAsked.questionString;
        //self.question[@"questionImage"] = questionAsked.questionImage;
        [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"QUESTION SAVED SUCCESSFULLY!");
            }
            else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
        NSLog(@"%@", self.question);
    }
    [self performSegueWithIdentifier: @"backToQuestionFeedSegue" sender: nil];
}

@end
