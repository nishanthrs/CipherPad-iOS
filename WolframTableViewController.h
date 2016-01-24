//
//  WolframTableViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/11/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "WolframTableViewCell.h"
#import "DataScreenshotCollectionViewController.h"
#import "TAOverlay.h"

@interface WolframTableViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic) int selectedIndex;

@property (strong, nonatomic) UIColor *cellBackgroundColor;

@property (strong, nonatomic) NSString *testProperty;
@property (strong, nonatomic) NSMutableArray *podIDArray;
@property (strong, nonatomic) NSMutableArray *podImagesLinkArray;

@property (strong, nonatomic) NSString *podStateName;
@property (strong, nonatomic) NSString *podStateLink; 
@property (strong, nonatomic) NSString *podStateImageLink;

//-----------------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *podStatesNamesArray;
@property (strong, nonatomic) NSMutableArray *podStatesLinksArray;
@property (strong, nonatomic) NSMutableArray *podStatesImagesLinksArray;
//-----------------------------------------------------------------------

@property (strong, nonatomic) NSMutableArray *screenshotDataArray;

@property (strong, nonatomic) DataScreenshotCollectionViewController *dataScreenshotCollectionViewController;

@property (strong, nonatomic) PFObject *parsedWolframData;

@end
