//
//  AppDelegate+RootController.h
//  ProjectFrame
//
//  Created by JS1-ZJT on 17/1/19.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootController)

/**
 *  设置导航栏、标签栏等控件的定制样式
 */
- (void)customizeAppearance;

/**
 *  是否需要显示新功能介绍页
 */
- (BOOL)launchScreenIntroPage:(void(^)())dismissBlock;

@end
