//
//  ExportMenuTableViewController.h
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "TextNotesViewController.h"
#import <UIKit/UIKit.h>

@interface ExportMenuTableViewController : UITableViewController

@property (nonatomic, strong) TextNotesViewController    *viewController;
@property (nonatomic, strong) UIPopoverController *parentPopopController;

@end