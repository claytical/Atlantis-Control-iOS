//
//  AppDelegate.h
//  Atlantis Control
//
//  Created by Clay Ewing on 9/24/15.
//  Copyright (c) 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F53OSC.h"
#import "NERDLabServer.h"
#import "NERDLabClient.h"
#import <CoreMotion/CoreMotion.h>

@class NERDLabServer;

@interface AppDelegate : UIResponder <UIApplicationDelegate,  NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    NSMutableArray *serverList;
    CMMotionManager *motionManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong) NERDLabServer* server;
@property (strong) NERDLabClient* client;
@property (strong, atomic) NSString *player_name;
@property (readonly) CMMotionManager *motionManager;

//-(void) doSomething;
-(void) setClientHost: (NSString *) host;

@end

