//
//  KYTabBarControllerConfig.m
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

#import "KYTabBarControllerConfig.h"

static CGFloat const KYTabBarControllerHeight = 40.f;

@interface KYBaseNavigationController : UINavigationController
@end

@implementation KYBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

//View Controllers
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface KYTabBarControllerConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) KYTabBarController *tabBarController;

@end

@implementation KYTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return KYTabBarController
 */
- (KYTabBarController *)tabBarController {
  if (_tabBarController == nil) {
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `KYTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
    
    KYTabBarController *tabBarController = [KYTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                             tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                       imageInsets:imageInsets
                                                                           titlePositionAdjustment:titlePositionAdjustment];
    
    [self customizeTabBarAppearance:tabBarController];
    _tabBarController = tabBarController;
  }
  return _tabBarController;
}

- (NSArray *)viewControllers {
  FirstViewController *firstViewController = [[FirstViewController alloc] init];
  UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                 initWithRootViewController:firstViewController];
  
  SecondViewController *secondViewController = [[SecondViewController alloc] init];
  UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:secondViewController];
  
  ThirdViewController *thirdViewController = [[ThirdViewController alloc] init];
  UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                 initWithRootViewController:thirdViewController];
  
  FourthViewController *fourthViewController = [[FourthViewController alloc] init];
  UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:fourthViewController];
  
  NSArray *viewControllers = @[
                               firstNavigationController,
                               secondNavigationController,
                               thirdNavigationController,
                               fourthNavigationController
                               ];
  return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
  NSDictionary *firstTabBarItemsAttributes = @{
                                               KYTabBarItemTitle : @"首页",
                                               KYTabBarItemImage : @"ic_home",  /* NSString and UIImage are supported*/
                                               KYTabBarItemSelectedImage : @"ic-home-p", /* NSString and UIImage are supported*/
                                               };
  NSDictionary *secondTabBarItemsAttributes = @{
                                                KYTabBarItemTitle : @"发现",
                                                KYTabBarItemImage : @"ic-find",
                                                KYTabBarItemSelectedImage : @"ic-find-p",
                                                };
  NSDictionary *thirdTabBarItemsAttributes = @{
                                               KYTabBarItemTitle : @"好物",
                                               KYTabBarItemImage : @"ic-gift",
                                               KYTabBarItemSelectedImage : @"ic-gift-p",
                                               };
  NSDictionary *fourthTabBarItemsAttributes = @{
                                                KYTabBarItemTitle : @"我",
                                                KYTabBarItemImage : @"ic-me",
                                                KYTabBarItemSelectedImage : @"ic-me-p"
                                                };
  NSArray *tabBarItemsAttributes = @[
                                     firstTabBarItemsAttributes,
                                     secondTabBarItemsAttributes,
                                     thirdTabBarItemsAttributes,
                                     fourthTabBarItemsAttributes
                                     ];
  return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(KYTabBarController *)tabBarController {

    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
//     UITabBar *tabBarAppearance = [UITabBar appearance];
//     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tab_bar"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:KYTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = KYTabBarControllerHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(KYTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self ky_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor yellowColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
