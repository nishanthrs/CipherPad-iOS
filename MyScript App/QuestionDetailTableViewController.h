//
//  QuestionDetailTableViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 6/12/16.
//  Copyright © 2016 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "QuestionObject.h"

@interface QuestionDetailTableViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) QuestionObject *questionObject;
@property (strong, nonatomic) NSArray *comments;

@property (strong, nonatomic) UIView *customToolbar;

@property (strong, nonatomic) UITextField *invisibleTextField;
@property (strong, nonatomic) UITextField *toolbarTextField;

@end
