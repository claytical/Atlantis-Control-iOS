//
//  ShakeViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "ShakeViewController.h"

@interface ShakeViewController ()

@end

@implementation ShakeViewController
@synthesize scoreNameLabel, scoreLabel, playerNameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"score" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreName:) name:@"score_name" object:nil];
    [playerNameLabel setText:[delegate player_name]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d",delegate.server.current_score]];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmation:) name:@"confirmed" object:nil];
    shaking = NO;

}
- (void)viewDidAppear:(BOOL)animated {
//    [self becomeFirstResponder];
    [self startMyMotionDetect];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    [self.motionManager stopAccelerometerUpdates];
    
}
-(void) updateScore:(NSNotification *)notification {
    NSNumber *score = [notification.userInfo valueForKey:@"score"];
    [scoreLabel setText:[score stringValue]];
    
    
}
-(void) updateScoreName:(NSNotification *)notification {
    NSString *score_name = [notification.userInfo valueForKey:@"score_name"];
    [scoreNameLabel setText:score_name];
}
/*
- (BOOL)canBecomeFirstResponder {
    return YES;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    if ([delegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [delegate motionManager];
    }
    
    return motionManager;
}

- (void)startMyMotionDetect
{
    
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            
                            float speed = fabs(data.acceleration.x+data.acceleration.y+data.acceleration.z - previous_x - previous_y - previous_z); // diffTime * 10000;

                            previous_x = data.acceleration.x;
                            previous_y = data.acceleration.y;
                            previous_z = data.acceleration.z;
                            if (speed > .04 && !shaking) {
                                [delegate.client sendShake:delegate.server.player_id speed:speed];

                                shaking = YES;
                                [UIView animateWithDuration:.5 animations:^{
                                    shakeImage.transform = CGAffineTransformMakeRotation(-30);
                                    }
                                        completion:^(BOOL finished) {
                                                     [UIView animateWithDuration:.5 animations:^{
                                                         shakeImage.transform = CGAffineTransformMakeRotation(35);
                                                     }
                                                                      completion:^(BOOL finished) {
                                                                          shaking = NO;
                                                                      }];
                                        [UIView commitAnimations];
                                }];
                                
                                [UIView commitAnimations];

                            }
                            
                        }
                        );
     }
     ];
    
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
