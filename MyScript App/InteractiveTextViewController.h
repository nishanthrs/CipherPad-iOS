//
//  InteractiveTextViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkItc/ITC.h>

@interface InteractiveTextViewController : UIViewController <ITCPageInterpreterDelegate, ITCSmartPageRecognitionDelegate, ITCSmartPageGestureDelegate, ITCSmartPageChangeDelegate, ITCWordUserParamsFactoryProtocol, ITCStrokeUserParamsFactoryProtocol>

@end
