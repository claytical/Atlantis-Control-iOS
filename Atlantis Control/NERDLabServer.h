//
//  NERDLabServer.h
//  Atlantis Control
//
//  Created by Clay Ewing on 9/30/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F53OSC.h"
#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>

@class AppDelegate;


@interface NERDLabServer : NSObject <F53OSCPacketDestination> {
    
}

@property (weak) AppDelegate *app;
@property (atomic) int player_id;
@property (atomic) int player_index;
@property (atomic) int image_set;
@property (atomic) int image_number;
@property (strong, atomic) NSString *score_name;
@property (atomic) int current_score;
@property (strong, atomic) UIColor *player_color;
@property (atomic) int control_set;

-(id) initWithPort:(UInt16)port;

-(void) start;
-(void) stop;
-(bool) isActive;

-(void) setControl:(UInt16)control;
-(void) start:(int) playerId images:(int)imageSet avatar: (int) imageNumber scoreName: (NSString *) name startingScore: (int) score red: (int) playerR green: (int) playerG blue: (int) playerB controls: (int) controlSet;
-(void) setColor:(int) red green:(int) green blue:(int) blue;
-(void) setImageNumber:(int) number;
-(void) confirmed;
@end
