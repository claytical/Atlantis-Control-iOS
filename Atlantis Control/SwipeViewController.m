//
//  SwipeViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()

@end

@implementation SwipeViewController
@synthesize scoreLabel, scoreNameLabel, playerNameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"score" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreName:) name:@"score_name" object:nil];
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmation:) name:@"confirmed" object:nil];

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
-(IBAction)swipeLeft:(id)sender {
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 0.25;
    rotate.repeatCount = 1;
    [[sender view].layer addAnimation:rotate forKey:@"10"];
    [delegate.client sendRotation:delegate.server.player_id amount:-200];
}
-(IBAction)swipeRight:(id)sender{
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.toValue = [NSNumber numberWithFloat:0];
    rotate.duration = 0.25;
    rotate.repeatCount = 1;
    [[sender view].layer addAnimation:rotate forKey:@"10"];
    [delegate.client sendRotation:delegate.server.player_id amount:200];
    
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
