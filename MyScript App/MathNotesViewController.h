//
//  MathNotesViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 8/20/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkMaw/MAWMathWidget.h>
#import <Parse/Parse.h>
#import "TAOverlay.h"
#import "RNFrostedSidebar.h"
#import "WYPopoverController.h"
#import "WolframTableViewController.h"

@interface MathNotesViewController : MAWMathViewController <UIApplicationDelegate, MAWMathViewControllerDelegate, WYPopoverControllerDelegate, RNFrostedSidebarDelegate>

@property (strong, nonatomic) NSString *globalRequestURL;

@property (strong, nonatomic) NSMutableArray *podIDInformation;
@property (strong, nonatomic) NSMutableArray *podLinkInformation;

@property (strong, nonatomic) NSString *podStateName;
@property (strong, nonatomic) NSString *podStateURL;
@property (strong, nonatomic) NSString *podStateImageURL;

//---------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *podStateNames;
@property (strong, nonatomic) NSMutableArray *podStateURLs; 
@property (strong, nonatomic) NSMutableArray *podStateImageURLs;
//---------------------------------------------------------------

@property (strong, nonatomic) UIButton *undoButton;
@property (strong, nonatomic) UIButton *redoButton;

@property (strong, nonatomic) WolframTableViewController *wolframTableViewController;

@end
