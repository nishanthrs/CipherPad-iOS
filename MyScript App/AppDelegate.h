//
//  AppDelegate.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 8/18/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkMaw/MAWMathWidget.h>
#import <AtkMltw/MultiLineTextWidget.h>
#import <AtkSltw/SLTWTextWidget.h>
#import <SpeechKit/Speechkit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) setupSpeechKitConnection;

@end

