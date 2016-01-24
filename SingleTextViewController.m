//
//  SingleTextViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 10/25/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "SingleTextViewController.h"
#import "XMLReader.h"
#import "MenuTableViewController.h"

@interface SingleTextViewController ()

@property (strong, nonatomic) NSMutableArray *arrayOfInformation;
@property (strong, nonatomic) MenuTableViewController *menuTableViewController;

@end

@implementation SingleTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed: 0 green: .8 blue: .4 alpha: 1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview: _textWidget.view];
    
    if (_textWidget) {
        NSLog(@"TEXT WIDGET NOT NULL!");
    }
    else {
        NSLog(@"TEXT WIDGET NULL!!!");
    }
    
    NSArray *en_US = @[[[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"], [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"]];
    
    //                NSArray *en_US = [NSArray arrayWithObjects:
    //                                  [[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"],
    //                                  [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"],
    //                                  nil];
    
    // Certificate
    //NSData *certificate = [NSData dataWithBytes: certificate.bytes length: certificate.length];
    
    //[_textWidget configureWithLocale: @"en_US" resources: en_US lexicon: NULL certificate: certificate];
    
    _btItemExport = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MLTW_Export"] style:UIBarButtonItemStylePlain target:self action: nil];
    UIBarButtonItem *btItemRemove   = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_trash"] style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    UIBarButtonItem *wolframAlphaIcon = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"wolframalpha_logo"] style:UIBarButtonItemStyleDone target: self action: @selector(wolframQuery)];
    
    [self.navigationItem setRightBarButtonItems:@[_btItemExport, btItemRemove, wolframAlphaIcon]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 500, 320, 30)];
    [self.view addSubview: textField];
    
}

#pragma mark - Delegate Methods 

- (void)textWidget:(SLTWTextWidget *)sender didSelectWordInRange:(NSRange)range labels:(NSArray *)labels selectedIndex:(NSUInteger)selectedIndex
{
    NSLog(@"textWidget:didSelectWordInRange:labels:selectedIndex: (range=%d-%d, selectedIndex=%d)",
          (int) range.location,
          (int) range.location + (int) range.length,
          (int) selectedIndex);
    
}

- (void)textWidgetDidBeginRecognition:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidBeginRecognition");
}

- (void)textWidgetDidEndRecognition:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidEndRecognition");
}

- (void)textWidgetDidBeginConfiguration:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidBeginConfiguration");
}

