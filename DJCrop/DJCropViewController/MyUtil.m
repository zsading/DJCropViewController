//
//  MyUtil.m
//  thelper
//
//  Created by yoanna on 15/7/23.
//  Copyright (c) 2015年 杭州无届网络科技有限公司. All rights reserved.
//

#import "MyUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

@implementation MyUtil

//按钮
+(UIButton *)createBtnFrame:(CGRect)frame bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    
    if (bgImageName != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }else{
            btn.backgroundColor = [UIColor purpleColor];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

+(UIButton *)createBtnBgImageName:(NSString *)bgImageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (bgImageName != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = [UIColor clearColor];
    }
    
    if (selectedImage != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (title != nil) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    if (titleColor != nil) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (font != nil) {
         btn.titleLabel.font = font;
    }
   
    
    return btn;
}

+(UIButton *)createBtnBgImageName:(NSString *)bgImageName selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (bgImageName != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = [UIColor purpleColor];
    }
    
    if (selectedImage != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
        //[btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+(UILabel *)createLabelTitle:(NSString *)title textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


+(UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];

    label.text = title;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor isCenter:(BOOL)isCenter fontSize:(NSInteger)fontSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (isCenter) {
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.font = [UIFont systemFontOfSize:fontSize];
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

+(UIView *)createAutoView
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

+(NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


+ (NSString *)urlEncode:(NSString *)urlString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)urlString,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}

+ (NSString *)urlDecode:(NSString *)urlString
{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)urlString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


+ (BOOL) isEmpty:(id) str
{
    if (str == nil || [@"" isEqual:str] || [[NSNull null] isEqual:str] || [@"null" isEqualToString:str] || [@"(null)" isEqualToString:str]) {
        return YES;
    }
    return NO;
}

+ (long)getIntervalSinceRestarted
{
//    NSProcessInfo *processInfo = [[NSProcessInfo alloc] init];
//    NSTimeInterval timeInterVal = processInfo.systemUptime;

    long time = [self uptime];
    
    return time;
}

+(long)getCurrentSystime
{
//    return [[NSDate date] timeIntervalSince1970]*1000;
    return CACurrentMediaTime()*1000;
}

+(long long)getCurrentSystimeFrom1970
{
    NSLog(@"++++_____%lf",[[NSDate date] timeIntervalSince1970]);
    return [[NSDate date] timeIntervalSince1970]*1000;
}



+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidthInPx:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat width_px = width*[[UIScreen mainScreen] scale];
    CGFloat height_px = height*[[UIScreen mainScreen] scale];
//    目标像素单位
    CGFloat targetWidth_px = defineWidth;
//    CGFloat targetWidth = targetWidth_px / [[UIScreen mainScreen] scale];
//    若小于1024，则直接返回
    if (width_px<=1024) {
        return sourceImage;
    }
    
//    开始转换
    CGFloat targetHeight_px= (targetWidth_px / width_px * height_px);
//    CGFloat targetHeight = targetHeight_px / [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth_px, targetHeight_px));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth_px,  targetHeight_px)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (time_t)uptime
{
        struct timeval boottime;
        int mib[2] = {CTL_KERN, KERN_BOOTTIME};
        size_t size = sizeof(boottime);
        time_t now;
        time_t uptime = -1;
        (void)time(&now);
        if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
        {
            uptime = now - (boottime.tv_sec);
        }
        
        return uptime*1000;

}

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (BOOL)updateVersion:(float)newVersion
{
    NSString * version =   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([version floatValue] < newVersion) {
        return YES;
    }else{
        return NO;
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error == %@",error);
}




+ (NSAttributedString *)getAttributedPlaceholderWithName:(NSString *)name andWithFontSize:(CGFloat)size
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    
    return attrString;
}

- (void)createNavigationWithTitle:(NSString *)title withLeftImage:(NSString *)imageName
{
    
}

@end

@implementation NSString (MD5)

-(NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]
            ];
}

@end
