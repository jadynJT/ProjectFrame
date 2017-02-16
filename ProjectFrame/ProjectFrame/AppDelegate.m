//
//  AppDelegate.m
//  ProjectFrame
//
//  Created by JS1-ZJT on 17/1/19.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "DynamicAdvertView.h"
#import "HomePageViewController.h"
#import "AdvertiseViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navHomePageVC;
@property (nonatomic, strong) NSString *localADImgPath; // 本地广告图片地址
@property (nonatomic, assign) BOOL isDelOldPath;        // 删除旧的广告地址

@end

@implementation AppDelegate

- (UINavigationController *)navHomePageVC {
    if (!_navHomePageVC) {
        HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
        self.navHomePageVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    }
    return _navHomePageVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self handleAppEntryWithOptions:launchOptions]; //APP启动逻辑
    return YES;
}

#pragma mark ----APP启动逻辑
- (void)handleAppEntryWithOptions:(NSDictionary *)launchOptions
{
    WeakSelf;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navHomePageVC;
    [self.window makeKeyAndVisible];
    
    [self customizeAppearance];          // 设置导航栏、标签栏等控件的定制样式
    [NSThread sleepForTimeInterval:2.0]; // 进来先让启动页沉睡 2 秒钟
    
    // 是否需要显示新功能介绍页
    BOOL isFirstLaunch = [self launchScreenIntroPage:^{
        weakSelf.window.rootViewController = weakSelf.navHomePageVC; // 进入App
        [weakSelf.window makeKeyAndVisible];
    }];
    
    //非第一次进入App时加载广告
    if (!isFirstLaunch)
    {
        // 显示广告页
        [self showDynamicLaunchImage];
    }
    
    //    http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg
    //    http://userimage7.360doc.com/16/0126/12/343465_201601261209400906760747.jpg
    // 异步获取动态广告页图片
    [self fetchDynamicLaunchImageInBackground:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"];
}

#pragma mark - 获取后台配置的动态广告页图片
static NSString * DynamicLaunchImageSavePath(NSString *imageName) {
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), imageName];
}

- (void)fetchDynamicLaunchImageInBackground:(NSString *)imgPath
{
    NSString *savePath = DynamicLaunchImageSavePath(imgPath.lastPathComponent);
    
    if (imgPath.length > 0)
    {
        if ([imgPath rangeOfString:@"http"].location != NSNotFound)
        {
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:savePath];
            if (!isExist)
            {// 本地不存在该图片则下载
                
                // 标记要删除旧图片，再下载和保存新图片
                self.isDelOldPath = YES;
                
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                
                [manager setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
                    return [NSURL fileURLWithPath:savePath];
                }];
                
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imgPath]] progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    return [NSURL fileURLWithPath:savePath];
                    
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    
                    //用NSUserDefault保存图片名称
                    [USER_DEFAULT setObject:imgPath.lastPathComponent forKey:@"imgName"];
                    [USER_DEFAULT synchronize];
                    
                    NSLog(@"dynamic launch image saved at: %@", filePath);
                }];
                
                [downloadTask resume];
            }
        }else
        {
           self.localADImgPath = imgPath; 
        }
    }
}

- (void)showDynamicLaunchImage
{
    // 如果在本地拿到了，则先显示动态广告页，若干秒后再自动进入App主界面，用户也可以点击“跳过”按钮，快速进入App主界面
    // 如果拿不到，直接进入App主界面
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *savePath = DynamicLaunchImageSavePath([USER_DEFAULT objectForKey:@"imgName"]);
        
        if (self.localADImgPath.length > 0 || [[NSFileManager defaultManager] fileExistsAtPath:savePath])
        {
            NSString *imgPath = nil;
            if (self.localADImgPath.length > 0)
            {
                imgPath = self.localADImgPath;
            }else
            {
                imgPath = savePath;
            }
            [DynamicAdvertView showWithImagePath:imgPath dismissBlock:^{
                if (weakSelf.isDelOldPath)
                { // 删除旧图片
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath])
                    {
                        [fileManager removeItemAtPath:savePath error:nil];
                    }
                }
            } clickAdBlock:^{
                AdvertiseViewController *aDvertiseVC = [[AdvertiseViewController alloc] init];
                [self.navHomePageVC pushViewController:aDvertiseVC animated:YES];
            }];
        }else
        {
            weakSelf.window.rootViewController = weakSelf.navHomePageVC;
            [weakSelf.window makeKeyAndVisible];
        }
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
