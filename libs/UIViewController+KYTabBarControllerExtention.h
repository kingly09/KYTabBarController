//
//  UIViewController+KYTabBarControllerExtention.h
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

#import <UIKit/UIKit.h>

typedef void (^KYPopSelectTabBarChildViewControllerCompletion)(__kindof UIViewController *selectedTabBarChildViewController);

typedef void (^KYPushOrPopCompletionHandler)(BOOL shouldPop,
                                              __kindof UIViewController *viewControllerPopTo,
                                              BOOL shouldPopSelectTabBarChildViewController,
                                              NSUInteger index
                                              );

typedef void (^KYPushOrPopCallback)(NSArray<__kindof UIViewController *> *viewControllers, KYPushOrPopCompletionHandler completionHandler);

@interface UIViewController (KYTabBarControllerExtention)

@property (nonatomic, strong, setter=ky_setTabBadgePointView:, getter=ky_tabBadgePointView) UIView *ky_tabBadgePointView;

@property (nonatomic, assign, setter=ky_setTabBadgePointViewOffset:, getter=ky_tabBadgePointViewOffset) UIOffset ky_tabBadgePointViewOffset;

@property (nonatomic, readonly, getter=ky_isEmbedInTabBarController) BOOL ky_embedInTabBarController;

@property (nonatomic, readonly, getter=ky_tabIndex) NSInteger ky_tabIndex;

@property (nonatomic, readonly) UIControl *ky_tabButton;

/*!
 * @attention
 - 调用该方法前已经添加了系统的角标，调用该方法后，系统的角标并未被移除，只是被隐藏，调用 `-ky_removeTabBadgePoint` 后会重新展示。
 - 不支持 KYPlusChildViewController 对应的 TabBarItem 角标设置，调用会被忽略。
 */
- (void)ky_showTabBadgePoint;

- (void)ky_removeTabBadgePoint;

- (BOOL)ky_isShowTabBadgePoint;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @return 最终被选择的控制器。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (UIViewController *)ky_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (void)ky_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(KYPopSelectTabBarChildViewControllerCompletion)completion;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param classType 需要选择的控制器所属的类。
 @return 最终被选择的控制器。
 @attention 注意：
 - 方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 - 如果 TabBarViewController 的 viewControllers 中包含多个相同的 `classType` 类型，会返回最左端的一个。
 
 */
- (UIViewController *)ky_popSelectTabBarChildViewControllerForClassType:(Class)classType;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param classType 需要选择的控制器所属的类。
 @attention 注意：
 - 方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 - 如果 TabBarViewController 的 viewControllers 中包含多个相同的 `classType` 类型，会返回最左端的一个。
 */
- (void)ky_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(KYPopSelectTabBarChildViewControllerCompletion)completion;

/*!
 *@brief 如果当前的 `NavigationViewController` 栈中包含有准备 Push 到的目标控制器，可以选择 Pop 而非 Push。
 *@param viewController Pop 或 Push 到的“目标控制器”，由 completionHandler 的参数控制 Pop 和 Push 的细节。
 *@param animated Pop 或 Push 时是否带动画
 *@param callback 回调，如果传 nil，将进行 Push。callback 包含以下几个参数：
    * * viewControllers 表示与“目标控制器”相同类型的控制器；
    * * completionHandler 包含以下几个参数：
    * * shouldPop 是否 Pop
    * * viewControllerPopTo Pop 回的控制器
    * * shouldPopSelectTabBarChildViewController 在进行 Push 行为之前，是否 Pop 到当前 `NavigationController` 的栈底。
 可能的值如下：
 NO 如果上一个参数为 NO，下一个参数 index 将被忽略。
 YES 会根据 index 参数改变 `TabBarController` 的 `selectedViewController` 属性。
 注意：该属性在 Pop 行为时不起作用。
    * * index Pop 改变 `TabBarController` 的 `selectedViewController` 属性。
 注意：该属性在 Pop 行为时不起作用。
 */
- (void)ky_pushOrPopToViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                             callback:(KYPushOrPopCallback)callback;

/*!
 * 如果正要 Push 的页面与当前栈顶的页面类型相同则取消 Push
 * 这样做防止主界面卡顿时，导致一个 ViewController 被 Push 多次
 */
- (void)ky_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)ky_getViewControllerInsteadIOfNavigationController;

@end
