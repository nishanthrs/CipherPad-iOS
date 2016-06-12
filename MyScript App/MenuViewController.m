//
//  MenuViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 10/25/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "MenuViewController.h"
#import "MultiLineTextViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Segue id: %@", segue.identifier);
    if ([segue.identifier isEqualToString: @"toMath"]) {
        MAWMathViewController *mathVC = segue.destinationViewController;

        //[mathVC configureWithResources:@[@"math-ak.res", @"math-grm-maw.res"] certificate:[NSData dataWithBytes: myCertificate.bytes length: myCertificate.length]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)hamburgerBarButtonItemPressed:(UIBarButtonItem *)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"icon-mail-active"],
                        [UIImage imageNamed:@"wolframalpha_logo"],
                        [UIImage imageNamed:@"icon-mail-active"],
                        [UIImage imageNamed:@"icon-password-active"]
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1]
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices: self.optionIndices borderColors:colors];
    callout.delegate = self;
    [callout show];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    if (index == 0) {
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                //MultiLineTextViewController *multiLineTextVC = [[MultiLineTextViewController alloc] init];
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//                MultiLineTextViewController *multiLineTextVC = [storyboard instantiateViewControllerWithIdentifier: @"MultiLineTextView"];
//                
//                NSArray *en_US = [NSArray arrayWithObjects:
//                                  [[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"],
//                                  [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"],
//                                  nil];
//                // Certificate
//                //NSData *certificate = [NSData dataWithBytes: myCertificate.bytes length: myCertificate.length];
//                
//                multiLineTextVC.multiLineView = [[MLTWMultiLineView alloc] init];
//                multiLineTextVC.multiLineView.delegate = multiLineTextVC;
//                //[multiLineTextVC.multiLineView configureWithLocale: @"en_US" resources: en_US lexicon: nil certificate: certificate density: 326.0];
//                
//                [self.navigationController pushViewController: multiLineTextVC animated: YES];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                QuestionFeedWallTableViewController *questionFeedWallTVC = [storyboard instantiateViewControllerWithIdentifier: @"QuestionFeed"];
                [self.navigationController pushViewController: questionFeedWallTVC animated: YES];
            }
        }];
    }
    if (index == 1) {
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//                MathNotesViewController *mathVC = [storyboard instantiateViewControllerWithIdentifier: @"MathVC"];
                MathNotesViewController *mathVC = [[MathNotesViewController alloc] init];
                mathVC.delegate = mathVC;
                [mathVC configureWithResources:@[@"math-ak.res", @"math-grm-maw.res"] certificate:[NSData dataWithBytes: myCertificate.bytes length: myCertificate.length]];
                [self.navigationController pushViewController: mathVC animated:YES];
                NSLog(@"math view should appear");
            }
        }];

    }
    
    if (index == 2) {
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//                SingleTextViewController *singleTextVC = [storyboard instantiateViewControllerWithIdentifier: @"TextVC"];
                SingleTextViewController *singleTextVC = [[SingleTextViewController alloc] init];
                singleTextVC.textWidget.delegate = singleTextVC;
                //Recognition resources
                NSArray *en_US = [NSArray arrayWithObjects:
                                  [[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"],
                                  [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"],
                                  nil];
                
                // Certificate
                NSData *certificate = [NSData dataWithBytes: myCertificate.bytes length: myCertificate.length];
                singleTextVC.textWidget = [[SLTWTextWidget alloc] init];
                singleTextVC.textWidget.delegate = singleTextVC;
                
                [singleTextVC.textWidget configureWithLocale: @"en_US" resources: en_US lexicon: NULL certificate: certificate];
                
                [self.navigationController pushViewController: singleTextVC animated: YES];
                NSLog(@"SINGLE LINE SHOULD APPEAR!");
            }
        }];
    }
    if (index == 3) {
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                SpeechEngineViewController *speechEngineVC = [storyboard instantiateViewControllerWithIdentifier: @"SpeechEngineVC"];
                [self.navigationController pushViewController: speechEngineVC animated: YES];
            }
        }];
    }
}

- (IBAction)mathCipherButton:(id)sender {
    MathNotesViewController *mathVC = [[MathNotesViewController alloc] init];
    mathVC.delegate = mathVC;
    mathVC.inkColor = [[UIColor alloc] initWithRed:.2 green: .6 blue: 1 alpha: 1];
    mathVC.textColor = [[UIColor alloc] initWithRed:.2 green: .6 blue: 1 alpha: 1];
    [mathVC configureWithResources:@[@"math-ak.res", @"math-grm-maw.res"] certificate:[NSData dataWithBytes: myCertificate.bytes length: myCertificate.length]];
    [self.navigationController pushViewController: mathVC animated:YES];
    NSLog(@"math view should appear");
}

- (IBAction)textCipherButton:(id)sender {
    SingleTextViewController *singleTextVC = [[SingleTextViewController alloc] init];
    singleTextVC.textWidget.delegate = singleTextVC;
    
    NSArray *en_US = [NSArray arrayWithObjects:
                      [[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"],
                      [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"],
                      nil];
    
    // Certificate
    NSData *certificate = [NSData dataWithBytes: myCertificate.bytes length: myCertificate.length];
    singleTextVC.textWidget = [[SLTWTextWidget alloc] init];
    singleTextVC.textWidget.delegate = singleTextVC;
    [singleTextVC.textWidget setWidgetHeight: 500.0];
    
    [singleTextVC.textWidget configureWithLocale: @"en_US" resources: en_US lexicon: NULL certificate: certificate];
    
    [self.navigationController pushViewController: singleTextVC animated: YES];
    NSLog(@"SINGLE LINE SHOULD APPEAR!");
}

- (IBAction)speechCipherButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    SpeechEngineViewController *speechEngineVC = [storyboard instantiateViewControllerWithIdentifier: @"SpeechEngineVC"];
    [self.navigationController pushViewController: speechEngineVC animated: YES];
}

- (IBAction)askQuestionButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    QuestionFeedWallTableViewController *questionFeedWallTVC = [storyboard instantiateViewControllerWithIdentifier: @"QuestionFeed"];
    [self.navigationController pushViewController: questionFeedWallTVC animated: YES];
}

- (IBAction)picCipherButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    PicCipherViewController *picCipherVC = [storyboard instantiateViewControllerWithIdentifier: @"PicCipher"];
    [self.navigationController pushViewController: picCipherVC animated: YES];
}



@end
