//
//  ViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 9/24/15.
//  Copyright (c) 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F53OSC.h"
#import "WaitingViewController.h"
#import "UIImage+Color.h"

//#import "AppDelegate.h"
@class AppDelegate;

@interface ViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate> {
    NSMutableArray *serverList;
    AppDelegate *delegate;
    NSString *selectedHost;
}

@property (strong, nonatomic) IBOutlet UITextField *playerTextfield;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playerTextVerticalConstraint;
- (IBAction)dismiss:(id)sender;
- (IBAction)beganEditingText:(id)sender;
- (IBAction)stoppedEditingText:(id)sender;

- (IBAction)showServerList:(id)sender;
@end

