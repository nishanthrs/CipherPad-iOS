//
//  SpeechEngineViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/2/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "SpeechEngineViewController.h"

@interface SpeechEngineViewController ()

@end

const unsigned char SpeechKitApplicationKey[] = {0x2a, 0x7c, 0xf5, 0xaf, 0x3f, 0x85, 0x1a, 0x93, 0x5c, 0x0f, 0x60, 0xc1, 0x35, 0x19, 0xf2, 0x82, 0x85, 0x97, 0x67, 0x28, 0x68, 0xab, 0x16, 0x40, 0x3a, 0x27, 0x7d, 0x62, 0xb0, 0x90, 0x89, 0xda, 0x0c, 0x7e, 0x89, 0x4c, 0x03, 0xa3, 0xdf, 0x60, 0xb2, 0x3f, 0x21, 0xe7, 0x59, 0x13, 0x6a, 0xde, 0xab, 0xd1, 0x06, 0x13, 0x7d, 0x1d, 0x53, 0xb7, 0x44, 0xd0, 0x19, 0xf4, 0x60, 0xa2, 0xce, 0x6d};

@implementation SpeechEngineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [self.appDelegate setupSpeechKitConnection];
    
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed: 1.0 green: 0.15 blue: .35 alpha: 1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Speech Pad";
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

- (IBAction)listeningButton:(id)sender {
    self.listeningButton.selected = !self.listeningButton.selected;
    
    NSLog(@"SPEECH BUTTON PRESSED!");
    if (self.listeningButton.isSelected) {
        self.voiceSearch = [[SKRecognizer alloc] initWithType: SKSearchRecognizerType detection: SKShortEndOfSpeechDetection language: @"en_US" delegate: self];
    }
    else {
        if (self.voiceSearch) {
            [self.voiceSearch stopRecording];
            [self.voiceSearch cancel];
        }
    }
}

#pragma mark - Voice-Activated Methods

- (void) recognizerDidBeginRecording:(SKRecognizer *)recognizer {
    
}

- (void) recognizerDidFinishRecording:(SKRecognizer *)recognizer {
    
}

- (void) recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion {
    NSLog(@"ERROR: %@", error);
}

- (void) recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results {
    NSString *speechRecorded = results.results[0];
    self.spokenTextLabel.text = speechRecorded;
    [self wolframQuery: speechRecorded.lowercaseString];
}

#pragma mark - Wolfram Query

- (void) wolframQuery: (NSString *) text {
    SKVocalizer *voiceSynthesizer = [[SKVocalizer alloc] initWithLanguage: @"en_US" delegate: self];
    NSLog(@"TEXT ON SCREEN: %@", text);
    //Wolfram App ID is: LTW5PH-XA766A928W
    NSString *encodedText = [text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *requestWolframAPIURL = [@"http://api.wolframalpha.com/v2/query?appid=LTW5PH-XA766A928W&input=" stringByAppendingString: encodedText];
    //requestWolframAPIURL = [requestWolframAPIURL stringByAppendingString: @"&format=image,plaintext"];
    
    [TAOverlay showOverlayWithLabel: @"Ciphering..." Options: TAOverlayOptionOverlayTypeActivitySquare | TAOverlayOptionOverlaySizeRoundedRect];
    [TAOverlay setOverlayLabelTextColor: [[UIColor alloc] initWithRed: 172.0/255.0 green: 102.0/255.0 blue: 1.0 alpha: 1.0]];
    [voiceSynthesizer speakString: @"Ciphering"];
    
    NSURL *wolframURL = [NSURL URLWithString: requestWolframAPIURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: wolframURL];
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"THE DATA RETURNED IS: %@", data);
        NSError *error = nil;
        NSDictionary *xmlDoc = [XMLReader dictionaryForXMLData: data error: &error];
        NSLog(@"COMPLETE PARSED JSON FILE: %@", xmlDoc);
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
                    [voiceSynthesizer speakString: @"Sorry, I couldn't cipher it!"];
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
                [voiceSynthesizer speakString: @"Here's what I found!"];
            }];
            
            self.wolframTableViewController.cellBackgroundColor = [[UIColor alloc] initWithRed: 1 green: 0.15 blue: .35 alpha: 1];
            
            //Introspection Code - Passing Data
            self.wolframTableViewController.podIDArray = self.podIDInformation;
            self.wolframTableViewController.podImagesLinkArray = self.podLinkInformation;
            
            NSLog(@"POD ID ARRAY IN MNVC FOR TVC PROPERTY FOR POD ID: %@", self.wolframTableViewController.podIDArray);
            NSLog(@"POD ID ARRAY IN MNVC FOR TVC PROPERTY FOR POD IMAGES: %@", self.wolframTableViewController.podImagesLinkArray);
        }
        else {
            NSLog(@"ZERO PODS!");
            [voiceSynthesizer speakString: @"Sorry, that's not in my database!"];
            [TAOverlay showOverlayWithLabel: @"Sorry, no info on that!" Options: TAOverlayOptionOverlayTypeError | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAutoHide];
            self.spokenTextLabel.text = @"";
        }
        
    }];
}

@end
