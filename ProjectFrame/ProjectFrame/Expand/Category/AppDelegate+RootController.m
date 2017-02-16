//
//  AppDelegate+RootController.m
//  ProjectFrame
//
//  Created by JS1-ZJT on 17/1/19.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "UserGuideIntroController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate (RootController)

- (void)customizeAppearance
{
    // 状态栏风格
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 定制标签栏的背景和着色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    
    // 定制标签栏的title
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(65, 85, 129), NSFontAttributeName : [UIFont systemFontOfSize:11.0]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(3, 160, 235), NSFontAttributeName : [UIFont systemFontOfSize:11.0]} forState:UIControlStateSelected];
    
    // 设置所有导航栏的背景
    [[UINavigationBar appearance] setBarTintColor:RGB(3, 160, 235)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];   //目的是去掉导航条背景下方的黑色阴影线
    
    // 定制导航栏中的UIBarButtonItems的文本样式
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
    
    // 设置导航条上的返回按钮样式
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_bar_back_button_v3"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_bar_back_button_v3"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -100) forBarMetrics:UIBarMetricsDefault]; //为了隐藏系统默认的“返回”字样
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -100) forBarMetrics:UIBarMetricsCompact];
}

- (BOOL)launchScreenIntroPage:(void (^)())dismissBlock
{
    // 判断是否需要显示新功能介绍页
    if ([UserGuideIntroController firstLaunchAfterNewVersionInstalled])
    {
        NSArray *introImageNames = [UserGuideIntroController introImageNamesForCurrentVersion];
        if (introImageNames && introImageNames.count > 0)
        {
            // 显示新功能介绍页
            [UserGuideIntroController showWithImages:introImageNames dismissBlock:^{
                dismissBlock();
            }];
        }
        else
        {
            dismissBlock();
        }
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
