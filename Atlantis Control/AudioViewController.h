//
//  AudioViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AppDelegate.h"

@interface AudioViewController : UIViewController {
    AppDelegate *delegate;
    AVAudioRecorder *audioInput;
    NSTimer *audioTimer;
    BOOL animating;
    

}
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *micImageView;
@property (strong, nonatomic) IBOutlet UIImageView *micGlowImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)quit:(id)sender;

@end
