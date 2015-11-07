//
//  ViewController.m
//  Atlantis Control
//
//  Created by Clay Ewing on 9/24/15.
//  Copyright (c) 2015 NERDLab. All rights reserved.
//

#import "ViewController.h"
#include <arpa/inet.h>
#import "AppDelegate.h"

@interface ViewController ()


@property(nonatomic, retain) NSNetServiceBrowser *serviceBrowser;
@property(nonatomic, retain) NSNetService *serviceResolver;
@property(nonatomic, retain) NSMutableArray* services;
@property (nonatomic, assign) CGPoint savedTranslation;
@end

@implementation ViewController

@synthesize playerTextfield, playerTextVerticalConstraint;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverFound:) name:@"nerdlabServerFound" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.savedTranslation = CGPointMake(0,0);
     
    delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    serverList = [[NSMutableArray alloc] init];
}
-(void)dismissKeyboard {
    [delegate setPlayer_name:playerTextfield.text];
    [playerTextfield resignFirstResponder];
}
-(void) serverFound:(NSNotification *)notification {
    NSString *host = [notification.userInfo valueForKey:@"host"];
    NSString *ip = [notification.userInfo valueForKey:@"ip"];

    NSLog(@"Found Server in View Controller. Host: %@ IP: %@", host,ip);
    [serverList addObject:[NSString stringWithFormat:@"%@", ip]];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)dismiss:(id)sender {
    [delegate setPlayer_name:playerTextfield.text];
    [playerTextfield resignFirstResponder];
}

- (IBAction)beganEditingText:(id)sender {
   // UITextField *textField = (UITextField *) sender;
   // [self.view removeConstraint:playerTextVerticalConstraint];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:NO];
    playerTextfield.frame = CGRectMake(playerTextfield.frame.origin.x, playerTextfield.frame.origin.y - 100, playerTextfield.frame.size.width, playerTextfield.frame.size.height);
//    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y - 100.0), textField.frame.size.width, textField.frame.size.height);
    [UIView commitAnimations];

}

- (IBAction)stoppedEditingText:(id)sender {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    playerTextfield.frame = CGRectMake(playerTextfield.frame.origin.x, (playerTextfield.frame.origin.y + 500), playerTextfield.frame.size.width, playerTextfield.frame.size.height);
    [UIView commitAnimations];
//    [self.view addConstraint:playerTextVerticalConstraint];


}

- (IBAction)showServerList:(id)sender {
    if ([playerTextfield.text length] == 0) {
        //TODO: Random Name Generation
    }
    else {
        [delegate setPlayer_name:playerTextfield.text];
    }
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Choose a Server"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
    
    UIAlertAction *cancelAction = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *cancelAction)
                             {
                                 
                                 NSLog(@"Cancel action");
                             }];
    [alertController addAction:cancelAction];
    UIAlertAction *manualAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Manual Entry", @"Manual Input of IP")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    
  //                                  [self dismissViewControllerAnimated:YES completion:^{
                                        UIAlertController *manualEntryController = [UIAlertController alertControllerWithTitle:@"Manual Entry" message:@"Enter the IP Address of the Atlantis Server" preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [manualEntryController addTextFieldWithConfigurationHandler:^(UITextField *textField)
                                         {
                                             textField.placeholder = NSLocalizedString(@"IP Address", @"IP");
                                             textField.keyboardType = UIKeyboardTypeDecimalPad;
                                         }];
                                    UIAlertAction *cancelEntry = [UIAlertAction
                                                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                                   style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction *cancelEntryAction)
                                                                   {
                                                                       
                                                                       NSLog(@"Cancel action");
                                                                   }];
                                    UIAlertAction *submitEntry = [UIAlertAction
                                                                  actionWithTitle:NSLocalizedString(@"Submit", @"Submit")
                                                                  style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *submitEntryAction)
                                                                  {
                                                                      //TODO: Waiting Screen
                                                                      selectedHost = [manualEntryController.textFields objectAtIndex:0].text;
                                                                      [delegate setClientHost:selectedHost];
                                                                      [delegate.client play:playerTextfield.text];

                                                                      NSLog(@"Submitted %@", selectedHost);
                                                                  }];
                                    [manualEntryController addAction:cancelEntry];
                                    [manualEntryController addAction:submitEntry];
                                    

                                        [self presentViewController:manualEntryController animated:YES completion:nil];
                                        

                                        
//                                    }];
                                    
                                }];
    
    [alertController addAction:manualAction];
/*
    UIAlertAction *tapAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Tap", @"Tap Screen")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                                       [vc performSegueWithIdentifier:@"tapping" sender:self];
                                       
                                       NSLog(@"tap action");
                                   }];
    
    [alertController addAction:tapAction];

    
    UIAlertAction *audioAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Audio", @"Audio Screen")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                                    [vc performSegueWithIdentifier:@"audio" sender:self];
                                    NSLog(@"audio action");
                                }];
    
    [alertController addAction:audioAction];
    
    UIAlertAction *swipeAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Swipe", @"Swipe Wheel")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                                    [vc performSegueWithIdentifier:@"swipe" sender:self];

                                }];
    
    [alertController addAction:swipeAction];
    
    
    UIAlertAction *rotateAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Rotate", @"Rotate")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                                      [vc performSegueWithIdentifier:@"rotate" sender:self];
                                      
                                  }];
    
    [alertController addAction:rotateAction];
    
    
    UIAlertAction *moveAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Move", @"Move Screen")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                                    [delegate.server setImage_set:1];
                                    [delegate.server setImage_number:5];
                                    [vc performSegueWithIdentifier:@"movement" sender:self];

                                    NSLog(@"move action");
                                }];
    
    [alertController addAction:moveAction];

    
    UIAlertAction *shakeAction = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Shake", @"Shake Screen")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                                     [vc performSegueWithIdentifier:@"shaking" sender:self];

                                 }];
    
    [alertController addAction:shakeAction];
    
    UIAlertAction *serverActionOut = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"localhost", @"iMac")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       selectedHost = @"10.193.10.24";
                                       [delegate setClientHost:selectedHost];
                                       [delegate.client play:playerTextfield.text];

                                   }];
    
    [alertController addAction:serverActionOut];
    
    */
    for (int i = 0; i < [serverList count]; i++) {
        UIAlertAction *serverAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString([serverList objectAtIndex:i], [serverList objectAtIndex:i])
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           selectedHost = [serverList objectAtIndex:i];
                                           [delegate setClientHost:selectedHost];
                                           [delegate.client play:playerTextfield.text];

                                           NSLog(@"Selected Host: %@", selectedHost);
                                       }];
        
        [alertController addAction:serverAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];

}





@end