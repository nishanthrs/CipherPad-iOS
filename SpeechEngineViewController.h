//
//  SpeechEngineViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/2/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/Speechkit.h>
#import "AppDelegate.h"
#import "XMLReader.h"
#import "TAOverlay.h"
#import "WYPopoverController.h"
#import "WolframTableViewController.h"

@interface SpeechEngineViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate, SKVocalizerDelegate, WYPopoverControllerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) SKRecognizer *voiceSearch;
@property (strong, nonatomic) IBOutlet UIButton *listenButton;
@property (strong, nonatomic) IBOutlet UIButton *listeningButton;

@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) WolframTableViewController *wolframTableViewController;

@property (strong, nonatomic) NSMutableArray *podIDInformation;
@property (strong, nonatomic) NSMutableArray *podLinkInformation;

@property (strong, nonatomic) IBOutlet UILabel *spokenTextLabel;

- (IBAction)listenButton:(UIButton *)sender;
- (IBAction)listeningButton:(id)sender;

@end
