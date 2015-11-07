//
//  MovementViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "MovementViewController.h"
#import "UIImage+Color.h"


@interface MovementViewController ()

@end

@implementation MovementViewController
@synthesize scoreLabel, scoreNameLabel, playerNameLabel, backgroundImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"score" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreName:) name:@"score_name" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageSet:) name:@"image_set" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pulse:) name:@"pulse" object:nil];

    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmation:) name:@"confirmed" object:nil];
    if (delegate.server.image_set == 4) {
        avatarImage.image = [UIImage imageUsingColor:delegate.server.image_set number:delegate.server.image_number color:delegate.server.player_color];
        backgroundImage.image = [UIImage imageNamed:@"submarines"];
        
    }
    else {
        avatarImage.image = [UIImage imageFromSet:delegate.server.image_set number:delegate.server.image_number renderMode:UIImageRenderingModeAlwaysTemplate];
        [avatarImage setTintColor:delegate.server.player_color];
        backgroundImage.image = [UIImage imageNamed:@"diamond_rush"];

    }
        lastLocation = avatarImage.center;
    [playerNameLabel setText:[delegate player_name]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d",delegate.server.current_score]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) updateScore:(NSNotification *)notification {
    NSNumber *score = [notification.userInfo valueForKey:@"score"];
    [scoreLabel setText:[score stringValue]];
    

}

-(void) pulse:(NSNotification *)notification {
    avatarImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    [self.view addSubview:avatarImage];
    [UIView animateWithDuration:.3/1.5  animations:^{
        avatarImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3/2 animations:^{
            avatarImage.transform = CGAffineTransformIdentity;
        }];
    }];
}

-(void) updateImageSet:(NSNotification *)notification {
    NSLog(@"Updating image set...");
    
}

-(void) updateScoreName:(NSNotification *)notification {
    NSString *score_name = [notification.userInfo valueForKey:@"score_name"];
    [scoreNameLabel setText:score_name];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)handleMovement:(UIPanGestureRecognizer *)sender {
    CGPoint locationInView = [sender locationInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        lastLocation = locationInView;
    }
    
    
    float speedX =  lastLocation.x - locationInView.x;
    float speedY =  lastLocation.y - locationInView.y;

    if (speedX != 0 && speedY != 0) {
        [delegate.client sendMovement:delegate.server.player_id x: speedX y:speedY];
        NSLog(@"movin! (%f,%f)", locationInView.x - lastLocation.x, locationInView.y - lastLocation.y);
    }

    avatarImage.center = locationInView;

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
