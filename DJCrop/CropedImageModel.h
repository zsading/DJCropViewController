//
//  CropedImageModel.h
//  lswuyou
//
//  Created by yoanna on 15/10/16.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CropedImageModel : NSObject

+(instancetype)shareCropedImage;

/**裁剪好的大图*/
@property (nonatomic,strong) NSMutableArray *cropImageArray;
/**大图的url地址*/
@property (nonatomic,strong) NSString *fullImageStr;
/**裁剪好的小图*/
@property (nonatomic,strong) NSMutableArray *cropQuestionsArray;
/**裁剪好的坐标*/
@property (nonatomic,strong) NSMutableArray *cropRectsArray;
//全图
@property (nonatomic,strong) UIImage *fullImage;
//布置作业时具体每题的模型
@property (nonatomic,strong) NSMutableArray *subjectModelArr;

-(void)clearAllData;
@end
