//
//  AudioViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController
@synthesize micGlowImageView, scoreNameLabel, scoreLabel, playerNameLabel, backgroundImage, micImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    animating = NO;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }

    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    audioInput = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (audioInput) {
        [audioInput prepareToRecord];
        audioInput.meteringEnabled = YES;
        [audioInput record];
        audioTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(audioTimerCallback:) userInfo:nil repeats:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"score" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreName:) name:@"score_name" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pulse:) name:@"pulse" object:nil];
    

    [playerNameLabel setText:[delegate player_name]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d",delegate.server.current_score]];
    //SUBMARINES
    if (delegate.server.image_set == 4) {
        micImageView.image = [UIImage imageUsingColor:delegate.server.image_set number:delegate.server.image_number color:delegate.server.player_color];
        backgroundImage.image = [UIImage imageNamed:@"submarines"];
    }
    else {
        backgroundImage.image = [UIImage imageNamed:@"evacuation"];
    }

}

-(void) viewWillDisappear:(BOOL)animated {
    [audioInput stop];
}

-(void) updateScore:(NSNotification *)notification {
    NSNumber *score = [notification.userInfo valueForKey:@"score"];
    [scoreLabel setText:[score stringValue]];
    
    
}
-(void) updateScoreName:(NSNotification *)notification {
    NSString *score_name = [notification.userInfo valueForKey:@"score_name"];
    [scoreNameLabel setText:score_name];
}
- (void)audioTimerCallback:(NSTimer *)timer {
    [audioInput updateMeters];

    float       level;                // The linear 0.0 .. 1.0 value we need.
    const float minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float       decibels    = [audioInput averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    if (level > .2) {
        micGlowImageView.hidden = NO;
        NSLog(@"AVG POWER: %f", level);
        [delegate.client sendAudio:delegate.server.player_id volume:level];
    }
    else {
        micGlowImageView.hidden = YES;
    }
   // NSLog(@"Average input: %f Peak input: %f", [audioInput averagePowerForChannel:0], [audioInput peakPowerForChannel:0]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) pulse:(NSNotification *)notification {
    micImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    [self.view addSubview:micImageView];
    [UIView animateWithDuration:.3/1.5  animations:^{
        micImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3/2 animations:^{
            micImageView.transform = CGAffineTransformIdentity;
        }];
    }];
}


- (IBAction)quit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit"
                                                    message:@"Are you sure you want to quit?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            [delegate.client sendQuit:delegate.server.player_id];
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"returning to main menu");
            break;
    }
}

@end
