//
//  DJCropViewController.h
//  DJCrop
//
//  Created by dingjia on 16/4/13.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CropCompletion)(UIImage *);

@interface DJCropViewController : UIViewController

- (void)cropImageWithCompletion:(CropCompletion)completion;
@end
