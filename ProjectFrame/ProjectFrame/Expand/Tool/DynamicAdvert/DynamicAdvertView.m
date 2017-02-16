//
//  DynamicAdvertView.m
//  ProjectFrame
//
//  Created by Mac on 17/2/11.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "DynamicAdvertView.h"
#import "SDAutoLayout.h"

@interface DynamicAdvertView ()

@property (nonatomic, strong) UIImageView *dynamicImageView;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, copy) void (^clickAdBlock)(void);

@end

@implementation DynamicAdvertView

- (UIImageView *)dynamicImageView
{
    if (!_dynamicImageView)
    {
        self.dynamicImageView = [[UIImageView alloc] init];
        self.dynamicImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.dynamicImageView.layer.masksToBounds = YES;
        self.dynamicImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [self.dynamicImageView addGestureRecognizer:tap];
        [self addSubview:self.dynamicImageView];
    }
    return _dynamicImageView;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.skipButton addTarget:self action:@selector(skipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.dynamicImageView addSubview:self.skipButton];
    }
    return _skipButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];             // 布局
        [self loadDynamicAdvert]; // 加载动态广告
    }
    return self;
}

#pragma mark ----布局
- (void)setUp
{
    self.dynamicImageView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    self.skipButton.sd_layout
    .rightSpaceToView(self.dynamicImageView,15)
    .topSpaceToView(self.dynamicImageView,25)
    .widthIs(65)
    .heightIs(30);
}

#pragma mark ----加载动态广告
- (void)loadDynamicAdvert
{
    _skipButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    _skipButton.layer.cornerRadius = 14.0f;
    
    __block NSInteger timeOut = 6; //倒计时时间
    WeakSelf;
    //GCD计时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer,^{
        if (timeOut <= 0)
        {
            dispatch_source_cancel(_timer); //关闭计时器
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf adDismiss]; //广告页结束动画
            });
        } else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.skipButton setTitle:[NSString stringWithFormat:@"跳过(%ld)", timeOut--] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_timer);
}

+ (void)showWithImagePath:(NSString *)imagePath dismissBlock:(void (^)())dismissBlock clickAdBlock:(void (^)())clickAdBlock
{
    DynamicAdvertView *dynamicAdvertView = [[DynamicAdvertView alloc] initWithFrame:kAppDelegate.window.bounds];
    dynamicAdvertView.dismissBlock = dismissBlock;
    dynamicAdvertView.clickAdBlock = clickAdBlock;
    
    if ([imagePath rangeOfString:@".gif"].location != NSNotFound)
    {
        [dynamicAdvertView playGifImage:imagePath];
    }else
    {
        dynamicAdvertView.dynamicImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    [kAppDelegate.window addSubview:dynamicAdvertView];
}

#pragma mark ----播放Gif动画
- (void)playGifImage:(NSString *)imgPath
{
    //用WebView实现动画效果
    NSData *gifData = [NSData dataWithContentsOfFile:imgPath];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.frame];
    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = YES;
    webView.scrollView.scrollEnabled = NO;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
    [self.dynamicImageView addSubview:webView];
    [self.dynamicImageView bringSubviewToFront:self.skipButton];
}

#pragma mark ----广告页结束动画
- (void)adDismiss
{
    WeakSelf;
    dispatch_source_cancel(_timer);
    [UIView animateWithDuration:0.3f animations:^{
        
        weakSelf.dynamicImageView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        weakSelf.dismissBlock();
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark ----Action
- (void)skipButtonTapped:(UIButton *)sender
{
    [self adDismiss]; //广告页结束动画
}

- (void)pushToAd
{
    [self adDismiss]; //广告页结束动画
    self.clickAdBlock();
}

@end
