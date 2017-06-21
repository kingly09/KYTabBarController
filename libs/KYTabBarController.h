//
//  KYTabBarController.h
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

#import "KYPlusButton.h"
#import "UIViewController+KYTabBarControllerExtention.h"
#import "UIView+KYTabBarControllerExtention.h"
#import "UITabBarItem+KYTabBarControllerExtention.h"
#import "UIControl+KYTabBarControllerExtention.h"

@class KYTabBarController;
typedef void(^KYViewDidLayoutSubViewsBlock)(KYTabBarController *tabBarController);

FOUNDATION_EXTERN NSString *const KYTabBarItemTitle;
FOUNDATION_EXTERN NSString *const KYTabBarItemImage;
FOUNDATION_EXTERN NSString *const KYTabBarItemSelectedImage;
FOUNDATION_EXTERN NSUInteger KYTabbarItemsCount;
FOUNDATION_EXTERN NSUInteger KYPlusButtonIndex;
FOUNDATION_EXTERN CGFloat KYPlusButtonWidth;
FOUNDATION_EXTERN CGFloat KYTabBarItemWidth;

@protocol KYTabBarControllerDelegate <NSObject>

/*!
 * @param tabBarController The tab bar controller containing viewController.
 * @param control Selected UIControl in TabBar.
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control;

@end

@interface KYTabBarController : UITabBarController <KYTabBarControllerDelegate>

@property (nonatomic, copy) KYViewDidLayoutSubViewsBlock viewDidLayoutSubviewsBlock;

- (void)setViewDidLayoutSubViewsBlock:(KYViewDidLayoutSubViewsBlock)viewDidLayoutSubviewsBlock;

/*!
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, readwrite, copy) NSArray<UIViewController *> *viewControllers;

/*!
 * The Attributes of items which is displayed on the tab bar.
 */
@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

/*!
 * Customize UITabBar height
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

/*!
 * To set both UIBarItem image view attributes in the tabBar,
 * default is UIEdgeInsetsZero.
 */
@property (nonatomic, readonly, assign) UIEdgeInsets imageInsets;

/*! 
 * To set both UIBarItem label text attributes in the tabBar,
 * use the following to tweak the relative position of the label within the tab button (for handling visual centering corrections if needed because of custom text attributes)
 */
@property (nonatomic, readonly, assign) UIOffset titlePositionAdjustment;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                  tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                              tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                  tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                            imageInsets:(UIEdgeInsets)imageInsets
                titlePositionAdjustment:(UIOffset)titlePositionAdjustment;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                              tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                                        imageInsets:(UIEdgeInsets)imageInsets
                            titlePositionAdjustment:(UIOffset)titlePositionAdjustment;

- (void)updateSelectionStatusIfNeededForTabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/*!
 * Judge if there is plus button.
 */
+ (BOOL)havePlusButton;

/*!
 * @attention Include plusButton if exists.
 */
+ (NSUInteger)allItemsInTabBarCount;

- (id<UIApplicationDelegate>)appDelegate;

- (UIWindow *)rootWindow;

@end

@interface NSObject (KYTabBarControllerReferenceExtension)

/*!
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `KYTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, setter=ky_setTabBarController:) KYTabBarController *ky_tabBarController;

@end

FOUNDATION_EXTERN NSString *const KYTabBarItemWidthDidChangeNotification;
