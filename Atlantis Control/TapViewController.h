//
//  TapViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/1/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TapViewController : UIViewController {
        AppDelegate *delegate;
}
- (IBAction)tapOn:(id)sender;
- (IBAction)tapOff:(id)sender;
- (IBAction)quitControl:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *avatarImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
