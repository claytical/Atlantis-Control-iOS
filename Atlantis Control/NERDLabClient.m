//
//  NERDLabClient.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "NERDLabClient.h"
#import "AppDelegate.h"

@interface NERDLabClient()

@property (strong) F53OSCClient *client;
@property (assign) UInt16 port;

@end

@implementation NERDLabClient

-(id) initWithPort:(UInt16)port {
    self = [super init];
    if(self) {
        
        self.client = [[F53OSCClient alloc] init];
        [self.client setPort:port];
        
    }
    
    return self;
}

- (void) setHost:(NSString *)host {
    [self.client setHost:host];
    current_host = host;
    
}

- (void) alive {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/alive" arguments:nil];
    [self.client sendPacket:message];
    
    NSLog(@"Sending Alive Message");
    
}

-(void) getConfirmation:(int)player {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/confirm" arguments:nil];
    [self.client sendPacket:message];

}
-(void) sendTap:(int)player {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/tap" arguments:@[[NSNumber numberWithInt:player]]];
    [self.client sendPacket:message];
    
    NSLog(@"Sending Tap");
    
}
-(void) sendHello:(int)player {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/hello" arguments:@[[NSNumber numberWithInt:player]]];
    [self.client sendPacket:message];
    
    NSLog(@"Sending Hello");
    
}

-(void)sendShake:(int)player speed:(float) speed{
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/shake" arguments:@[[NSNumber numberWithInt:player]]];
    [self.client sendPacket:message];
    
    NSLog(@"Sending Shake");
    
}
-(void) sendMovement:(int)player x:(int)x y:(int)y {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/move" arguments:@[[NSNumber numberWithInt:player],[NSNumber numberWithInt:x], [NSNumber numberWithInt:y]]];
    [self.client sendPacket:message];

}
-(void) sendRotation:(int)player amount:(float)amount {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/rotate" arguments:@[[NSNumber numberWithInt:player], [NSNumber numberWithFloat:amount]]];
    [self.client sendPacket:message];
    
    NSLog(@"Sending Rotation of %f", amount);

}
-(void) sendAudio:(int)player volume:(float)volume {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/sound" arguments:@[[NSNumber numberWithInt:player], [NSNumber numberWithFloat:volume]]];
    NSLog(@"Sending Volume: %f", volume);
    [self.client sendPacket:message];
    
}
-(void) sendQuit:(int)player {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/quit" arguments:@[[NSNumber numberWithInt:player]]];
    NSLog(@"Sending Quit Message");
    [self.client sendPacket:message];
    
}

-(void)play:(NSString *) name {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/join" arguments:@[name]];
    [self.client sendPacket:message];
    NSLog(@"Joining game on %@ with name %@", current_host, name);
}


@end
