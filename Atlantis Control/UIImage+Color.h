//
//  UIImageAdditions.h
//  Atlantis Control
//
//  Created by Clay Ewing on 10/15/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (ColorAdditions)

+(UIImage *)imageUsingColor:(int)set number: (int) number color: (UIColor *) color;
+(UIImage *)imageFromSet:(int) set number: (int) number renderMode: (int) renderer;

@end
