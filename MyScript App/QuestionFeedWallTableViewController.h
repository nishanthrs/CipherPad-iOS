//
//  QuestionFeedWallTableViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AskQuestionViewController.h"
#import "QuestionObject.h"

@interface QuestionFeedWallTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *questionFeedArray;

@property (strong, nonatomic) QuestionObject *question;

@property (strong, nonatomic) AskQuestionViewController *askQuestionVC;

@end
