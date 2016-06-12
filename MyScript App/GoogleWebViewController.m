//
//  GoogleWebViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 6/12/16.
//  Copyright © 2016 Nishanth Salinamakki. All rights reserved.
//

#import "GoogleWebViewController.h"

@interface GoogleWebViewController ()

@end

@implementation GoogleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(removeViewController)];
    
    [self.view addSubview: self.webView];
}

- (void) removeViewController {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
