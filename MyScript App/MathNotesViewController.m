//
//  MathNotesViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 8/20/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "MathNotesViewController.h"
//#import "com.parsePush.MyScriptApp.h"
#import "TextNotesViewController.h"
#import "MenuTableViewController.h"
#import "XMLReader.h"

@interface MathNotesViewController ()

@property (strong, nonatomic) UIBarButtonItem *wolframAlphaExportBarButton;
@property (strong, nonatomic) UIBarButtonItem *saveNotesButton;
@property (strong, nonatomic) UIBarButtonItem *clearButton;
@property (strong, nonatomic) NSMutableArray *arrayOfInformation;

@property (strong, nonatomic) MenuTableViewController *menuTableViewController;
@property (strong, nonatomic) WYPopoverController *popoverController;

@property (strong, nonatomic) NSData *serializedData;

@end

@implementation MathNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:.2 green: .6 blue: 1 alpha: 1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.clearButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"glyphicons_trash"] style:UIBarButtonItemStyleDone target: self action: @selector(clearWrittenData)];
    
    self.saveNotesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target: self action: @selector(exportToImage)];
    self.saveNotesButton.enabled = NO;
    
    UIButton *wolframAlphaExport = [[UIButton alloc] initWithFrame: CGRectMake(250, 500, 50, 50)];
    [wolframAlphaExport setImage: [UIImage imageNamed: @"wolframalpha-logo"] forState: UIControlStateNormal];
    [wolframAlphaExport addTarget: self action: @selector(unserializeWrittenData) forControlEvents: UIControlEventTouchUpInside];
    
    self.wolframAlphaExportBarButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"wolframalpha_logo"] style: UIBarButtonItemStyleDone target: self action: @selector(presentExportViewController)];
    self.wolframAlphaExportBarButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItems = @[self.clearButton, self.saveNotesButton, self.wolframAlphaExportBarButton];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(presentExportViewController)];
    [swipeRecognizer setDirection: UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer: swipeRecognizer];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.undoButton = [[UIButton alloc] initWithFrame: CGRectMake(220, 100, 25, 25)];
    //[self.undoButton setTitleColor: [UIColor purpleColor] forState: UIControlStateNormal];
    [self.undoButton setImage: [UIImage imageNamed: @"glyphicons_undo"] forState: UIControlStateNormal];
    [self.undoButton setTintColor: [UIColor whiteColor]];
    [self.undoButton setShowsTouchWhenHighlighted: YES];
    [self.undoButton addTarget: self action: @selector(undo) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: self.undoButton];
    
    self.redoButton = [[UIButton alloc] initWithFrame: CGRectMake(270, 100, 25, 25)];
    //[self.redoButton setTitleColor: [UIColor purpleColor] forState: UIControlStateNormal];
    [self.redoButton setImage: [UIImage imageNamed: @"glyphicons_redo"] forState: UIControlStateNormal];
    [self.redoButton setTintColor: [UIColor whiteColor]];
    [self.redoButton setShowsTouchWhenHighlighted: YES];
    [self.redoButton addTarget: self action: @selector(redo) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: self.redoButton];
}

- (NSString *) encodeToPercentEscapeStringForWolframAlphaQuery:(NSString *) string {
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) string, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
}

#pragma mark - Clear

