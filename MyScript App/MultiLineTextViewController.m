//
//  MultiLineTextViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 12/9/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "MultiLineTextViewController.h"

@interface MultiLineTextViewController ()

@end

@implementation MultiLineTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview: _multiLineView];
    
    if (_multiLineView) {
        NSLog(@"MULTILINE VIEW NOT NULL");
    }
    else {
        NSLog(@"MULTILINE VIEW NULL!");
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 500, 300, 30)];
    [self.view addSubview: textField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate methods

- (void) multiLineViewDidBeginConfiguration:(MLTWMultiLineView *)view {
    NSLog(@"MULTI LINE VIEW BEGIN CONFIGURATION");
}

- (void) multiLineViewDidEndConfiguration:(MLTWMultiLineView *)view {
    NSLog(@"MULTI LINE VIEW END CONFIGURATION!");
}

- (void) multiLineViewDidStartRecognition:(MLTWMultiLineView *)view {
    NSLog(@"MULTI LINE VIEW START RECOGNITION");
}

- (void) multiLineViewDidEndRecognition:(MLTWMultiLineView *)view {
    NSLog(@"MULTI LINE VIEW DID END RECOGNITION");
}

- (void) multiLineView:(MLTWMultiLineView *)view didFailConfigurationWithError:(NSError *)error {
    NSLog(@"ERROR WITH CONFIGURATION: %@", error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
