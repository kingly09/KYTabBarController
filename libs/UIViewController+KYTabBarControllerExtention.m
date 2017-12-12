//
//  UIViewController+KYTabBarControllerExtention.m
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

#import "UIViewController+KYTabBarControllerExtention.h"
#import "KYTabBarController.h"
#import <objc/runtime.h>

@implementation UIViewController (KYTabBarControllerExtention)

#pragma mark -
#pragma mark - public Methods

- (UIViewController *)ky_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index {
    [self checkTabBarChildControllerValidityAtIndex:index];
    [self.navigationController popToRootViewControllerAnimated:NO];
    KYTabBarController *tabBarController = [self ky_tabBarController];
    tabBarController.selectedIndex = index;
    UIViewController *selectedTabBarChildViewController = tabBarController.selectedViewController;
    return [selectedTabBarChildViewController ky_getViewControllerInsteadIOfNavigationController];
}

- (void)ky_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(KYPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self ky_popSelectTabBarChildViewControllerAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (UIViewController *)ky_popSelectTabBarChildViewControllerForClassType:(Class)classType {
    KYTabBarController *tabBarController = [self ky_tabBarController];
    NSArray *viewControllers = tabBarController.viewControllers;
    NSInteger atIndex = [self ky_indexForClassType:classType inViewControllers:viewControllers];
    return [self ky_popSelectTabBarChildViewControllerAtIndex:atIndex];
}

- (void)ky_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(KYPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self ky_popSelectTabBarChildViewControllerForClassType:classType];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (void)ky_pushOrPopToViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                             callback:(KYPushOrPopCallback)callback {
    if (!callback) {
        [self.navigationController pushViewController:viewController animated:animated];
        return;
    }
    
    void (^popSelectTabBarChildViewControllerCallback)(BOOL shouldPopSelectTabBarChildViewController, NSUInteger index) = ^(BOOL shouldPopSelectTabBarChildViewController, NSUInteger index) {
        if (shouldPopSelectTabBarChildViewController) {
            [self ky_popSelectTabBarChildViewControllerAtIndex:index completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
                [selectedTabBarChildViewController.navigationController pushViewController:viewController animated:animated];
            }];
        } else {
            [self.navigationController pushViewController:viewController animated:animated];
        }
    };
    NSArray<__kindof UIViewController *> *otherSameClassTypeViewControllersInCurrentNavigationControllerStack = [self ky_getOtherSameClassTypeViewControllersInCurrentNavigationControllerStack:viewController];
    
    KYPushOrPopCompletionHandler completionHandler = ^(BOOL shouldPop,
                                                        __kindof UIViewController *viewControllerPopTo,
                                                        BOOL shouldPopSelectTabBarChildViewController,
                                                        NSUInteger index
                                                        ) {
        if (!otherSameClassTypeViewControllersInCurrentNavigationControllerStack || otherSameClassTypeViewControllersInCurrentNavigationControllerStack.count == 0) {
            shouldPop = NO;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            if (shouldPop) {
                [self.navigationController popToViewController:viewControllerPopTo animated:animated];
                return;
            }
            popSelectTabBarChildViewControllerCallback(shouldPopSelectTabBarChildViewController, index);
        });
    };
    callback(otherSameClassTypeViewControllersInCurrentNavigationControllerStack, completionHandler);
}

- (void)ky_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *fromViewController = [self ky_getViewControllerInsteadIOfNavigationController];
    NSArray *childViewControllers = fromViewController.navigationController.childViewControllers;
    if (childViewControllers.count > 0) {
        if ([[childViewControllers lastObject] isKindOfClass:[viewController class]]) {
            return;
        }
    }
    [fromViewController.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)ky_getViewControllerInsteadIOfNavigationController {
    BOOL isNavigationController = [[self class] isSubclassOfClass:[UINavigationController class]];
    if (isNavigationController) {
        return ((UINavigationController *)self).viewControllers[0];
    }
    return self;
}

#pragma mark - public method

- (BOOL)ky_isPlusChildViewController {
    if (!KYPlusChildViewController) {
        return NO;
    }
    return (self == KYPlusChildViewController);
}

- (void)ky_showTabBadgePoint {
    if (self.ky_isPlusChildViewController) {
        return;
    }
    [self.ky_tabButton ky_showTabBadgePoint];
    [[self ky_tabBarController].tabBar layoutIfNeeded];
}

- (void)ky_removeTabBadgePoint {
    if (self.ky_isPlusChildViewController) {
        return;
    }
    [self.ky_tabButton ky_removeTabBadgePoint];
    [[self ky_tabBarController].tabBar layoutIfNeeded];
}

- (BOOL)ky_isShowTabBadgePoint {
    if (self.ky_isPlusChildViewController) {
        return NO;
    }
    return [self.ky_tabButton ky_isShowTabBadgePoint];
}

- (void)ky_setTabBadgePointView:(UIView *)tabBadgePointView {
    if (self.ky_isPlusChildViewController) {
        return;
    }
    [self.ky_tabButton ky_setTabBadgePointView:tabBadgePointView];
}

