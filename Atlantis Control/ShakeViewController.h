//
//  ShakeViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>

@interface ShakeViewController : UIViewController {
    AppDelegate *delegate;
    BOOL shaking;
    IBOutlet UIImageView *shakeImage;
    float previous_x;
    float previous_y;
    float previous_z;
    

}
@property (strong, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)quit:(id)sender;

@end
