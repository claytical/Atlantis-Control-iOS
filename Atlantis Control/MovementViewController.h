//
//  MovementViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MovementViewController : UIViewController {
    AppDelegate *delegate;
    IBOutlet UIImageView *avatarImage;
    CGPoint lastLocation;
}
- (IBAction)quit:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *scoreNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