- (void) clearWrittenData {
    [self clear];
    [self.view addSubview: _textWidget.view];
    if (_textWidget) {
        NSLog(@"TEXT WIDGET NOT NULL!");
    }
    else {
        NSLog(@"TEXT WIDGET NULL!!!");
    }
    
    NSArray *en_US = @[[[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"], [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 500, 320, 30)];
    [self.view addSubview: textField];
}

-(void) myUndo {
    [self undo];
}

#pragma mark - Save data and serialize
- (void) unserializeWrittenData {
    [self unserialize: self.serializedData allowUndo: YES];
}

#pragma mark - Export Functions

- (void) presentExportViewController {
    //TAOverlay
    [TAOverlay showOverlayWithLabel: @"Ciphering..." Options: TAOverlayOptionOverlayTypeActivityLeaf | TAOverlayOptionOverlaySizeRoundedRect];
    [TAOverlay setOverlayLabelFont: [UIFont fontWithName: @"Avenir Next" size: 12.0]];
    [TAOverlay setOverlayLabelTextColor: [[UIColor alloc] initWithRed:.2 green: .6 blue: 1 alpha: 1]];
    
    NSString *latexString = [self resultAsLaTeX];
    NSLog(@"LATEX STRING: %@", latexString);
    NSString *mathmlString = [self resultAsMathML];
    NSLog(@"MATHML STRING: %@", mathmlString);
    
    NSString *encodedString = [self encodeToPercentEscapeStringForWolframAlphaQuery: mathmlString];
    NSString *encodedMathMLString = [mathmlString stringByAddingPercentEscapesUsingEncoding: kCFStringEncodingUTF8];
    NSLog(@"ENCODED MATHML STRING: %@", encodedMathMLString);
    
    NSString *secondEncodedString = [self encodeToPercentEscapeStringForWolframAlphaQuery: latexString];
    NSString *secondEncodedLaTeXString = [latexString stringByAddingPercentEscapesUsingEncoding: kCFStringEncodingUTF8];
    NSLog(@"ENCODED LATEX STRING: %@", secondEncodedLaTeXString);
    
    //Old code (w/o API)
    NSString *requestURL = [@"http://www.wolframalpha.com/input/?i=" stringByAppendingString: encodedString];
    NSLog(@"REQUEST URL: %@", requestURL);
    NSString *requestWolframURL = [@"wolframalpha://m.wolframalpha.com/input/?i=" stringByAppendingString: encodedString];
    
    //New URL (appended)
//    NSString *requestWolframAPIURL = [@"http://api.wolframalpha.com/v2/query?appid=LTW5PH-XA766A928W&input=" stringByAppendingString: encodedMathMLString];
//    requestWolframAPIURL = [requestWolframAPIURL stringByAppendingString: @"&format=image,plaintext"];
    NSString *requestWolframAPIURL = [@"http://api.wolframalpha.com/v2/query?appid=LTW5PH-XA766A928W&input=" stringByAppendingString: secondEncodedString]; //For LaTeX string
    NSString *requestWolframAPIURL2 = [@"http://api.wolframalpha.com/v2/query?appid=LTW5PH-XA766A928W&input=" stringByAppendingString: encodedString]; //For MathML string
    requestWolframAPIURL = [requestWolframAPIURL stringByAppendingString: @"&format=image,plaintext"];
    NSString *podStateBaseURL = [requestWolframAPIURL stringByAppendingString: @"&podstate="];
    
    NSLog(@"REQUEST WOLFRAM API URL: %@", requestWolframAPIURL);
    self.globalRequestURL = requestURL;
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: requestWolframURL]]) {
        //Opening in Wolfram Alpha app
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: requestWolframURL]];
    }
    else {
        //Opening Safari app
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: requestURL]];
    }
    
    NSURL *wolframURL = [NSURL URLWithString: requestWolframAPIURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: wolframURL];
    NSURL *wolframMathMLURL = [NSURL URLWithString: requestWolframAPIURL2];
    NSURLRequest *mathMLRequest = [NSURLRequest requestWithURL: wolframMathMLURL];
    //Add case over here that checks for second encoded URL request (MathML) as well
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString* dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSLog(@"THE DATA IN XML FORMAT IS: %@", dataString);
        NSError *error = nil;
        NSDictionary *xmlDoc = [XMLReader dictionaryForXMLData: data error: &error];
        NSLog(@"COMPLETE PARSED JSON FILE: %@", xmlDoc);
        int numberOfPods = [xmlDoc[@"queryresult"][@"numpods"] intValue];
        NSLog(@"NUMBER OF PODS RETURNED: %@", xmlDoc[@"queryresult"][@"numpods"]);
        //NSLog(@"PODS ERROR STATUS: %@", xmlDoc[@"queryresult"][@"pod"][0][@"error"]);
        self.podIDInformation = [[NSMutableArray alloc] init];
        self.podLinkInformation = [[NSMutableArray alloc] init];
        self.podStateNames = [[NSMutableArray alloc] init];
        self.podStateURLs = [[NSMutableArray alloc] init];
        self.podStateImageURLs = [[NSMutableArray alloc] init];
        if (numberOfPods > 0) {
        for (int i = 0; i < numberOfPods; i++) {
            NSLog(@"NUMBER OF PODS: %@", xmlDoc[@"queryresult"][@"numpods"]);
            NSString *errorStatus = @"";
            if ([xmlDoc[@"queryresult"][@"numpods"] intValue] == 1) {
                errorStatus = xmlDoc[@"queryresult"][@"pod"][@"error"];
            }
            else {
                errorStatus = xmlDoc[@"queryresult"][@"pod"][i][@"error"];
            }
            NSLog(@"ERROR STATUS: %@", errorStatus);
            if ([errorStatus isEqualToString: @"false"]) {
                NSLog(@"PODS ID: %@", xmlDoc[@"queryresult"][@"pod"][i][@"id"]);
                [self.podIDInformation addObject: xmlDoc[@"queryresult"][@"pod"][i][@"id"]];
                NSString *subPodNumber = xmlDoc[@"queryresult"][@"pod"][i][@"numsubpods"];
                //POD STATES loop and header retrieval
                if ([xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"count"] intValue] <= 1) {
                    if (xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"input"]) {
                        //NSLog(@"NUMBER OF PODS IN POD STATE: %@", xmlDoc[@"])
                        NSLog(@"POD STATE NAME: %@", xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"name"]);
                        NSLog(@"POD STATE: %@", xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"input"]);
                        if ([xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"input"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]) {
                            //[self.podStateNames addObject: xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"name"]];
                            //[self.podStateURLs addObject: [podStateBaseURL stringByAppendingString: [xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"input"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
                            self.podStateName = xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"name"];
                            self.podStateURL = [podStateBaseURL stringByAppendingString: [xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][@"input"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                            NSLog(@"FIRST CASE");
                        }
                    }
                }
                else {
                    //Add for loop here if you want to cycle through ALL pod states
                    //for (int j = 0; j < [xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"count"] intValue]; j++) {
                        NSLog(@"POD STATE NAME: %@", xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][0][@"name"]);
                        NSLog(@"POD STATE: %@", xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][0][@"input"]);
                        if ([xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][0][@"input"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]) {
                            //[self.podStateNames addObject: xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][0][@"name"]];
                            //[self.podStateURLs addObject: [podStateBaseURL stringByAppendingString: [xmlDoc[@"queryresult"][@"pod"][i][@"states"][@"state"][0][@"input"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
                            //Add @try @catch @finally method here
                            self.podStateName = xmlDoc[@"queryresult"][@"pod"][0][@"states"][@"state"][0][@"name"];
                            self.podStateURL = [podStateBaseURL stringByAppendingString: [xmlDoc[@"queryresult"][@"pod"][0][@"states"][@"state"][0][@"input"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]; //Exception is occuring here (@catch)
                            NSLog(@"SECOND CASE");
                        }
                    //}
                }
                NSLog(@"POD NAME IS (should be step-by-step): %@", self.podStateName);
                NSLog(@"POD STATE URL IS: %@", self.podStateURL);
                int numSubPods = [subPodNumber intValue];
                if (numSubPods > 1) {
                    //Add for loop here if you want to include ALL subpods
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
            NSLog(@"ZERO PODS!!!");
        }
        
        //----------------------------------------------------------------------------------
        //==================================================================================
        //----------------------------------------------------------------------------------
        
        //POD STATE data retrieval
        //if ([self.podStateURLs count] > 0) {
            //for (int i = 0; i < [self.podStateURLs count]; i++) {
        
                NSURLRequest *wolframPodStatesRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: self.podStateURL]];
                NSLog(@"POD STATE URL: %@", self.podStateURL);
                [NSURLConnection sendAsynchronousRequest: wolframPodStatesRequest queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    NSLog(@"DATA IN RAW FORM FROM POD STATES: %@", data);
                    NSError *error = nil;
                    NSDictionary *xmlPodStateDoc = [XMLReader dictionaryForXMLData: data error: &error];
                    NSLog(@"COMPLETELY PARSED JSON FILE FOR POD STATES: %@", xmlPodStateDoc);
//
                    if ([xmlPodStateDoc[@"queryresult"][@"pod"][0][@"numsubpods"] intValue] > 1) {
                        self.podStateImageURL = xmlPodStateDoc[@"queryresult"][@"pod"][0][@"subpod"][1][@"img"][@"src"];
                        NSLog(@"FIRST POD STATE CONDITION");
                    }
                    else {
                        self.podStateImageURL = xmlPodStateDoc[@"queryresult"][@"pod"][0][@"subpod"][@"img"][@"src"];
                        NSLog(@"SECOND POD STATE CONDITION");
                        //[self.podStateImageURLs addObject: xmlPodStateDoc[@"queryresult"][@"pod"][0][@"subpod"][@"img"][@"src"]];
                    }
//
//                    //---------------------------------------------------------------
                    if (numberOfPods > 0) {
                        //Popup view controller setup
                        self.wolframTableViewController = [[WolframTableViewController alloc] initWithStyle: UITableViewStylePlain];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.wolframTableViewController];
                        //Present view controller with data
                        [self presentViewController: nav animated: YES completion:^{
                            [TAOverlay hideOverlay];
                        }];
                        
                        self.wolframTableViewController.cellBackgroundColor = [[UIColor alloc] initWithRed:.2 green: .6 blue: 1 alpha: 1];
                        
                        //Introspection Code - Passing Data
                        self.wolframTableViewController.podIDArray = self.podIDInformation;
                        self.wolframTableViewController.podImagesLinkArray = self.podLinkInformation;
                        
                        self.wolframTableViewController.podStateName = self.podStateName;
                        self.wolframTableViewController.podStateLink = self.podStateURL;
                        self.wolframTableViewController.podStateImageLink = self.podStateImageURL;
                        
                        /*
                        self.wolframTableViewController.podStatesNamesArray = self.podStateNames;
                        self.wolframTableViewController.podStatesLinksArray = self.podStateURLs;
                        self.wolframTableViewController.podStatesImagesLinksArray = self.podStateImageURLs;
                        */
                        
                    }
                    else {
                        NSLog(@"ZERO PODS!");
                        [TAOverlay showOverlayWithLabel: @"Sorry, no info on that!" Options: TAOverlayOptionOverlayTypeError | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAutoHide];
                    }
                    //---------------------------------------------------------------
                    
                }];
        
            //}
        //}
        
        //--------------------------------------------------------------------------------
        //================================================================================
        //--------------------------------------------------------------------------------
        
        NSLog(@"POD ID ARRAY IN MNVC: %@", self.podIDInformation);
        NSLog(@"PODS ARRAY IN MNVC: %@", self.podLinkInformation);
        
        NSLog(@"POD STATE NAME IN MNVC: %@", self.podStateName);
        NSLog(@"POD STATE LINK IN MNVC: %@", self.podStateURL);
        NSLog(@"POD STATE IMAGE URL IN MNVC: %@", self.podStateImageURL);
        
        /*
        NSLog(@"PODS STATE NAME ARRAY IN MNVC: %@", self.podStateNames);
        NSLog(@"PODS STATE LINK ARRAY IN MNVC:  %@", self.podStateURLs);
        NSLog(@"POD STATE IMAGE URLS ARRAY IN MNVC: %@", self.podStateImageURLs);
        */
        
    }];
    
}

