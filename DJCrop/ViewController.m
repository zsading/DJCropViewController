//
//  ViewController.m
//  DJCrop
//
//  Created by yoanna on 16/4/12.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "ViewController.h"
#import "DJCropViewController/DJCropViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *demoImageView;
@property (nonatomic ,strong) DJCropViewController *cropViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.cropViewController cropImageWithCompletion:^(UIImage *cropImage) {
        [self.navigationController popViewControllerAnimated:YES];
        self.demoImageView.image = cropImage;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cropImageAction:(UIButton *)sender {
    [self.navigationController pushViewController:self.cropViewController animated:YES];
}


- (DJCropViewController *)cropViewController {
    if (!_cropViewController) {
        _cropViewController = [[DJCropViewController alloc] init];
    }
    return _cropViewController;
}
@end
