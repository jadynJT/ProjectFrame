//
//  NLLaunchScreenIntroController.m
//  yxt_kinder
//
//  Created by libz on 17/1/3.
//  Copyright © 2017年 Nenglong. All rights reserved.
//

#import "UserGuideIntroController.h"
#import "UserGuideIntroCell.h"

static NSString * const cellIdentifier = @"CellIdentifier";

@interface UserGuideIntroController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray<NSString *> *introImages;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end

@implementation UserGuideIntroController

+ (BOOL)firstLaunchAfterNewVersionInstalled {
    NSString *version = APP_VERSION;
    NSString *versionCached = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"];
    if (NSOrderedDescending == [version compare:versionCached]) {
        return YES;
    }
    return NO;
}

+ (NSArray *)introImageNamesForCurrentVersion {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserGuide" ofType:@"plist"];
    if (!plistPath) return nil;
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (!dict)  return nil;
    
    NSDictionary *versionDict = [dict objectForKey:APP_VERSION];
    if (!versionDict)  return nil;
    
    return [versionDict objectForKey:@"IntroImages"];
}

- (instancetype)initWithImages:(NSArray<NSString *> *)images dismissBlock:(void (^)(void))dismissBlock {
    self = [super init];
    if (self) {
        self.introImages = images;
        self.dismissBlock = dismissBlock;
    }
    return self;
}

+ (void)showWithImages:(NSArray<NSString *> *)images dismissBlock:(void (^)(void))dismissBlock {
    UserGuideIntroController *introController = [[UserGuideIntroController alloc] initWithImages:images dismissBlock:dismissBlock];
    kAppDelegate.window.rootViewController = introController;
    [kAppDelegate.window makeKeyAndVisible];
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UserGuideIntroCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.numberOfPages = self.introImages.count;
    }
    return _pageControl;
}

#pragma mark ----加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubviews];
}

//配置子视图
- (void)configureSubviews {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.introImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserGuideIntroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageName = self.introImages[indexPath.item];
    
    if (indexPath.item < self.introImages.count - 1) {
        cell.dismissButton.hidden = YES;
    }
    else {
        cell.dismissButton.hidden = NO;
        
        WeakSelf;
        cell.dismissButtonAction = ^{
            [[NSUserDefaults standardUserDefaults] setObject:APP_VERSION forKey:@"AppVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (weakSelf.dismissBlock) {
                weakSelf.dismissBlock();
            }
        };
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    self.pageControl.currentPage = index;
}

#pragma mark - 禁止横屏
- (BOOL)shouldAutorotate {
    return NO;
}

@end
