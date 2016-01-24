//
//  SingleTextViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 10/25/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkSltw/SLTWTextWidget.h>
#import "WolframTableViewController.h"
#import "TAOverlay.h"

@interface SingleTextViewController : UIViewController <SLTWTextWidgetDelegate>

@property (strong, nonatomic) SLTWTextWidget *textWidget;
@property (strong, nonatomic) UIBarButtonItem *btItemExport;
@property (strong, nonatomic) UIPopoverController *menuPopoverController;
@property (strong, nonatomic) NSString *globalRequestURL;

@property (strong, nonatomic) WolframTableViewController *wolframTableViewController;

@property (strong, nonatomic) NSMutableArray *podIDInformation;
@property (strong, nonatomic) NSMutableArray *podLinkInformation;

@end
