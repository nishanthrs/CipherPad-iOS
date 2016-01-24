//
//  SNFSegmentedViewController.m
//  SNFSegmentedViewController
//
//  Created by Seth Friedman on 7/29/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "SNFSegmentedViewController.h"
#import "MathNotesViewController.h"
#import "SingleTextViewController.h"
#import <AtkMaw/MAWMathWidget.h>
#import <AtkMltw/MultiLineTextWidget.h>
#import <AtkSltw/SLTWTextWidget.h>
#import <AtkItc/ITC.h>

@interface SNFSegmentedViewController () <UITabBarControllerDelegate>

@end

@implementation SNFSegmentedViewController

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self configureForInitialization];
    }
    
    [self hideTabBar];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configureForInitialization];
    }
    
    [self hideTabBar];
    
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.segmentedControl.selectedSegmentIndex = self.selectedIndex;
    
    [self hideTabBar];
}

#pragma mark - IB Action

- (IBAction)segmentTapped:(UISegmentedControl *)sender {
    self.selectedIndex = sender.selectedSegmentIndex;
}

#pragma mark - Helper Methods

- (void)configureForInitialization {
    self.delegate = self;
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[self.tabBar.items count]];
    
    for (UITabBarItem *tabBarItem in self.tabBar.items) {
        [titles addObject:tabBarItem.title];
    }
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems: @[@"Math VC", @"Text VC"]];
    _segmentedControl.selectedSegmentIndex = self.selectedIndex;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
#endif
    
    [_segmentedControl addTarget:self
                          action:@selector(segmentTapped:)
                forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
    //[self.view addSubview: _segmentedControl];
}

// This borrows code from @bshirley at http://stackoverflow.com/questions/1982172/iphone-is-it-possible-to-hide-the-tabbar
- (void)hideTabBar {
    UITabBar *tabBar = self.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews firstObject];  // UITransitionView
    UIView *window = parent.superview;
    
    CGRect tabFrame = tabBar.frame;
    tabFrame.origin.y = CGRectGetMaxY(window.bounds);
    tabBar.frame = tabFrame;
    content.frame = window.bounds;
    
}

@end
