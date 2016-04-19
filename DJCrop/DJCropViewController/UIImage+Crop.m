//
//  UIImage+Crop.m
//  lswuyou
//
//  Created by yoanna on 15/10/20.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

-(UIImage *)cropImageWithRect:(CGRect)cropRect{
   
    UIImage *croppedImage = nil;
    CGPoint drawPoint = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(cropRect.size, YES, self.scale);
    {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        //To conserve memory in not needing to completely re-render the image re-rotated,
//        //map the image to a view and then use Core Animation to manipulate its rotation
//        
//            CGContextTranslateCTM(context, -cropRect.origin.x, -cropRect.origin.y);
//            [self drawAtPoint:drawPoint];
        
        [self drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y)];
//        [self drawAtPoint:CGPointMake(-self.size.width/2, 0)];
        
        
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

@end
