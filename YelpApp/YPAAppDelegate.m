//
//  YPAAppDelegate.m
//  YelpApp
//
//  Created by Savitha Reddy on 8/26/14.
//  Copyright (c) 2014 Savitha. All rights reserved.
//

#import "YPAAppDelegate.h"
#import "YPAMainVC.h"
#import <SpeechKit/SpeechKit.h>
#import  <AVFoundation/AVFoundation.h>
#import "YPATableCustomVC.h"


@implementation YPAAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    YPAMainVC *mainVC = [[YPAMainVC alloc] init];
//    YPATableCustomVC *tableVC = [[YPATableCustomVC alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) setupSpeechKitConnection
{
[SpeechKit setupWithID:@"NMDPTRIAL_reddysavi20140824102558"
                  host:@"sandbox.nmdp.nuancemobility.net"
                  port:443
                useSSL:NO
              delegate:nil];
    
    SKEarcon *earconStart = [SKEarcon earconWithName:@"earcon_listening.wav"];
    SKEarcon *earconStop = [SKEarcon earconWithName:@"earcon_done_listening.wav"];
    SKEarcon *earconCancel = [SKEarcon earconWithName:@"earcon_cancel.wav"];
    
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
}




























- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
