//
//  DJCropViewController.m
//  DJCrop
//
//  Created by yoanna on 16/4/13.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "DJCropViewController.h"
#import "DJContainerView.h"
#import "DJCropToolbar.h"
#import "ViewController.h"

@interface DJCropViewController ()

@property (nonatomic,strong) DJContainerView *containerView;
@property (nonatomic,strong) DJCropToolbar *cropBar;
@end

@implementation DJCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.containerView = [[DJContainerView alloc] initWithImage:[UIImage imageNamed:@"demo.png"] andFrame:CGRectMake(0, 64, 375, 667-64-44)];

    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
    
    self.cropBar = [[DJCropToolbar alloc] initWithFrame:CGRectZero];
    self.cropBar.frame = [self frameForToolBar];
    [self.view addSubview:self.cropBar];
    
    
    [self.cropBar cropImageWithBlock:^{
       
        ViewController *viewCtrl = [[ViewController alloc] init];
        viewCtrl.image = self.containerView.croppedImage;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }];
    
    
    
}

- (CGRect)frameForToolBar
{
    CGRect frame = self.cropBar.frame;
 
        frame.origin.x = 0.0f;
        frame.origin.y = CGRectGetHeight(self.view.bounds) - 44.0f;
        frame.size.width = CGRectGetWidth(self.view.bounds);
        frame.size.height = 44.0f;
    
    return frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
