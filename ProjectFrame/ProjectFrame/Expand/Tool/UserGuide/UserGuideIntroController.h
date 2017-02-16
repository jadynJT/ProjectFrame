//
//  NLLaunchScreenIntroController.h
//  yxt_kinder
//
//  Created by libz on 17/1/3.
//  Copyright © 2017年 Nenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGuideIntroController : UIViewController


/*
 * 判断是否需要显示新功能介绍页
 *
 */
+ (BOOL)firstLaunchAfterNewVersionInstalled;


/*
 * 获取plist文件中的图片数组
 *
 */
+ (NSArray *)introImageNamesForCurrentVersion;


/*
 * 显示新功能介绍页
 * @prama images       图片数组
 * @prama dismissBlock 退出的block
 */
+ (void)showWithImages:(NSArray<NSString *> *)images dismissBlock:(void (^)(void))dismissBlock;

@end
