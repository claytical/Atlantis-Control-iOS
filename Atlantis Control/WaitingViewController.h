//
//  WaitingViewController.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/7/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface WaitingViewController : UIViewController {
    AppDelegate *delegate;
}
@property (strong, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondaryMessageLabel;
- (IBAction)quit:(id)sender;
- (IBAction)refresh:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *waitingLabel;
@end
