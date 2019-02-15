//
//  DJCropViewController.m
//  DJCrop
//
//  Created by dingjia on 16/4/13.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "DJCropViewController.h"
#import "DJContainerView.h"
#import "DJCropToolbar.h"

@interface DJCropViewController ()
@property (nonatomic, strong) DJContainerView *containerView;
@property (nonatomic, strong) DJCropToolbar *cropBar;
@property (nonatomic, copy) CropCompletion completion;
@end

@implementation DJCropViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.containerView];
    
    self.cropBar = [[DJCropToolbar alloc] initWithFrame:CGRectZero];
    self.cropBar.frame = [self frameForToolBar];
    [self.view addSubview:self.cropBar];
    
    
    [self.cropBar cropImageWithBlock:^{
        if (self.completion) {
            self.completion(self.containerView.croppedImage);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public

- (void)cropImageWithCompletion:(CropCompletion)completion {
    self.completion = completion;
}

#pragma mark - private

- (CGRect)frameForToolBar {
    CGRect frame = self.cropBar.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = CGRectGetHeight(self.view.bounds) - 44.0f;
    frame.size.width = CGRectGetWidth(self.view.bounds);
    frame.size.height = 44.0f;
    return frame;
}


#pragma mark - getter/setter
- (DJContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[DJContainerView alloc] initWithImage:[UIImage imageNamed:@"demo.png"] andFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-44)];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
