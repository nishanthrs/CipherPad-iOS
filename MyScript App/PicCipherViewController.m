//
//  PicCipherViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 6/11/16.
//  Copyright © 2016 Nishanth Salinamakki. All rights reserved.
//

#import "PicCipherViewController.h"

@interface PicCipherViewController ()

@end

@implementation PicCipherViewController

//Constants to set size of image after information load
#define dWidth self.view.frame.size.width
#define dHeight self.view.frame.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CloudSightConnection sharedInstance].consumerKey = @"ytQ78EZnXq-Lr5NJWX-FDg";
    [CloudSightConnection sharedInstance].consumerSecret = @"JZpiI06Txz4HeCiJb2F4wg";
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight)];
    [self.webView setDelegate:self];
    
    float margin = 0;
    self.popup = [[UIImageView alloc] initWithFrame:CGRectMake(0, dHeight/2, dWidth, dHeight/2)];
    //self.popup = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight/2)];
    self.popup.image = [UIImage imageNamed:@"kenko-gradient.png"];
    self.popup.layer.opacity = 0.75;
    float loadsize = 100;
    float sidem = 0;
    self.loadingView = [[BALoadingView alloc] initWithFrame: CGRectMake(dWidth/2 - (loadsize/4), dHeight/2 - (loadsize*2), loadsize/2, loadsize/2)];
    self.loadingView.segmentColor = [UIColor whiteColor];
    self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(dWidth/2 - (loadsize/4), (dHeight/2 + loadsize*2) + 30, (dWidth-sidem*2), 30)];
    self.loadLabel.text = @"Processing Image";
    self.loadLabel.textColor = [UIColor whiteColor];
    self.loadLabel.font = [UIFont fontWithName:@"Avenir Next" size:20.0f];
    self.loadLabel.textAlignment = NSTextAlignmentCenter;
}

- (void) viewDidAppear:(BOOL)animated {
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset: AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: device error: &error];
    if ([self.session canAddInput: input]) {
        [self.session addInput: input];
    }
    
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.session];
    [newCaptureVideoPreviewLayer setVideoGravity: AVLayerVideoGravityResizeAspectFill];
    newCaptureVideoPreviewLayer.frame = CGRectMake(0, 0, dWidth, dHeight);
    [self.view.layer addSublayer: newCaptureVideoPreviewLayer];
    [self.session startRunning];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings: outputSettings];
    [self.session addOutput: self.stillImageOutput];
    
    UIButton *closeCameraViewButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 25, 25)];
    [closeCameraViewButton setImage:[UIImage imageNamed: @"ExitButton.png"] forState: UIControlStateNormal];
    [self.view addSubview: closeCameraViewButton];
    [closeCameraViewButton addTarget: self action: @selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame: CGRectMake(125, 480, 80, 80)];
    [cameraButton setImage: [UIImage imageNamed: @"CameraButton"] forState: UIControlStateNormal];
    [self.view addSubview: cameraButton];
    [cameraButton addTarget: self action: @selector(processImageData) forControlEvents: UIControlEventTouchUpInside];
}

- (void) close {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) processImageData {
    NSLog(@"IMAGE PROCESSED!");
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual: AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection: videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != nil) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation: imageDataSampleBuffer];
            //NSLog(@"IMAGE DATA: %@", imageData);
            [self searchImage: imageData];
        }
    }];
}

- (void) searchImage: (NSData *) imageData {
    UIImage *sampleImage = [UIImage imageNamed: @"BackButton.png"];
    NSData *sampleImageData = UIImageJPEGRepresentation(sampleImage, 0.6);
    CGPoint focalPoint = CGPointZero;
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude: [@"37.3688" floatValue] longitude: [@"-122.0363" floatValue]];
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.query = [[CloudSightQuery alloc] initWithImage: imageData
                                             atLocation: focalPoint
                                           withDelegate: self
                                            atPlacemark: userLocation
                                           withDeviceId: deviceIdentifier];
    // Start the query process
    [self.query start];
    //Loading view
    
    [self.view addSubview: self.popup];
    [self.loadingView initialize];
    [self.loadingView startAnimation:BACircleAnimationFullCircle];
    [self.popup addSubview: self.loadingView];
    [self.popup addSubview: self.loadLabel];
    
}

#pragma mark CloudSightQueryDelegate

- (void) cloudSightQueryDidFinishUploading:(CloudSightQuery *)query {
    NSLog(@"FINISHED UPLOADING!");
}

- (void)cloudSightQueryDidFinishIdentifying:(CloudSightQuery *)query {
    if (query.skipReason != nil) {
        NSLog(@"Skipped: %@", query.skipReason);
    } else {
        NSLog(@"Identified: %@", query.title);
        self.imageName = query.title;
        NSLog(@"IMAGE: %@", self.imageName);
        [self googleQuery: self.imageName];
    }
}

- (void)cloudSightQueryDidFail:(CloudSightQuery *)query withError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void) cloudSightQueryDidUpdateTag:(CloudSightQuery *)query {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CloudVision API Delegate Methods

- (void) cloudSightRequest:(CloudSightImageRequest *)sender didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"ERROR DESCRIPTION: %@", error.description);
    }
}

- (void) cloudSightRequest:(CloudSightImageRequest *)sender didReceiveToken:(NSString *)token withRemoteURL:(NSString *)url {
    
}

- (void) googleQuery: (NSString *) text {
    
    NSString *encodedText = [text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", encodedText];
    NSLog(@"URL ADDRESS: %@", urlAddress);
    NSURL *url = [NSURL URLWithString: urlAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    //[self.view addSubview: self.webView];
    self.googleWebViewController = [[GoogleWebViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.googleWebViewController];
    [self.googleWebViewController.view addSubview: self.webView];
    [self presentViewController: nav animated: YES completion:^{
        self.googleWebViewController.webView = self.webView;
    }];

}

# pragma mark - Web View Delegate 

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page is loading");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"ERROR LOADING WEBPAGE: %@", error);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished loading");
}

/*
#pragma mark - Wolfram Query

- (void) wolframQuery: (NSString *) text {
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
            NSLog(@"RECURSIVE FUNCTION BEGIN!");
            if (xmlDoc[@"queryresult"][@"didyoumeans"][@"didyoumean"]) {
                NSString *alternateInput = xmlDoc[@"queryresult"][@"didyoumeans"][@"didyoumean"][0][@"text"];
                NSLog(@"ALTERNATE INPUT: %@", alternateInput);
                //[self wolframQuery: alternateInput];
            }
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
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
