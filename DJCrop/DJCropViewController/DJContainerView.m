//
//  DJContainerView.m
//  DJCrop
//
//  Created by dingjia on 16/4/13.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "DJContainerView.h"
#import "DJCropScrollView.h"
#import "HomeCropSquare.h"
#import "UIImage+Crop.h"

//padding Value but has some problems,so please don't to change it
static const CGFloat kTOCropViewPadding = 0.0f;

static const CGFloat kTOCropViewMinimumBoxSize = 42.0f;

typedef NS_ENUM(NSInteger, DJCropViewOverlayEdge) {
    DJCropViewOverlayEdgeNone,
    DJCropViewOverlayEdgeTopLeft,
    DJCropViewOverlayEdgeTop,
    DJCropViewOverlayEdgeTopRight,
    DJCropViewOverlayEdgeRight,
    DJCropViewOverlayEdgeBottomRight,
    DJCropViewOverlayEdgeBottom,
    DJCropViewOverlayEdgeBottomLeft,
    DJCropViewOverlayEdgeLeft
};


@interface DJContainerView() <UIScrollViewDelegate,UIGestureRecognizerDelegate>


//selfView --> scrollView --> backgroundContainerView --> backgroundImageView --> overlayView --> translucencyView
//-->foregroundContainerView --> foregroundImageView -->cropView

//imageView in background
@property (nonatomic,strong) UIImageView *backgroundImageView;
//the containerView for backgroundImageView
@property (nonatomic,strong) UIView *backgroundContainerView;
//scrollView to scroll imageView
@property (nonatomic,strong) DJCropScrollView *scrollView;
//cropView , a variable view to crop image
@property (nonatomic,strong) HomeCropSquare *cropView;
//the containerVIew for foregroundImageView
@property (nonatomic,strong) UIView *foregroundContainerView;
//the imageView to show the image you crop
@property (nonatomic,strong) UIImageView *foregroundImageView;
//a dimming view
@property (nonatomic,strong) UIView *overlayView;
//a blur view
@property (nonatomic,strong) UIView *translucencyView;
//pan gesture
@property (nonatomic,strong) UIPanGestureRecognizer *gridPanGestureRecognizer;
//cropView frame in containerView
@property (nonatomic,assign) CGRect cropBoxFrame;


/* Crop box handling */
@property (nonatomic, assign) DJCropViewOverlayEdge tappedEdge; /* The edge region that the user tapped on, to resize the cropping region */
@property (nonatomic, assign) CGRect cropOriginFrame;     /* When resizing, this is the original frame of the crop box. */
@property (nonatomic, assign) CGPoint panOriginPoint;     /* The initial touch point of the pan gesture recognizer */


/**
 When the cropping box is locked to its current size
 */
@property (nonatomic, assign) BOOL aspectLockEnabled;

/**
 Inset the workable region of the crop view in case in order to make space for accessory views
 */
@property (nonatomic, assign) UIEdgeInsets cropRegionInsets;

- (void)setup;
@end


@implementation DJContainerView

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _image = image;
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image{
    
    if (self = [super init]) {
        _image = image;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    //initialize
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor blackColor];
    self.cropBoxFrame = CGRectZero;
    
    //add Scrollview
    self.scrollView = [[DJCropScrollView alloc] initWithFrame:self.bounds];
    NSLog(@"%@",[NSValue valueWithCGRect:self.bounds]);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;

    [self addSubview:self.scrollView];
    
    //backgroundImage
    self.backgroundImageView = [[UIImageView alloc] initWithImage:self.image];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //backgroundContainer
    self.backgroundContainerView = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];
    [self.backgroundContainerView addSubview:self.backgroundImageView];
    [self.scrollView addSubview:self.backgroundContainerView];
    
   //dimming view
    self.overlayView = [[UIView alloc] initWithFrame:self.bounds];
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.overlayView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.35];
    self.overlayView.userInteractionEnabled = NO;
    [self addSubview:self.overlayView];
    
    //blur view
    if (NSClassFromString(@"UIVisualEffectView")) {
        self.translucencyView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.translucencyView.frame = self.bounds;
    }
    else {
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleBlack;
        self.translucencyView = toolbar;
        self.translucencyView.frame = CGRectInset(self.bounds, -1.0f, -1.0f);
    }
    
    self.translucencyView.hidden = NO;
    self.translucencyView.userInteractionEnabled = NO;
    self.translucencyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.translucencyView];
    
    //foregroundContainer
    self.foregroundContainerView = [[UIView alloc] initWithFrame:(CGRect){0,0,200,100}];
    self.foregroundContainerView.clipsToBounds = YES;
    self.foregroundContainerView.userInteractionEnabled = NO;
    [self addSubview:self.foregroundContainerView];
    
    self.foregroundImageView = [[UIImageView alloc] initWithImage:self.image];
    [self.foregroundContainerView addSubview:self.foregroundImageView];
    
    //cropView
    self.cropView = [[HomeCropSquare alloc] initWithFrame:self.foregroundContainerView.frame];
    self.cropView.userInteractionEnabled = NO;
    NSLog(@"initialize--->cropViewframe:%@",[NSValue valueWithCGRect:self.cropView.frame]);
    [self addSubview:self.cropView];
    self.cropBoxFrame = self.cropView.frame;
    
    //PanGesture
    self.gridPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gridPanGestureRecognized:)];
    self.gridPanGestureRecognizer.delegate = self;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.gridPanGestureRecognizer];
    [self addGestureRecognizer:self.gridPanGestureRecognizer];
    

}


