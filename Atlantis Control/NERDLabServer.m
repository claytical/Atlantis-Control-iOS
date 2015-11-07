//
//  NERDLabServer.m
//  Atlantis Control
//
//  Created by Clay Ewing on 9/30/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "NERDLabServer.h"
#import "AppDelegate.h"

@interface NERDLabServer()

@property (strong) F53OSCServer *server;
@property (assign) UInt16 listeningPort;
@property (assign) bool isActive;

@end

@implementation NERDLabServer
@synthesize player_color, player_id, player_index, image_number, image_set, control_set, current_score, score_name;

-(id) initWithPort:(UInt16)port {
    self = [super init];
    if(self) {
        self.server = [F53OSCServer new];
        self.server.delegate = self;
        self.listeningPort = port;
        self.server.port = self.listeningPort;

    }
    return self;
}

-(void) start {
    NSLog(@"Starting OSC Server");
    if (![self.server startListening]) {
        NSLog(@"Unable to start listening on port %u", self.server.port);
    }
    else {
        NSLog(@"Listening for OSC messages on port %u", self.server.port);
        self.isActive = YES;
    }
}

-(void) stop {
    [self.server stopListening];
    self.isActive = NO;
}

#pragma mark - Message Handling

///
///  Note: F53OSC reserves the right to send messages off the main thread.
///


- (void)takeMessage:(F53OSCMessage *)message
{
    // handle all messages synchronously
    NSLog(@"Taking Message");
    [self performSelectorOnMainThread:@selector( _processMessage: ) withObject:message waitUntilDone:NO];
}

- (void)_processMessage:(F53OSCMessage *)message
{
    NSLog(@"MESSAGE ARGUMENTS: %@", message.arguments);
    if ([message.arguments count] > 0) {
        if ([message.addressPattern isEqualToString:@"/quit"]) {
            [self quit];
        }
        
        if ([message.addressPattern isEqualToString:@"/confirmed"]) {
            NSLog(@"Got Confirmation message %@", [message.arguments objectAtIndex:0]);
            NSDictionary *messages = [[NSDictionary alloc] initWithObjectsAndKeys:[message.arguments objectAtIndex:0], @"message", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmed" object:nil userInfo:messages];

        }
        
        if ([message.addressPattern isEqualToString:@"/reset"]) {
            [self.app.client alive];
        }

        if ([message.addressPattern isEqualToString:@"/start"]) {
            [self start:[[message.arguments objectAtIndex:0] intValue] images:[[message.arguments objectAtIndex:1] intValue] avatar:[[message.arguments objectAtIndex:2] intValue] scoreName:[message.arguments objectAtIndex:3] startingScore:[[message.arguments objectAtIndex:4] intValue] red:[[message.arguments objectAtIndex:5] intValue] green:[[message.arguments objectAtIndex:6] intValue] blue:[[message.arguments objectAtIndex:7] intValue] controls:[[message.arguments objectAtIndex:8] intValue]];
        }
        if ([message.addressPattern isEqualToString:@"/rejoin"]) {
        
            player_color = [UIColor colorWithRed:[[message.arguments objectAtIndex:4] intValue] green:[[message.arguments objectAtIndex:5] intValue] blue:[[message.arguments objectAtIndex:6] intValue] alpha:1];
            player_id = [[message.arguments objectAtIndex:0] intValue];
            image_number = [[message.arguments objectAtIndex:7] intValue];
            image_set = [[message.arguments objectAtIndex:8] intValue];
            if ([message.arguments objectAtIndex:3] == 0) {
                [self setState:[[message.arguments objectAtIndex:1] intValue]];
            }
            else {
                [self setControl:[[message.arguments objectAtIndex:2] intValue]];
            }
        }
        
        if ([message.addressPattern isEqualToString:@"/set"]) {
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"index"]) {
                [self setPlayer_index:[[message.arguments objectAtIndex:1] intValue]];
            }
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"control"]) {
                [self setControl:[[message.arguments objectAtIndex:1] intValue]];
            }
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"control_enabled"]) {
                if ([[message.arguments objectAtIndex:1] integerValue] == 0) {
                    [self wait];
                }
            }
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"reaction"]) {
                [self reaction:[[message.arguments objectAtIndex:1] intValue]];
            }
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"color"]) {
                [self setColor:[[message.arguments objectAtIndex:1] intValue] green:[[message.arguments objectAtIndex:2] intValue] blue:[[message.arguments objectAtIndex:3] intValue]];
            }
            
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"state"]) {
                [self setState:[[message.arguments objectAtIndex:1] intValue]];
            }

            if ([[message.arguments objectAtIndex:0] isEqualToString:@"image"]) {
                [self setImageNumber:[[message.arguments objectAtIndex:1] intValue]];
                NSLog(@"Setting Image Number to %d", image_number);
            }
            
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"id"]) {
                [self setPlayer_id:[[message.arguments objectAtIndex:1] intValue]];
            }
            
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"images"]) {
                [self setImage_set:[[message.arguments objectAtIndex:1] intValue]];
                NSDictionary *messages = [[NSDictionary alloc] initWithObjectsAndKeys:[message.arguments objectAtIndex:1], @"image_set", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"image_set" object:nil userInfo:messages];
                NSLog(@"Image Set Notification");

                NSLog(@"Using Image Set %d", image_set);
            }
            
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"score_name"]) {
                [self setScore_name:[message.arguments objectAtIndex:1]];
                NSDictionary *messages = [[NSDictionary alloc] initWithObjectsAndKeys:[message.arguments objectAtIndex:1], @"score_name", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"score_name" object:nil userInfo:messages];
                NSLog(@"Posting Notification");

            }
            
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"score"]) {
                [self setCurrent_score:[[message.arguments objectAtIndex:1] intValue]];
                NSDictionary *messages = [[NSDictionary alloc] initWithObjectsAndKeys:[message.arguments objectAtIndex:1], @"score", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"score" object:nil userInfo:messages];
                NSLog(@"Posting Notification");

            }
            
            if ([[message.arguments objectAtIndex:0] isEqualToString:@"outgamemessage"]) {
                //TODO: Set label to out game message
                UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];

                [vc setTitle:[message.arguments objectAtIndex:1]];
                NSLog(@"Message: %@", [message.arguments objectAtIndex:1]);
                NSDictionary *messages = [[NSDictionary alloc] initWithObjectsAndKeys:[message.arguments objectAtIndex:1], @"message", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil userInfo:messages];
                NSLog(@"Posting Notification");
            
            }
            
            
        }
    }
}

