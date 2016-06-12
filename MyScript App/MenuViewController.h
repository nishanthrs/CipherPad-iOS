//
//  MenuViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 6/11/15.
//  Copyright (c) 2016 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "com.parsePush.MyScriptApp.h"
#import "QuestionFeedWallTableViewController.h"
#import "MathNotesViewController.h"
#import "TextNotesViewController.h"
#import "SingleTextViewController.h"
#import "SpeechEngineViewController.h"
#import "PicCipherViewController.h"
#import <AtkMaw/MAWMathWidget.h>
#import <AtkMltw/MultiLineTextWidget.h>
#import <AtkSltw/SLTWTextWidget.h>
#import <AtkItc/ITC.h>

@interface MenuViewController : UIViewController <RNFrostedSidebarDelegate>

- (IBAction)hamburgerBarButtonItemPressed:(UIBarButtonItem *)sender;

- (IBAction)mathCipherButton:(id)sender;
- (IBAction)textCipherButton:(id)sender;
- (IBAction)speechCipherButton:(id)sender;
- (IBAction)askQuestionButtonPressed:(id)sender;
- (IBAction)picCipherButtonPressed:(id)sender;

@end
