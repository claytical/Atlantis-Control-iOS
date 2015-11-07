//
//  UIImageAdditions.m
//  Atlantis Control
//
//  Created by Clay Ewing on 10/15/15.
//  Copyright © 2015 NERDLab. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (ColorAdditions)

+(UIImage *)imageFromSet:(int) set number: (int) number renderMode: (int) renderer {
    NSString *prefix;
    switch (set) {
        case 0:
            //SQUARE
            prefix = @"sq";
            break;
        case 1:
            //ABSTRACT
            prefix = @"a";
            break;
            
        case 2:
            //HUMANS
            prefix = @"h";
            break;
        case 3:
            //TANKS
            prefix = @"t";
            break;
        case 4:
            //SUBMARINES
            prefix = @"s";
            break;
        default:
            prefix = @"a";
            break;
    }
    UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%d", prefix, number]] imageWithRenderingMode:renderer];

    return image;
    
}

+(UIImage *)imageUsingColor:(int)set number: (int) number color: (UIColor *) color {
    UIImage *image = [UIImage imageFromSet:set number:number renderMode:UIImageRenderingModeAutomatic];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(image.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return coloredImg;

}
@end
