//
//  LaunchScreenIntroCollectionViewCell.h
//  yxt_kinder
//
//  Created by libz on 17/1/3.
//  Copyright © 2017年 Nenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGuideIntroCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, copy) void (^dismissButtonAction)(void);

@end
