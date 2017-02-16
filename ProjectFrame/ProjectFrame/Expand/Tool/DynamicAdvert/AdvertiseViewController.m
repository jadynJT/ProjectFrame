//
//  AdvertiseViewController.m
//  ProjectFrame
//
//  Created by Mac on 17/2/14.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "AdvertiseViewController.h"

@implementation AdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击进入广告链接";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

@end
