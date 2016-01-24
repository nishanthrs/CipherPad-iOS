//
//  ViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 8/18/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "ViewController.h"
#import "MathNotesViewController.h"
#import <Parse/Parse.h>

@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) MathNotesViewController *mathNotesViewController;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.mathNotesViewController = [[MathNotesViewController alloc] init];
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey: @"deviceType" equalTo: @"ios"];
    
    // Send push notification to query
    [PFPush sendPushMessageToQueryInBackground: pushQuery withMessage: @"Hello World!"];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.loginView animate];
}

#pragma mark - Logging in user and testing login credentials

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.usernameIcon setImage: [UIImage imageNamed: @"icon-mail-active"]];
        self.usernameTextField.textColor = [UIColor purpleColor]; //Change purple hue
        if ([self.usernameTextField.text isEqualToString: @"Incorrect Info!"]) {
            self.usernameTextField.text = @"";
        }
    }
    else {
        [self.usernameIcon setImage: [UIImage imageNamed: @"icon-mail"]];
        self.usernameTextField.textColor = [UIColor purpleColor];
    }
    if (textField == self.passwordTextField) {
        [self.passwordIcon setImage: [UIImage imageNamed: @"icon-password-active"]];
        self.passwordTextField.textColor = [UIColor purpleColor]; //Change purple hue
        if ([self.passwordTextField.text isEqualToString: @"Try Again!"]) {
            self.passwordTextField.text = @"";
        }
    }
    else {
        [self.passwordIcon setImage: [UIImage imageNamed: @"icon-password"]];
        self.passwordTextField.textColor = [UIColor purpleColor];
    }
}

- (void) performSceneTransition {
    
}

- (IBAction)loginButtonPressed:(id)sender {
    [PFUser logInWithUsernameInBackground: self.usernameTextField.text password: self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"LOGIN SUCCESSFUL!");
            self.loginView.animation = @"zoomOut";
            [self.loginView animate];
            //[self performSelector: @selector(performSceneTransition) withObject: nil afterDelay: 0.4];
        }
        else {
            NSLog(@"LOGIN UNSUCCESSFUL!!!");
            self.loginView.animation = @"shake";
            [self.loginView animate];
            self.usernameTextField.text = @"Incorrect Info!";
            self.usernameTextField.textColor = [UIColor redColor];
            self.passwordTextField.text = @"Try Again!";
            self.passwordTextField.textColor = [UIColor redColor];
        }
    }];
}

@end