//judge which edge you drag
- (DJCropViewOverlayEdge)cropEdgeForPoint:(CGPoint)point
{
    

     CGRect frame = self.cropBoxFrame;
    
    //account for padding around the box
    frame = CGRectInset(frame, -22.0f, -22.0f);


    
    //Make sure the corners take priority
    
    //top left
    CGRect topLeftRect = (CGRect){frame.origin, {44,44}};
    if (CGRectContainsPoint(topLeftRect, point))
        return DJCropViewOverlayEdgeTopLeft;
    
    //top right
    CGRect topRightRect = topLeftRect;
    topRightRect.origin.x = CGRectGetMaxX(frame) - 44.0f;
    if (CGRectContainsPoint(topRightRect, point))
        return DJCropViewOverlayEdgeTopRight;
    
    //bottom left
    CGRect bottomLeftRect = topLeftRect;
    bottomLeftRect.origin.y = CGRectGetMaxY(frame) - 44.0f;
    if (CGRectContainsPoint(bottomLeftRect, point))
        return DJCropViewOverlayEdgeBottomLeft;
    
    //bottom right
    CGRect bottomRightRect = topRightRect;
    bottomRightRect.origin.y = bottomLeftRect.origin.y;
    if (CGRectContainsPoint(bottomRightRect, point))
        return DJCropViewOverlayEdgeBottomRight;
    
    //Check for edges
    //top
    CGRect topRect = (CGRect){frame.origin, {CGRectGetWidth(frame), 44.0f}};
    
    if (CGRectContainsPoint(topRect, point))
        return DJCropViewOverlayEdgeTop;
    
    //bottom
    CGRect bottomRect = topRect;
    bottomRect.origin.y = CGRectGetMaxY(frame) - 44.0f;
    if (CGRectContainsPoint(bottomRect, point))
        return DJCropViewOverlayEdgeBottom;
    
    //left
    CGRect leftRect = (CGRect){frame.origin, {44.0f, CGRectGetHeight(frame)}};
    if (CGRectContainsPoint(leftRect, point))
        return DJCropViewOverlayEdgeLeft;
    
    //right
    CGRect rightRect = leftRect;
    rightRect.origin.x = CGRectGetMaxX(frame) - 44.0f;
    
    if (CGRectContainsPoint(rightRect, point))
        return DJCropViewOverlayEdgeRight;
    
    return DJCropViewOverlayEdgeNone;
}


#pragma mark - Gesture Recognizer -
- (void)gridPanGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [self startEditing];
        self.panOriginPoint = point;
        self.cropOriginFrame = self.cropBoxFrame;
        self.tappedEdge = [self cropEdgeForPoint:self.panOriginPoint];
    }
    
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
//        [self startResetTimer];
        
        NSLog(@"11");
    [self updateCropBoxFrameWithGesturePoint:point];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer != self.gridPanGestureRecognizer)
        return YES;
    
    CGPoint tapPoint = [gestureRecognizer locationInView:self];
    
    CGRect frame = self.cropView.frame;
    CGRect innerFrame = CGRectInset(frame, 22.0f, 22.0f);
    CGRect outerFrame = CGRectInset(frame, -22.0f, -22.0f);
    
    if (CGRectContainsPoint(innerFrame, tapPoint) || !CGRectContainsPoint(outerFrame, tapPoint))
        return NO;
    
    return YES;
}

