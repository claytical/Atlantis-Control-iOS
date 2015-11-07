//
//  RotateViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/15/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RotateViewController : UIViewController {
    AppDelegate *delegate;
}
- (IBAction)handleRotation:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *controlImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)quit:(id)sender;

@end
