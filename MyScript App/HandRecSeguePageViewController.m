//
//  HandRecSeguePageViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 12/4/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "HandRecSeguePageViewController.h"

@interface HandRecSeguePageViewController ()

@end

@implementation HandRecSeguePageViewController

- (void) setViewControllers:(NSArray<UIViewController *> *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MathNotesViewController *mathVC = [[MathNotesViewController alloc] init];
    SingleTextViewController *textVC = [[SingleTextViewController alloc] init];
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