- (void) visitWolfram {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: self.globalRequestURL]];
}

- (void) exportToImage {
    UIImage *mathPhotoImage = [self resultAsImage];
    UIImageWriteToSavedPhotosAlbum(mathPhotoImage, nil, nil, nil);
}

- (void) configure {
//    Resources for recognition
//    NSArray *resources = @[@"math-ak.res", @"math-grm-maw.res"];
    
//    Certificates
//    NSData *certificate = [NSData dataWithBytes: myCertificate.bytes length: myCertificate.length];
    
//    [self configureWithResources: resources certificate: certificate];
}

#pragma mark - Math Widget Delegate - Configuration

- (void)mathViewControllerDidBeginConfiguration:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation configuration begin");
}

- (void)mathViewControllerDidEndConfiguration:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation configuration succeeded");
}

- (void)mathViewController:(MAWMathViewController *)mathViewController didFailConfigurationWithError:(NSError *)error
{
    NSLog(@"Equation configuration failed (%@)", error);
}

#pragma mark - Math Widget Delegate - Recognition

- (void)mathViewControllerDidBeginRecognition:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation recognition begin");
}

- (void)mathViewControllerDidEndRecognition:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation recognition end");
    self.wolframAlphaExportBarButton.enabled = YES;
    self.saveNotesButton.enabled = YES;
}

