//
//  DJContainerView.h
//  DJCrop
//
//  Created by dingjia on 16/4/13.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJContainerView : UIView

@property (nonatomic,strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame;

- (instancetype)initWithImage:(UIImage *)image;

//得到图片裁剪的坐标
- (CGRect)croppedImageFrame;

//得到裁剪的图片
- (UIImage *)croppedImage;
@end