//update cropBox frame
- (void)updateCropBoxFrameWithGesturePoint:(CGPoint)point
{
    CGRect frame = self.cropBoxFrame;
    CGRect originFrame = self.cropOriginFrame;
    CGRect contentFrame = self.contentBounds;
    
    point.x = MAX(contentFrame.origin.x, point.x);
    point.y = MAX(contentFrame.origin.y, point.y);
    
    //The delta between where we first tapped, and where our finger is now
    CGFloat xDelta = ceilf(point.x - self.panOriginPoint.x);
    CGFloat yDelta = ceilf(point.y - self.panOriginPoint.y);
    
    //Current aspect ratio of the crop box in case we need to clamp it
    CGFloat aspectRatio = (originFrame.size.width / originFrame.size.height);
    
    BOOL aspectHorizontal = NO, aspectVertical = NO;
    
    switch (self.tappedEdge) {
        case DJCropViewOverlayEdgeLeft:
            if (self.aspectLockEnabled) {
                aspectHorizontal = YES;
                xDelta = MAX(xDelta, 0);
                CGPoint scaleOrigin = (CGPoint){CGRectGetMaxX(originFrame), CGRectGetMidY(originFrame)};
                frame.size.height = frame.size.width / aspectRatio;
                frame.origin.y = scaleOrigin.y - (frame.size.height * 0.5f);
            }
            
            frame.origin.x   = originFrame.origin.x + xDelta;
            frame.size.width = originFrame.size.width - xDelta;
            break;
        case DJCropViewOverlayEdgeRight:
            if (self.aspectLockEnabled) {
                aspectHorizontal = YES;
                CGPoint scaleOrigin = (CGPoint){CGRectGetMinX(originFrame), CGRectGetMidY(originFrame)};
                frame.size.height = frame.size.width / aspectRatio;
                frame.origin.y = scaleOrigin.y - (frame.size.height * 0.5f);
                frame.size.width = originFrame.size.width + xDelta;
                frame.size.width = MIN(frame.size.width, contentFrame.size.height * aspectRatio);
            }
            else {
                frame.size.width = originFrame.size.width + xDelta;
            }
            
            break;
        case DJCropViewOverlayEdgeBottom:
            if (self.aspectLockEnabled) {
                aspectVertical = YES;
                CGPoint scaleOrigin = (CGPoint){CGRectGetMidX(originFrame), CGRectGetMinY(originFrame)};
                frame.size.width = frame.size.height * aspectRatio;
                frame.origin.x = scaleOrigin.x - (frame.size.width * 0.5f);
                frame.size.height = originFrame.size.height + yDelta;
                frame.size.height = MIN(frame.size.height, contentFrame.size.width / aspectRatio);
            }
            else {
                frame.size.height = originFrame.size.height + yDelta;
            }
            break;
        case DJCropViewOverlayEdgeTop:
            if (self.aspectLockEnabled) {
                aspectVertical = YES;
                yDelta = MAX(0,yDelta);
                CGPoint scaleOrigin = (CGPoint){CGRectGetMidX(originFrame), CGRectGetMaxY(originFrame)};
                frame.size.width = frame.size.height * aspectRatio;
                frame.origin.x = scaleOrigin.x - (frame.size.width * 0.5f);
                frame.origin.y    = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            else {
                frame.origin.y    = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            break;
        case DJCropViewOverlayEdgeTopLeft:
            if (self.aspectLockEnabled) {
                xDelta = MAX(xDelta, 0);
                yDelta = MAX(yDelta, 0);
                
                CGPoint distance;
                distance.x = 1.0f - (xDelta / CGRectGetWidth(originFrame));
                distance.y = 1.0f - (yDelta / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                frame.origin.x = originFrame.origin.x + (CGRectGetWidth(originFrame) - frame.size.width);
                frame.origin.y = originFrame.origin.y + (CGRectGetHeight(originFrame) - frame.size.height);
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.origin.x   = originFrame.origin.x + xDelta;
                frame.size.width = originFrame.size.width - xDelta;
                frame.origin.y   = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            break;
        case DJCropViewOverlayEdgeTopRight:
            if (self.aspectLockEnabled) {
                xDelta = MAX(xDelta, 0);
                yDelta = MAX(yDelta, 0);
                
                CGPoint distance;
                distance.x = 1.0f - ((-xDelta) / CGRectGetWidth(originFrame));
                distance.y = 1.0f - ((yDelta) / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                scale = MIN(1.0f, scale);
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                frame.origin.y = CGRectGetMaxY(originFrame) - frame.size.height;
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.size.width  = originFrame.size.width + xDelta;
                frame.origin.y    = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            break;
        case DJCropViewOverlayEdgeBottomLeft:
            if (self.aspectLockEnabled) {
                CGPoint distance;
                distance.x = 1.0f - (xDelta / CGRectGetWidth(originFrame));
                distance.y = 1.0f - (-yDelta / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                frame.origin.x = CGRectGetMaxX(originFrame) - frame.size.width;
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.size.height = originFrame.size.height + yDelta;
                frame.origin.x    = originFrame.origin.x + xDelta;
                frame.size.width  = originFrame.size.width - xDelta;
            }
            break;
        case DJCropViewOverlayEdgeBottomRight:
            if (self.aspectLockEnabled) {
                
                CGPoint distance;
                distance.x = 1.0f - ((-1 * xDelta) / CGRectGetWidth(originFrame));
                distance.y = 1.0f - ((-1 * yDelta) / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.size.height = originFrame.size.height + yDelta;
                frame.size.width = originFrame.size.width + xDelta;
            }
            break;
        case DJCropViewOverlayEdgeNone: break;
    }
    
    //Work out the limits the box may be scaled before it starts to overlap itself
    CGSize minSize = CGSizeZero;
    minSize.width = kTOCropViewMinimumBoxSize;
    minSize.height = kTOCropViewMinimumBoxSize;
    
    CGSize maxSize = CGSizeZero;
    maxSize.width = CGRectGetWidth(contentFrame);
    maxSize.height = CGRectGetHeight(contentFrame);
    
    //clamp the box to ensure it doesn't go beyond the bounds we've set
    if (self.aspectLockEnabled && aspectHorizontal) {
        maxSize.height = contentFrame.size.width / aspectRatio;
        minSize.width = kTOCropViewMinimumBoxSize * aspectRatio;
    }
    
    if (self.aspectLockEnabled && aspectVertical) {
        maxSize.width = contentFrame.size.height * aspectRatio;
        minSize.height = kTOCropViewMinimumBoxSize / aspectRatio;
    }
    
    //Clamp the minimum size
    frame.size.width  = MAX(frame.size.width, minSize.width);
    frame.size.height = MAX(frame.size.height, minSize.height);
    
    //Clamp the maximum size
    frame.size.width  = MIN(frame.size.width, maxSize.width);
    frame.size.height = MIN(frame.size.height, maxSize.height);
    
    frame.origin.x = MAX(frame.origin.x, CGRectGetMinX(contentFrame));
    frame.origin.x = MIN(frame.origin.x, CGRectGetMaxX(contentFrame) - minSize.width);
    
    frame.origin.y = MAX(frame.origin.y, CGRectGetMinY(contentFrame));
    frame.origin.y = MIN(frame.origin.y, CGRectGetMaxY(contentFrame) - minSize.height);
    
    self.cropBoxFrame = frame;
    NSLog(@"%@",[NSValue valueWithCGRect:self.cropBoxFrame]);
}

- (CGRect)contentBounds
{
    
    CGRect contentRect = CGRectZero;
    contentRect.origin.x = kTOCropViewPadding + self.cropRegionInsets.left;
    contentRect.origin.y = kTOCropViewPadding + self.cropRegionInsets.top;
    contentRect.size.width = CGRectGetWidth(self.bounds) - ((kTOCropViewPadding * 2) + self.cropRegionInsets.left + self.cropRegionInsets.right);
    contentRect.size.height = CGRectGetHeight(self.bounds) - ((kTOCropViewPadding * 2) + self.cropRegionInsets.top + self.cropRegionInsets.bottom);
    return contentRect;
}

- (void)setCropBoxFrame:(CGRect)cropBoxFrame{
    
    _cropBoxFrame = cropBoxFrame;
    self.cropView.frame = _cropBoxFrame;
    
    self.foregroundContainerView.frame = _cropBoxFrame; //set the clipping view to match the new rect
    self.cropView.frame = _cropBoxFrame; //set the new overlay view to match the same region
    
    
    [self matchForegroundToBackground];
}


- (void)matchForegroundToBackground
{
    //scrollView --> backgroundContainerView
    //backgroundContainerView内图标 --> self.foregroundContainerView
    self.foregroundImageView.frame = [self.backgroundContainerView.superview convertRect:self.backgroundContainerView.frame toView:self.foregroundContainerView];
    
}

#pragma mark - private method

//crop boxframe
- (CGRect)croppedImageFrame{
    
    CGRect frame = CGRectZero;
    frame = self.cropBoxFrame;
    return frame;
}

//crop image
- (UIImage *)croppedImage{
    
    //convert the frame
    CGRect cropframe = [self convertRect:self.cropBoxFrame toView:self.backgroundContainerView];
    
    
    UIImage *image = [self.image cropImageWithRect:cropframe];
    return image;
}

#pragma mark - view layout

- (void)didMoveToSuperview{
    
    [super didMoveToSuperview];
    [self layoutInitalImage];
    
}

- (void)layoutInitalImage{
    
    //image handle
    CGSize imageSize = self.image.size;
    self.scrollView.contentSize = imageSize;
    NSLog(@"scrollView.contentSize--->%@",[NSValue valueWithCGSize:imageSize]);
    [self matchForegroundToBackground];
}

#pragma mark - scollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self matchForegroundToBackground];
}



@end