- (void)textWidgetDidEndConfiguration:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidEndConfiguration");
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectSingleTapAtIndex:(NSUInteger)index
{
    NSLog(@"Single tap gesture detected at index %d", (int) index);
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectJoinGestureAtIndex:(NSUInteger)index
{
    NSLog(@"Join gesture detected at index %d", (int) index);
    // compute range of spaces to remove
    NSString *text = _textWidget.text;
    NSUInteger left;
    NSUInteger right;
    for (left=index; left>0; left--) {
        if ([text characterAtIndex:left-1] != ' ') {
            break;
        }
    }
    for (right=index; right<text.length; right++) {
        if ([text characterAtIndex:right] != ' ') {
            break;
        }
    }
    
    [_textWidget replaceCharactersInRange:NSMakeRange(left, right-left) replacementString:@""];
    
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectInsertGestureAtIndex:(NSUInteger)index
{
    NSLog(@"Insert gesture detected at index %d", (int) index);
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectReturnGestureAtIndex:(NSUInteger)index
{
    NSLog(@"Return gesture detected at index %d", (int) index);
    
}

- (void) textWidget:(SLTWTextWidget *)sender didUpdateText:(NSString *)text intermediate:(BOOL)intermediate {
    NSLog(@"TEXT: %@", text);
    NSLog(@"%@", [_textWidget text]);
}

- (void) clear {
    [_textWidget clear];
}

- (void) wolframQuery {
    NSString *text = [_textWidget text];
    //NSString *text = @"dopplereffect";
    NSLog(@"TEXT ON SCREEN: %@", text);
    NSString *encodedText = [text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //Wolfram App ID is: LTW5PH-XA766A928W
    NSString *requestWolframAPIURL = [@"http://api.wolframalpha.com/v2/query?appid=LTW5PH-XA766A928W&input=" stringByAppendingString: encodedText];
    requestWolframAPIURL = [requestWolframAPIURL stringByAppendingString: @"&format=image,plaintext"];
    
    self.globalRequestURL = [@"http://www.wolframalpha.com/input/?i=" stringByAppendingString: text];
    NSString *requestURL = [@"http://www.wolframalpha.com/input/?i=" stringByAppendingString: text];
    //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: requestURL]];
    
    [TAOverlay showOverlayWithLabel: @"Ciphering..." Options: TAOverlayOptionOverlayTypeActivitySquare | TAOverlayOptionOverlaySizeRoundedRect];
    [TAOverlay setOverlayLabelTextColor: [[UIColor alloc] initWithRed: 172.0/255.0 green: 102.0/255.0 blue: 1.0 alpha: 1.0]];
    
    NSURL *wolframURL = [NSURL URLWithString: requestWolframAPIURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: wolframURL];
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"THE DATA RETURNED IS: %@", data);
        NSString* dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSLog(@"THE DATA IN STRING FORMAT IS: %@", dataString);
        NSError *error = nil;
        NSDictionary *xmlDoc = [XMLReader dictionaryForXMLData: data error: &error];
        NSLog(@"COMPLETE PARSED JSON FILE: %@", xmlDoc);
//        NSLog(@"THE JSON FILE: %@", xmlDoc[@"queryresult"][@"assumptions"][@"assumption"][0][@"value"][0][@"desc"]);
        int numberOfPods = [xmlDoc[@"queryresult"][@"numpods"] intValue];
        NSLog(@"NUMBER OF PODS RETURNED: %@", xmlDoc[@"queryresult"][@"numpods"]);
        NSLog(@"PODS ERROR STATUS: %@", xmlDoc[@"queryresult"][@"pod"][0][@"error"]);
        self.podIDInformation = [[NSMutableArray alloc] init];
        self.podLinkInformation = [[NSMutableArray alloc] init];
        NSLog(@"NUMBER OF SUBPODS: %@", xmlDoc[@"queryresult"][@"pod"][0][@"numsubpods"]);
        NSLog(@"SUBPOD VALUE OF FIRST POD: %@", xmlDoc[@"queryresult"][@"pod"][0][@"subpod"][@"img"][@"src"]);
        if (numberOfPods > 0) {
            for (int i = 0; i < numberOfPods; i++) {
                if ([xmlDoc[@"queryresult"][@"pod"][i][@"error"] isEqualToString: @"false"]) {
                    NSLog(@"PODS ID: %@", xmlDoc[@"queryresult"][@"pod"][i][@"id"]);
                    [self.podIDInformation addObject: xmlDoc[@"queryresult"][@"pod"][i][@"id"]];
                    NSString *subPodNumber = xmlDoc[@"queryresult"][@"pod"][i][@"numsubpods"];
                    int numSubPods = [subPodNumber intValue];
                    if (numSubPods > 1) {
                        NSLog(@"PODS: %@", xmlDoc[@"queryresult"][@"pod"][i][@"subpod"][0][@"img"][@"src"]);
                        [self.podLinkInformation addObject: xmlDoc[@"queryresult"][@"pod"][i][@"subpod"][0][@"img"][@"src"]];
                    }
                    else {
                        NSLog(@"PODS: %@", xmlDoc[@"queryresult"][@"pod"][i][@"subpod"][@"img"][@"src"]);
                        [self.podLinkInformation addObject: xmlDoc[@"queryresult"][@"pod"][i][@"subpod"][@"img"][@"src"]];
                    }
                }
                else {
                    NSLog(@"NUMBER OF PODS: %@", xmlDoc[@"queryresult"][@"numpods"]);
                    [TAOverlay showOverlayWithLabel: @"Sorry, there was an error in computation!" Options: TAOverlayOptionOverlayTypeError | TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect];
                }
            }
        }
        else {
            
        }
        
        NSLog(@"POD ID ARRAY IN SEVC: %@", self.podIDInformation);
        NSLog(@"PODS ARRAY IN SEVC: %@", self.podLinkInformation);
        
        if (numberOfPods > 0) {
            //Popup view controller setup
            self.wolframTableViewController = [[WolframTableViewController alloc] initWithStyle: UITableViewStylePlain];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.wolframTableViewController];
            [self presentViewController: nav animated: YES completion:^{
                [TAOverlay hideOverlay];
            }];
            
            self.wolframTableViewController.cellBackgroundColor = [[UIColor alloc] initWithRed: 0 green: .8 blue: .4 alpha: 1];
            
            //Introspection Code - Passing Data
            self.wolframTableViewController.podIDArray = self.podIDInformation;
            self.wolframTableViewController.podImagesLinkArray = self.podLinkInformation;
            
            NSLog(@"POD ID ARRAY IN MNVC FOR TVC PROPERTY FOR POD ID: %@", self.wolframTableViewController.podIDArray);
            NSLog(@"POD ID ARRAY IN MNVC FOR TVC PROPERTY FOR POD IMAGES: %@", self.wolframTableViewController.podImagesLinkArray);
        }
        else {
            NSLog(@"ZERO PODS!");
            [TAOverlay showOverlayWithLabel: @"Sorry, no info on that!" Options: TAOverlayOptionOverlayTypeError | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAutoHide];
        }
    }];
}

- (void) visitWolfram {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: self.globalRequestURL]];
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
