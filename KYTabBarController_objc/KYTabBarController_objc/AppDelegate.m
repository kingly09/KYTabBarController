//
//  AppDelegate.m
//  KYTabBarController_objc
//
//  Created by kingly on 2017/6/21.
//  Copyright © 2017年 KYTabBarController Software https://github.com/kingly09/KYTabBarController  by kingly inc.  

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE. All rights reserved.
//

#import "AppDelegate.h"

#import "KYTabBarControllerConfig.h"
#import "KYPlusButtonSubclass.h"

@interface AppDelegate ()<UITabBarControllerDelegate, KYTabBarControllerDelegate>

@end

@implementation AppDelegate
#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [KYPlusButtonSubclass registerPlusButton];
    KYTabBarControllerConfig *tabBarControllerConfig = [[KYTabBarControllerConfig alloc] init];
    KYTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
    [tabBarController setViewDidLayoutSubViewsBlock:^(KYTabBarController *aTabBarController) {
        UIViewController *viewController = aTabBarController.viewControllers[0];
        UIView *tabBadgePointView0 = [UIView ky_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
        [viewController.tabBarItem.ky_tabButton ky_setTabBadgePointView:tabBadgePointView0];
        [viewController ky_showTabBadgePoint];
        
        UIView *tabBadgePointView1 = [UIView ky_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
        [aTabBarController.viewControllers[1] ky_setTabBadgePointView:tabBadgePointView1];
        [aTabBarController.viewControllers[1] ky_showTabBadgePoint];
        
        UIView *tabBadgePointView2 = [UIView ky_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
        [aTabBarController.viewControllers[2] ky_setTabBadgePointView:tabBadgePointView2];
        [aTabBarController.viewControllers[2] ky_showTabBadgePoint];
        
        [aTabBarController.viewControllers[3] ky_showTabBadgePoint];
        
        //添加提示动画，引导用户点击
        [self addScaleAnimationOnView:aTabBarController.viewControllers[3].ky_tabButton.ky_tabImageView repeatCount:20];
    }];
    
    tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    
    
    return YES;
}

- (void)customizeInterface {
    [self setUpNavigationBarAppearance];
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName : [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        textAttributes = @{
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}


#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self ky_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    if ([control ky_isTabButton]) {
        //更改红标状态
        if ([[self ky_tabBarController].selectedViewController ky_isShowTabBadgePoint]) {
            [[self ky_tabBarController].selectedViewController ky_removeTabBadgePoint];
        } else {
            [[self ky_tabBarController].selectedViewController ky_showTabBadgePoint];
        }
        
        animationView = [control ky_tabImageView];
    }
    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control ky_isPlusButton]) {
        UIButton *button = KYExternPlusButton;
        animationView = button.imageView;
    }
    
    
    
    if ([self ky_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView repeatCount:1];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

@end
