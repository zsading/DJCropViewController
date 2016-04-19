//
//  MyUtil.h
//  thelper
//
//  Created by yoanna on 15/7/23.
//  Copyright (c) 2015年 杭州无届网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UIKit/UIKit.h>

@class LswuyouBaseResponse;
@interface MyUtil : NSObject <CLLocationManagerDelegate>


#pragma mark - 通用
+ (BOOL) isEmpty:(id) str;


#pragma mark - 控件相关

/**非自动布局的button*/
+(UIButton *)createBtnFrame:(CGRect)frame bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;

/**自动布局的button*/
+(UIButton *)createBtnBgImageName:(NSString *)bgImageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor;

/**自动布局的button简易版*/
+(UIButton *)createBtnBgImageName:(NSString *)bgImageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action;

/**自动布局的label*/
+(UILabel *)createLabelTitle:(NSString *)title textColor:(UIColor *)textColor;


/**非自动布局的label*/
+(UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor;


/**自动布局的UIView*/
+(UIView *)createAutoView;


/**非自动布局的Label*/
+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor isCenter:(BOOL)isCenter fontSize:(NSInteger)fontSize;


#pragma mark - 表情相关
+ (NSString *)urlEncode:(NSString *)urlString;
+ (NSString *)urlDecode:(NSString *)urlString;


#pragma mark - show alert text
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message;
+ (void)showErrorResponse:(LswuyouBaseResponse *)response;

#pragma mark - 设备相关
+ (NSString *)getDeviceName;


#pragma mark - 时间戳相关
+ (long)getIntervalSinceRestarted;

#pragma make - 返回自定义纯色image
+(UIImage *)imageWithColor:(UIColor *)color;

//设置placeholder 的颜色和大小
+ (NSAttributedString *)getAttributedPlaceholderWithName:(NSString *)name andWithFontSize:(CGFloat)size;
//设置到导航栏
- (void)createNavigationWithTitle:(NSString *)title withLeftImage:(NSString *)imageName;

/**
 *  获取系统时间
 *
 *  @return 返回系统时间
 */
+(long)getCurrentSystime;

/**
 *  获取当前系统时间，从1970
 *
 *  @return
 */
+(long long)getCurrentSystimeFrom1970;

/**
 *  压缩图片
 *
 *  @param sourceImage 原图
 *  @param defineWidth 限定的宽度(像素)
 *
 *  @return 压缩后的image
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidthInPx:(CGFloat)defineWidth;

#pragma mark - 更新版本
+ (BOOL)updateVersion:(float)newVersion;

#pragma mark - SVProgressHUD警告框

//警告 可以设置背景和前景颜色
+ (void)showMsgWithStr:(NSString *)str andBackgroundColor:(UIColor *)backGroundColor andForegroundColor:(UIColor *)foreGroundColor andContinueTime:(NSTimeInterval)time;
//成功 可以设置背景和前景颜色
+ (void)showSuccesssMsgWithStr:(NSString *)str andBackgroundColor:(UIColor *)backGroundColor andForegroundColor:(UIColor *)foreGroundColor andContinueTime:(NSTimeInterval)time;
//失败 可以设置背景和前景颜色
+ (void)showFailMsgWithStr:(NSString *)str andBackgroundColor:(UIColor *)backGroundColor andForegroundColor:(UIColor *)foreGroundColor andContinueTime:(NSTimeInterval)time;

//警告 黑色背景 白色文字
+ (void)showMessageWithStr:(NSString *)str andContinueTime:(NSTimeInterval)time;
//成功 黑色背景 白色文字
+ (void)showSuccessMsg:(NSString *)str andContinueTime:(NSTimeInterval)time;

//失败 黑色背景 白色文字
+ (void)showFailMsg:(NSString *)str andContinueTime:(NSTimeInterval)time;
//菊花转
+ (void)showLoadingWithStatus:(NSString *)msg;

#pragma mark - SVProgressHUD进度框
+ (void)showProgressWithStartValue:(float)startValue andEndValue:(float)endValue andStatusString:(NSString *)statusStr;
#pragma mark - SVProgressHUD Loading框
+ (void)showLoadingWithStartValue:(float)startValue andEndValue:(float)endValue andStatusString:(NSString *)statusStr;

@end

@interface NSString (MD5)
-(NSString *)md5;
@end

