//
//  CropedImageModel.m
//  lswuyou
//
//  Created by yoanna on 15/10/16.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import "CropedImageModel.h"

static id _instance;
@implementation CropedImageModel


+(instancetype)shareCropedImage
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createCropedArray];
    }
    return self;
}

-(void)createCropedArray
{
    if (self.cropImageArray == nil) {
        self.cropImageArray = [NSMutableArray array];
    }
    
    if (self.cropQuestionsArray == nil) {
        self.cropQuestionsArray = [NSMutableArray array];
    }
    
    if (self.cropRectsArray == nil) {
        self.cropRectsArray = [NSMutableArray array];
    }
    
    if (self.subjectModelArr == nil) {
        self.subjectModelArr = [NSMutableArray array];
    }
}

-(void)clearAllData
{
    [self.cropImageArray removeAllObjects];
    [self.cropQuestionsArray removeAllObjects];
    [self.cropRectsArray removeAllObjects];
    [self.subjectModelArr removeAllObjects];
}

@end
