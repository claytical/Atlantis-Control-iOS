//
//  WaitingViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/7/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "WaitingViewController.h"
#import "AppDelegate.h"

@interface WaitingViewController ()

@end

@implementation WaitingViewController

@synthesize waitingLabel, playerLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"message" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"confirmed" object:nil];

    NSLog(@"I'm registered for new messages");
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [playerLabel setText:[delegate player_name]];
    [delegate.client getConfirmation:delegate.server.player_id];
//    [waitingLabel setText:host_server];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) newMessage:(NSNotification *)notification {
    NSString *message = [notification.userInfo valueForKey:@"message"];
    [waitingLabel setText:message];
}

-(void) setHost:(NSString *)host {
    NSLog(@"Setting host to %@", host);
   // host_server = host;
}
-(void) viewWillAppear:(BOOL)animated {
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)quit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit"
                                                    message:@"Are you sure you want to quit?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];

}

- (IBAction)refresh:(id)sender {
    [delegate.client sendHello:delegate.server.player_id];
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
