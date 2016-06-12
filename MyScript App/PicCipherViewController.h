//
//  PicCipherViewController.h
//  MyScript App
//
//  Created by Nishanth Salinamakki on 6/11/16.
//  Copyright © 2016 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CloudSightConnection.h"
#import "CloudSightQuery.h"
#import "CloudSightImageRequestDelegate.h"
#import "CloudSightQueryDelegate.h"
#import "XMLReader.h"
#import "TAOverlay.h"
#import "GoogleWebViewController.h"
#import "BALoadingView.h"

@interface PicCipherViewController : UIViewController <CloudSightImageRequestDelegate, CloudSightQueryDelegate, UIWebViewDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) CloudSightQuery *query;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *imageName;

@property (strong, nonatomic) GoogleWebViewController *googleWebViewController;

@property (strong, nonatomic) NSString *globalRequestURL;
@property (strong, nonatomic) NSMutableArray *podIDInformation;
@property (strong, nonatomic) NSMutableArray *podLinkInformation;

@property (strong, nonatomic) UIImageView *popup;
@property (strong, nonatomic) BALoadingView *loadingView;
@property (strong, nonatomic) UILabel *loadLabel;

@end
