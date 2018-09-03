//
//  QSAKitPromptView.m
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import "QSAKitPromptView1.h"

@interface QSAKitPromptView1 ()

@end

@implementation QSAKitPromptView1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)sharedInstance {
    static QSAKitPromptView1 *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QSAKitPromptView1 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        sharedInstance.defaultMaxWidth = 100.f;
        sharedInstance.defaultFont = [UIFont systemFontOfSize:14.0f];
        sharedInstance.defaultBackgroundTransparency = 0.0;
        sharedInstance.defaultBlurEffectStyle            = BlurEffectStyleDark;
        sharedInstance.defaultActivityIndicatorViewStyle = ActivityIndicatorViewStyleWhiteLarge;
    });
    return sharedInstance;
}

+ (void)show {
    QSAKitPromptView1 *view = [QSAKitPromptView1 sharedInstance];
    [view showWithWidth:view.defaultMaxWidth blurEffectStyle:view.defaultBlurEffectStyle activityIndicatorViewStyle:view.defaultActivityIndicatorViewStyle message:nil messageFont:view.defaultFont backgroundTransparency:view.defaultBackgroundTransparency];
}


+ (void)showWithMessage:(NSString *)message {
    QSAKitPromptView1 *view = [QSAKitPromptView1 sharedInstance];
    [view showWithWidth:view.defaultMaxWidth blurEffectStyle:view.defaultBlurEffectStyle activityIndicatorViewStyle:view.defaultActivityIndicatorViewStyle message:message messageFont:view.defaultFont backgroundTransparency:view.defaultBackgroundTransparency];
}

+ (void)showWithWidth:(CGFloat)width blurEffectStyle:(BlurEffectStyle)blurEffectStyle activityIndicatorViewStyle:(ActivityIndicatorViewStyle)activityIndicatorViewStyle message:(NSString *)message messageFont:(UIFont *)font backgroundTransparency:(CGFloat)backgroundTransparency {
    [[QSAKitPromptView1 sharedInstance] showWithWidth:width blurEffectStyle:blurEffectStyle activityIndicatorViewStyle:activityIndicatorViewStyle message:message messageFont:font backgroundTransparency:backgroundTransparency];
}


- (void)showWithWidth:(CGFloat)width blurEffectStyle:(BlurEffectStyle)blurEffectStyle activityIndicatorViewStyle:(ActivityIndicatorViewStyle)activityIndicatorViewStyle message:(NSString *)message messageFont:(UIFont *)font backgroundTransparency:(CGFloat)backgroundTransparency {
    CGFloat height = width * 1;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backView.layer.cornerRadius = 8.0f;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor clearColor];
    backView.center = self.center;
    [self addSubview:backView];
    
    UIBlurEffect *blurEffect;
    if (blurEffectStyle == BlurEffectStyleLight) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else  {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    UIVisualEffectView *backVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    backVisualEffectView.frame = CGRectMake(0, 0, width, height);
    [backView addSubview:backVisualEffectView];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *subVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    subVisualEffectView.frame = CGRectMake(0, 0, width, height);
    [backVisualEffectView.contentView addSubview:subVisualEffectView];
    
    UIActivityIndicatorView *activityIndicatorView;
    if (activityIndicatorViewStyle == ActivityIndicatorViewStyleWhiteLarge) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    } else  {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    if (message != nil) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, height * 0.5, width - 24, height * 0.5)];
        messageLabel.textAlignment = 1;
        messageLabel.numberOfLines = 2;
        [messageLabel setFont:font];
        messageLabel.text = message;
        [subVisualEffectView.contentView addSubview:messageLabel];
        
        activityIndicatorView.frame = CGRectMake(0, 0, width, height * 0.7);
    } else {
        activityIndicatorView.frame = CGRectMake(0, 0, width, height);
    }
    
    activityIndicatorView.backgroundColor = [UIColor clearColor];
    activityIndicatorView.color = [UIColor lightGrayColor];
    [subVisualEffectView.contentView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:backgroundTransparency];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


+ (void)disappear {
    [[QSAKitPromptView1 sharedInstance] disappear];
}

- (void)disappear {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

@end
