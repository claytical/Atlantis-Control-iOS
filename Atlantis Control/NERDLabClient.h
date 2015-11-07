//
//  NERDLabClient.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F53OSC.h"

@class AppDelegate;

@interface NERDLabClient : NSObject <F53OSCClientDelegate> {
    NSString *current_host;
}

@property (weak) AppDelegate *app;

- (id) initWithPort:(UInt16)port;
- (void) setHost:(NSString *) host;
- (void) sendTap:(int) player;
- (void) sendShake:(int) player speed:(float) speed;
- (void) sendMovement:(int) player x:(int) x y:(int)y;
- (void) sendRotation:(int) player amount:(float) amount;
- (void) sendAudio:(int) player volume:(float) volume;
- (void) sendHello:(int) player;
- (void) sendQuit:(int)player;
- (void) play:(NSString *) name;
- (void) getConfirmation:(int) player;
- (void) alive;


@end
