//
//  MultiLineTextViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 12/9/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkMltw/MultiLineTextWidget.h> 

@interface MultiLineTextViewController : UIViewController <MLTWMultiLineViewDelegate>

@property (strong, nonatomic) MLTWMultiLineView *multiLineView;

@end
