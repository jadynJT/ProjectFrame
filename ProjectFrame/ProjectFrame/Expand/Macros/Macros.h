//
//  Macros.h
//  NLCommonKit
//
//  Created by libz on 15/4/3.
//  Copyright (c) 2015年 Nenglong. All rights reserved.
//

#ifndef NLCommonKit_Macros_h

#define NL_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define NL_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define NL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define NL_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define NL_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/*=================================常规=================================*/

// data转字典
#define JSON_TO_DICT(data) [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]

// NSUserDefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

// 加载本名的Nib文件
#define SELF_NIB ([[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject])

// 设置UIApplication
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kMainKeyWindow [[UIApplication sharedApplication] keyWindow]
#define kRootViewController [[[UIApplication sharedApplication] keyWindow] rootViewController]


/*=================================UI=================================*/
// 字体
#define systemFont(font) ([UIFont systemFontOfSize:font])
// 加粗字体
#define boldSystemFont(font) ([UIFont boldSystemFontOfSize:font])

// 颜色
#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

// 16进制颜色
#define HEXRGB(c)  [UIColor colorWithRed:(((c)>>16)&0xFF)/255.0f green:(((c)>>8)&0xFF)/255.0f blue:((c)&0xFF)/255.0f alpha:1]
#define HEXRGBA(c) [UIColor colorWithRed:(((c)>>24)&0xFF)/255.0f green:(((c)>>16)&0xFF)/255.0f blue:(((c)>>8)&0xFF)/255.0f alpha:((c)&0xFF)/255.0f]

// 状态栏高度
#define STATUS_BAR_HEIGHT 20.0
// 导航栏高度
#define NAVBAR_HEIGHT     44.0
// 状态栏高度 + 导航栏高度
#define STATUS_NAV_HEIGHT 64.0
// tabBar高度
#define TABBAR_HEIGHT     49.0


/*=================================尺寸(适配)=================================*/

// 当前视图控制器的视图的size
#define VIEW_SIZE (self.view.frame.size)

// 设置屏幕宽、高
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


/*=================================系统=================================*/

// 设置app信息：名称、版本、ID
#define APP_NAME        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_ID          [[NSBundle mainBundle] bundleIdentifier]

// 判断是否为iPhone4-5/iPhone6/plus
#define IS_IPHONE4_5    (SCREEN_WIDTH==320)
#define IS_IPHONE6      (SCREEN_WIDTH==375)
#define IS_IPHONE6_PLUS (SCREEN_WIDTH==414)

// iOS系统版本
#define iOS_9x [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f

#define iOS_8x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)

#define iOS_7x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)

// 判断是否为模拟器
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)


/*=================================Debug Function=================================*/

// 重写NSLog,Debug模式下可以 打印日志 和 当前所在的行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/*=================================Weak/Strong object=================================*/

#define Weak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define Strong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define Strong(weakVar, _var) Strong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define Weak_(var)   Weak(var, weak_##var);
#define Strong_(var) Strong(weak_##var, _##var);

/** defines a weak `self` named `weakSelf` */
//self的 弱应用名字 为weakSelf
#define WeakSelf      Weak(self, weakSelf);
/** defines a strong `self` named `_self` from `weakSelf` */
#define StrongSelf    Strong(weakSelf, _self);

#endif
