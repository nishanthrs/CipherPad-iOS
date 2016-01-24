//
//  AppDelegate.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 8/18/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "AppDelegate.h"
#import "MathNotesViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate

- (void) setupSpeechKitConnection {
    [SpeechKit setupWithID: @"NMDPTRIAL_nishanthrs20150211171443"
                      host: @"sandbox.nmdp.nuancemobility.net"
                      port: 443
                    useSSL: NO
                  delegate: nil];
    
    SKEarcon *earconStart = [SKEarcon earconWithName: @"earcon_listening.wav"];
    SKEarcon *earconStop = [SKEarcon earconWithName: @"earcon_done_listening.wav"];
    SKEarcon *earconCancel = [SKEarcon earconWithName: @"earcon_cancel.wav"];
    
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    MathNotesViewController *mathNotesVC = [[MathNotesViewController alloc] init];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController: mathNotesVC];
//    self.window.rootViewController = self.navigationController;
//    [self.window makeKeyAndVisible];
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"8RCBq2LE7rh1jtbAfpU1CYnwp9uoxiAR8JOftIxK"
                  clientKey:@"QWyL96CMksDlEzP0iU82wzDbCGDn667roLWStpfe"];
    
    PFObject *testObject = [PFObject objectWithClassName: @"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Notification Configuration
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
