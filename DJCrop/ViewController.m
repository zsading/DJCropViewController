//
//  ViewController.m
//  DJCrop
//
//  Created by yoanna on 16/4/12.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()



@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.center = self.view.center;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
