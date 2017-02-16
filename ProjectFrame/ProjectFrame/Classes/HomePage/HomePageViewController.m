//
//  HomePageViewController.m
//  ProjectFrame
//
//  Created by JS1-ZJT on 17/1/19.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeViewController.h"
#import "CommuntiyViewController.h"
#import "AboutChildViewController.h"
#import "CourseViewController.h"
#import "AboutMeViewController.h"

@interface HomePageViewController ()<UITabBarDelegate>

// 底部的标签栏
@property (nonatomic, strong) UITabBar *bottomTabBar;

// 主页
@property (nonatomic, strong) HomeViewController       *homeViewController;
// 发现
@property (nonatomic, strong) CommuntiyViewController  *communtiyViewController;
// 孩子
@property (nonatomic, strong) AboutChildViewController *aboutChildViewController;
// 课程
@property (nonatomic, strong) CourseViewController     *courseViewController;
// 我
@property (nonatomic, strong) AboutMeViewController    *aboutMeViewController;

//当前TabBar选择的index
@property (nonatomic, assign) NSUInteger currentSelectedTabIndex;

@end

@implementation HomePageViewController

- (UITabBar *)bottomTabBar
{
    if (!_bottomTabBar) {
        _bottomTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50.f, SCREEN_WIDTH, 50.f)];
        _bottomTabBar.delegate = self;
        UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tpo_tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tpo_tab_home_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"tpo_tab_found"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tpo_tab_found_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"学员" image:[[UIImage imageNamed:@"tab_children"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_children_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"课程" image:[[UIImage imageNamed:@"tpo_tab_course"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tpo_tab_course_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *tabBarItem5 = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"tpo_tab_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tpo_tab_user_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        _bottomTabBar.items = @[tabBarItem1, tabBarItem2, tabBarItem3,tabBarItem4, tabBarItem5];
        
        //默认选取第一个Item
        [_bottomTabBar setSelectedItem:tabBarItem1];
    }
    return _bottomTabBar;
}

#pragma mark ----各个分页控制器
- (HomeViewController *)homeViewController
{
    if (!_homeViewController) {
        _homeViewController = [[HomeViewController alloc] init];
        _homeViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bottomTabBar.bounds));;
    }
    return _homeViewController;
}

- (CommuntiyViewController *)communtiyViewController
{
    if (!_communtiyViewController) {
        _communtiyViewController = [[CommuntiyViewController alloc] init];
        _communtiyViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bottomTabBar.bounds));;
    }
    return _communtiyViewController;
}

- (AboutChildViewController *)aboutChildViewController
{
    if (!_aboutChildViewController) {
        _aboutChildViewController = [[AboutChildViewController alloc] init];
        _aboutChildViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bottomTabBar.bounds));;
    }
    return _aboutChildViewController;
}

- (CourseViewController *)courseViewController
{
    if (!_courseViewController) {
        _courseViewController = [[CourseViewController alloc] init];
        _courseViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bottomTabBar.bounds));;
    }
    return _courseViewController;
}

- (AboutMeViewController *)aboutMeViewController
{
    if (!_aboutMeViewController) {
        _aboutMeViewController = [[AboutMeViewController alloc] init];
        _aboutMeViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bottomTabBar.bounds));
    }
    return _aboutMeViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 底部标签栏
    [self.view addSubview:self.bottomTabBar];
    [self.view addSubview:self.homeViewController.view];
    _currentSelectedTabIndex = 0;
}

#pragma mark ----UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger newIndex = [self.bottomTabBar.items indexOfObject:item];
    
    if (newIndex != _currentSelectedTabIndex) {
        _currentSelectedTabIndex = newIndex;
        switch (newIndex) {
            case 0: {
                if ([self.homeViewController.view isDescendantOfView:self.view])
                {//判断view是不是指定视图的子视图
                    [self.view bringSubviewToFront:self.homeViewController.view];
                }else {
                    [self.view addSubview:self.homeViewController.view];
                }
            } break;
            case 1: {
                if ([self.communtiyViewController.view isDescendantOfView:self.view])
                {//判断view是不是指定视图的子视图
                    [self.view bringSubviewToFront:self.communtiyViewController.view];
                }else {
                    [self.view addSubview:self.communtiyViewController.view];
                }
            } break;
            case 2: {
                if ([self.aboutChildViewController.view isDescendantOfView:self.view])
                {//判断view是不是指定视图的子视图
                    [self.view bringSubviewToFront:self.aboutChildViewController.view];
                }else {
                    [self.view addSubview:self.aboutChildViewController.view];
                }
            } break;
            case 3: {
                if ([self.courseViewController.view isDescendantOfView:self.view])
                {//判断view是不是指定视图的子视图
                    [self.view bringSubviewToFront:self.courseViewController.view];
                }else {
                    [self.view addSubview:self.courseViewController.view];
                }
            } break;
            case 4: {
                if ([self.aboutMeViewController.view isDescendantOfView:self.view])
                {//判断view是不是指定视图的子视图
                    [self.view bringSubviewToFront:self.aboutMeViewController.view];
                }else {
                    [self.view addSubview:self.aboutMeViewController.view];
                }
            } break;
        }
    }
}

@end
