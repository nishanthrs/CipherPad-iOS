//
//  ViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 8/18/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Spring.h"
#import <MyScript_App-Swift.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet SpringView *loginView;

@property (strong, nonatomic) IBOutlet DesignableTextField *usernameTextField;
@property (strong, nonatomic) IBOutlet DesignableTextField *passwordTextField;

@property (strong, nonatomic) IBOutlet SpringImageView *usernameIcon;
@property (strong, nonatomic) IBOutlet SpringImageView *passwordIcon;

@property (strong, nonatomic) IBOutlet SpringButton *loginButton;

- (IBAction)loginButtonPressed:(id)sender;

@end