-(void) confirmed {


}

- (void) reaction: (int) react_id {
    if (react_id == 0) {
        //PULSE
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pulse" object:nil userInfo:nil];
        
    }
    else if (react_id == 1){
        //ROLL CALL
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

    }
}
- (void) start:(int) playerId images:(int)imageSet avatar: (int) imageNumber scoreName: (NSString *) name startingScore: (int) score red: (int) playerR green: (int) playerG blue: (int) playerB controls: (int) controlSet {
    player_id = playerId;
    image_set = imageSet;
    image_number = imageNumber;
    score_name = name;
    current_score = score;
    [self setColor:playerR green:playerG blue:playerB];
    control_set = controlSet;
    NSLog(@"Got start command! Using control %d", controlSet);
    [self setControl:controlSet];
//    NSDictionary *messages = [[NSDictionary alloc] initWithObjectsAndKeys:score_name, @"score_name", current_score, @"score", nil];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"score_name" object:nil userInfo:messages];
    NSLog(@"Starting Game with Parameters");

    
}

-(void) quit {
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [vc.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setColor:(int)red green:(int)green blue:(int)blue{
    player_color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    
}

-(void) wait {
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [vc performSegueWithIdentifier:@"waiting" sender:self];
}

-(void) setState: (UInt16) state {
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    if (state == 0) {
        //WAITING
        [vc performSegueWithIdentifier:@"waiting" sender:self];
    }
    if (state == 1) {
        //PAUSED - In between mini games
    }
    if (state == 2) {
        //PLAYING - After roll call, ready to play
    }
    
    if (state == 3) {
        //SHOW MESSAGE - Not used in controller
    }
    
    if (state == 4) {
        //IN PROGRESS - Not used in controller
    }
    
    if (state == 5) {
        //ROLL CALL - not used in controller
    }
}

-(void) setImageNumber:(int)number {
    image_number = number;
}

-(void) setControl:(UInt16)control {
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    NSLog(@"Got Control %d", control);
    if (control == 0) {
        NSLog(@"Got Movement Control");
        [vc performSegueWithIdentifier:@"movement" sender:self];
    }
    
    if (control == 1) {
        NSLog(@"Got Audio Control");
        //check for image set
        [vc performSegueWithIdentifier:@"audio" sender:self];
    }
    
    if (control == 2) {
        NSLog(@"Got Shake Control");
        [vc performSegueWithIdentifier:@"shaking" sender:self];
    }
    if (control == 3) {
        NSLog(@"Got Tap Control");
        //check for image set
        [vc performSegueWithIdentifier:@"tapping" sender:self];
    }
    
    if (control == 4) {
        //check for image set
        if (image_set == 4) {
            [vc performSegueWithIdentifier:@"rotate" sender:self];
        }
        else {
            [vc performSegueWithIdentifier:@"swipe" sender:self];
        }
    }

    if (control == 6) {
        //SUBMARINES -> CONTROLLING NOTHING
    }
}



@end
