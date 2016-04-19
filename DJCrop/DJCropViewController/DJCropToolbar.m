//
//  DJCropToolbar.m
//  DJCrop
//
//  Created by yoanna on 16/4/12.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "DJCropToolbar.h"


@interface DJCropToolbar ()


@property (nonatomic,strong) UIButton *cropBtn;

@property (nonatomic,strong) void (^crop)();

@end


@implementation DJCropToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    
    self.backgroundColor = [UIColor whiteColor];
    //裁剪按钮
    self.cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cropBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    [self.cropBtn addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cropBtn];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect frame = CGRectZero;
    frame.size.height = 44;
    frame.size.width = [self.cropBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.cropBtn.titleLabel.font}].width + 10;
    frame.origin.x = CGRectGetMaxX(self.bounds)-frame.size.width;
    frame.origin.y = 0;
    self.cropBtn.frame = frame;
    
}

#pragma mark - private methods

- (void)cropImageWithBlock:(void (^)(void))block{
    
    if (block) {
        self.crop = block;
    }
}

- (void)crop:(UIButton *)btn{
    self.crop();
}
@end
