//
//  TapViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "TapViewController.h"

@interface TapViewController ()

@end

@implementation TapViewController
@synthesize scoreLabel, scoreNameLabel, playerNameLabel, avatarImage, backgroundImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"score" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreName:) name:@"score_name" object:nil];
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmation:) name:@"confirmed" object:nil];

    [playerNameLabel setText:[delegate player_name]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d",delegate.server.current_score]];
//HUMANS, starting with pump
    if (delegate.server.image_set == 2) {
        backgroundImage.image = [UIImage imageNamed:@"evacuation"];

        //leave it alone
    }
//SUBMARINES
    if (delegate.server.image_set == 4) {
        avatarImage.imageView.image = [UIImage imageUsingColor:delegate.server.image_set number:delegate.server.image_number color:delegate.server.player_color];
        avatarImage.imageView.highlightedImage =[UIImage imageUsingColor:delegate.server.image_set number:delegate.server.image_number color:[UIColor grayColor]];
        backgroundImage.image = [UIImage imageNamed:@"submarines"];

    }
}

-(void)confirmation:(NSNotification *) notification {
    [scoreNameLabel setText:[delegate.server score_name]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d", [delegate.server current_score]]];
    
}

-(void) updateScore:(NSNotification *)notification {
    NSNumber *score = [notification.userInfo valueForKey:@"score"];
    [scoreLabel setText:[score stringValue]];
    
    
}
-(void) updateScoreName:(NSNotification *)notification {
    NSString *score_name = [notification.userInfo valueForKey:@"score_name"];
    [scoreNameLabel setText:score_name];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapOn:(id)sender {
    [delegate.client sendTap:delegate.server.player_id];
}

- (IBAction)tapOff:(id)sender {
    NSLog(@"Tap Off");
}

- (IBAction)quitControl:(id)sender {
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
