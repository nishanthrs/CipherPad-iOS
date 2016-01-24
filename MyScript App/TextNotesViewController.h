//
//  TextNotesViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 10/24/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkMltw/MultiLineTextWidget.h> 
#import "MenuTableViewController.h"
#import "ExportMenuTableViewController.h"
#import "RNFrostedSidebar.h"
//#import "com.parsePush.MyScriptApp.h"
#import "XMLReader.h"

@interface TextNotesViewController : UIViewController <UIApplicationDelegate, MLTWMultiLineViewDelegate, RNFrostedSidebarDelegate>

@property (strong, nonatomic) IBOutlet UILabel                 *lblNotif;
@property (strong, nonatomic) IBOutlet UITextView              *textView;
@property (strong, nonatomic) IBOutlet MLTWMultiLineView       *widget;
@property (strong, nonatomic) IBOutlet UILabel                 *lblPageNumber;
@property (strong, nonatomic) IBOutlet UIButton                *btPrevPage;
@property (strong, nonatomic) IBOutlet UIButton                *btNextPage;
@property (strong, nonatomic) IBOutlet UIScrollView            *candidateView;
@property (strong, nonatomic) IBOutlet UIView                  *lineView;
@property (strong, nonatomic) IBOutlet UIButton                *btReflow;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)previousPageAction:(UIButton *)sender;

- (IBAction)nextPageAction:(UIButton *)sender;

- (IBAction)reflowAction:(UIButton *)sender;

//----------------------------------
#pragma mark Menu Buttons
//----------------------------------

#pragma mark Clear

- (void)clear;

#pragma mark Language/Locale

@property (nonatomic, strong) NSString *locale;

#pragma mark Scroll/Page Mode

@property (nonatomic, assign, getter = isScrollView) BOOL scrollingView;

@property (nonatomic, assign, getter = isAutoScroll) BOOL autoScroll;

#pragma mark Scroll view

@property (nonatomic, assign, readonly) CGFloat widgetViewHeight;

@property (nonatomic, assign) CGFloat inputViewHeight;

#pragma mark Line Space

@property (nonatomic, assign) int lineSpaceIndex;

#pragma mark Export

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) UIImage  *image;

@property (strong, nonatomic) NSData *certificate;

- (void)exportText;

- (void)exportImage;

- (void)exportImageAndText;

@end