- (UIView *)ky_tabBadgePointView {
    if (self.ky_isPlusChildViewController) {
        return nil;
    }
    return [self.ky_tabButton ky_tabBadgePointView];;
}

- (void)ky_setTabBadgePointViewOffset:(UIOffset)tabBadgePointViewOffset {
    if (self.ky_isPlusChildViewController) {
        return;
    }
    return [self.ky_tabButton ky_setTabBadgePointViewOffset:tabBadgePointViewOffset];
}

//offset如果都是整数，则往右下偏移
- (UIOffset)ky_tabBadgePointViewOffset {
    if (self.ky_isPlusChildViewController) {
        return UIOffsetZero;
    }
    return [self.ky_tabButton ky_tabBadgePointViewOffset];
}

- (BOOL)ky_isEmbedInTabBarController {
    if (self.ky_tabBarController == nil) {
        return NO;
    }
    if (self.ky_isPlusChildViewController) {
        return NO;
    }
    BOOL isEmbedInTabBarController = NO;
    UIViewController *viewControllerInsteadIOfNavigationController = [self ky_getViewControllerInsteadIOfNavigationController];
    for (NSInteger i = 0; i < self.ky_tabBarController.viewControllers.count; i++) {
        UIViewController * vc = self.ky_tabBarController.viewControllers[i];
        if ([vc ky_getViewControllerInsteadIOfNavigationController] == viewControllerInsteadIOfNavigationController) {
            isEmbedInTabBarController = YES;
            [self ky_setTabIndex:i];
            break;
        }
    }
    return isEmbedInTabBarController;
}

- (void)ky_setTabIndex:(NSInteger)tabIndex {
    objc_setAssociatedObject(self, @selector(ky_tabIndex), @(tabIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)ky_tabIndex {
    if (!self.ky_isEmbedInTabBarController) {
        return NSNotFound;
    }
    
    id tabIndexObject = objc_getAssociatedObject(self, @selector(ky_tabIndex));
    NSInteger tabIndex = [tabIndexObject integerValue];
    return tabIndex;
}

- (UIControl *)ky_tabButton {
    if (!self.ky_isEmbedInTabBarController) {
        return nil;
    }
    UITabBarItem *tabBarItem;
    UIControl *control;
    @try {
        tabBarItem = self.ky_tabBarController.tabBar.items[self.ky_tabIndex];
        control = [tabBarItem ky_tabButton];
    } @catch (NSException *exception) {}
    return control;
}


#pragma mark -
#pragma mark - Private Methods

- (NSArray<__kindof UIViewController *> *)ky_getOtherSameClassTypeViewControllersInCurrentNavigationControllerStack:(UIViewController *)viewController {
    NSArray *currentNavigationControllerStack = [self.navigationController childViewControllers];
    if (currentNavigationControllerStack.count < 2) {
        return nil;
    }
    NSMutableArray *mutableArray = [currentNavigationControllerStack mutableCopy];
    [mutableArray removeObject:self];
    currentNavigationControllerStack = [mutableArray copy];
    
    __block NSMutableArray *mutableOtherViewControllersInNavigationControllerStack = [NSMutableArray arrayWithCapacity:currentNavigationControllerStack.count];
    
    [currentNavigationControllerStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *otherViewController = obj;
        if ([otherViewController isKindOfClass:[viewController class]]) {
            [mutableOtherViewControllersInNavigationControllerStack addObject:otherViewController];
        }
    }];
    return [mutableOtherViewControllersInNavigationControllerStack copy];
}

- (void)checkTabBarChildControllerValidityAtIndex:(NSUInteger)index {
    KYTabBarController *tabBarController = [self ky_tabBarController];
    @try {
        UIViewController *viewController;
        viewController = tabBarController.viewControllers[index];
        UIButton *plusButton = KYExternPlusButton;
        BOOL shouldConfigureSelectionStatus = (KYPlusChildViewController) && ((index != KYPlusButtonIndex) && (viewController != KYPlusChildViewController));
        if (shouldConfigureSelectionStatus) {
            plusButton.selected = NO;
        }
    } @catch (NSException *exception) {
        NSString *formatString = @"\n\n\
        ------ BEGIN NSException Log ---------------------------------------------------------------------\n \
        class name: %@                                                                                    \n \
        ------line: %@                                                                                    \n \
        ----reason: The Class Type or the index or its NavigationController you pass in method `-ky_popSelectTabBarChildViewControllerAtIndex` or `-ky_popSelectTabBarChildViewControllerForClassType` is not the item of KYTabBarViewController \n \
        ------ END ---------------------------------------------------------------------------------------\n\n";
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__)];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
}

- (NSInteger)ky_indexForClassType:(Class)classType inViewControllers:(NSArray *)viewControllers {
    __block NSInteger atIndex = NSNotFound;
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *obj_ = [obj ky_getViewControllerInsteadIOfNavigationController];
        if ([obj_ isKindOfClass:classType]) {
            atIndex = idx;
            *stop = YES;
            return;
        }
    }];
    return atIndex;
}


@end
