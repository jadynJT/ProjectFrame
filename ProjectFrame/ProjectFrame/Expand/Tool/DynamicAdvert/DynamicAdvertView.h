//
//  DynamicAdvertView.h
//  ProjectFrame
//
//  Created by Mac on 17/2/11.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicAdvertView : UIView

/*
 * 显示广告页
 * @prama imagePath     广告图片地址
 * @prama dismissBlock  结束广告的block
 * @prama clickAdBlock  点击广告的block
 */
+ (void)showWithImagePath:(NSString *)imagePath dismissBlock:(void (^)())dismissBlock clickAdBlock:(void(^)())clickAdBlock;

@end
