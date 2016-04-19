//
//  HomeCropSquare.m
//  lswuyou
//
//  Created by yoanna on 15/10/19.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import "HomeCropSquare.h"
#import "Masonry.h"

@interface HomeCropSquare ()

//borderLine
@property (nonatomic,strong) NSArray *borderLineViews;

@end

@implementation HomeCropSquare

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        [self setup];
    }
    
    return self;
}

//initialize
- (void)setup{
   
    self.borderLineViews = @[[self newLineView],[self newLineView],[self newLineView],[self newLineView]];
    
}

- (UIView *)newLineView{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    return lineView;
}

//layout border Lines
- (void)layoutLines{
    
    CGSize boundsSize = self.bounds.size;
    CGRect frame = CGRectZero;
    
    for (int i = 0; i < 4; i++) {
        UIView *lineView = self.borderLineViews[i];
        
        switch (i) {
                
            case 0:
                //top
                frame = CGRectMake(-1.0f, -1.0f, boundsSize.width+2.0f, 1.0f);
                break;
            case 1:
                //right
                frame = CGRectMake(boundsSize.width, 0.0f, 1.0f, boundsSize.height);
                break;
            case 2:
                //left
                frame = CGRectMake(-1.0f, 0, 1.0f, boundsSize.height+1.0f);
                break;
            case 3:
                //bottom
                frame = CGRectMake(-1.0f, boundsSize.height, boundsSize.width+2.0f, 1.0f);
                break;
            default:
                break;
        }
        
        lineView.frame = frame;
    }
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (self.borderLineViews) {
        [self layoutLines];
    }
}


- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.borderLineViews) {
        [self layoutLines];
    }
}


-(void)setCropBorderColor:(UIColor *)borderColor
{
    if (self.borderLineViews) {
        for (UIView *lineView in self.borderLineViews) {
            lineView.backgroundColor = borderColor;
        }
    }
}
@end
