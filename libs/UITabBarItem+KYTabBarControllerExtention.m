//
//  UITabBarItem+KYTabBarControllerExtention.m
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

#import "UITabBarItem+KYTabBarControllerExtention.h"
#import <objc/runtime.h>
#import "UIControl+KYTabBarControllerExtention.h"

@implementation UITabBarItem (KYTabBarControllerExtention)

+ (void)load {
    [self ky_swizzleSetBadgeValue];
}

+ (void)ky_swizzleSetBadgeValue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ky_ClassMethodSwizzle([self class], @selector(setBadgeValue:), @selector(ky_setBadgeValue:));
    });
}

- (void)ky_setBadgeValue:(NSString *)badgeValue {
    [self.ky_tabButton ky_removeTabBadgePoint];
    [self ky_setBadgeValue:badgeValue];
}

- (UIControl *)ky_tabButton {
    UIControl *control = [self valueForKey:@"view"];
    return control;
}

#pragma mark - private method

BOOL ky_ClassMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}


@end
