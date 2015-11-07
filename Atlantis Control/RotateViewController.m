//
//  RotateViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/15/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "RotateViewController.h"

@interface RotateViewController ()

@end

@implementation RotateViewController
@synthesize controlImage, backgroundImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmation:) name:@"confirmed" object:nil];
    controlImage.image = [UIImage imageUsingColor:delegate.server.image_set number:delegate.server.image_number color:delegate.server.player_color];
    backgroundImage.image = [UIImage imageNamed:@"submarines"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pulse:) name:@"pulse" object:nil];



}

- (IBAction)handleRotation:(id)sender {
    UIRotationGestureRecognizer *gest = (UIRotationGestureRecognizer *) sender;
    float degrees = gest.rotation * (180 / M_PI);
    self.controlImage.transform = CGAffineTransformRotate(self.controlImage.transform, gest.rotation);
    [delegate.client sendRotation:delegate.server.player_id amount:degrees];
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
    controlImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self.view addSubview:controlImage];
    [UIView animateWithDuration:.3/1.5  animations:^{
        controlImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3/2 animations:^{
            controlImage.transform = CGAffineTransformIdentity;
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
