//
//  InteractiveTextViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "InteractiveTextViewController.h"

@interface InteractiveTextViewController ()

@end

@implementation InteractiveTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Instantiate an ITCStrokeFactory and ITCWordFactory
    ITCStrokeFactory *strokeFactory = [ITCStrokeFactory strokeFactory:nil];
    ITCWordFactory *wordFactory = [ITCWordFactory wordFactoryWithStrokeFactory: strokeFactory wordUserParamFactory: nil];
    
    // Instantiate an ITCSmartPage
    ITCSmartPage *page = [ITCSmartPage smartPageWithWordFactory: wordFactory];
    
    // Register self as delegate to be notified for strokes/words added/removed and recognition
    [page setGestureDelegate: self];
    [page setRecognitionDelegate:self];
    
    // Attach the page on the page interpreter[pageInterpreter setPage:page];
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