#pragma mark - Math Widget Delegate - Solving

- (void)mathViewController:(MAWMathViewController *)mathViewController didChangeUsingAngleUnit:(BOOL)used
{
    if (used)
    {
        NSLog(@"Angle unit is used");
    }
    else
    {
        NSLog(@"Angle unit is not used");
    }
}

#pragma mark - Math Widget Delegate - Gesture

- (void)mathViewController:(MAWMathViewController *)mathViewController didPerformEraseGesture:(BOOL)partial
{
    NSString *gestureState = partial ? @"partial" : @"complete";
    
    NSLog(@"Erase gesture handled by current equation (%@)", gestureState);
}

#pragma mark - Math Widget Delegate - Undo Redo

- (void)mathViewControllerDidChangeUndoRedoState:(MAWMathViewController *)mathViewController
{
    NSLog(@"Undo Redo state changed");
    self.podStateName = nil;
    self.podStateURL = nil;
    self.podStateImageURL = nil;
}

#pragma mark - Math Widget Delegate - Writing

- (void)mathViewControllerDidBeginWriting:(MAWMathViewController *)mathViewController
{
    NSLog(@"Start writing");
    self.podStateName = nil;
    self.podStateURL = nil;
    self.podStateImageURL = nil;
}

- (void)mathViewControllerDidEndWriting:(MAWMathViewController *)mathViewController
{
    NSLog(@"End writing");
    self.wolframAlphaExportBarButton.enabled = YES;
    self.saveNotesButton.enabled = YES;
}

#pragma - Math Widget Delegate - Recognition Timeout

- (void)mathViewControllerDidReachRecognitionTimeout:(MAWMathViewController *)mathViewController
{
    NSLog(@"Recognition timeout reached");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
