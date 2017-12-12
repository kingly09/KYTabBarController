//
//  UIControl+KYTabBarControllerExtention.m
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

#import "UIControl+KYTabBarControllerExtention.h"
#import <objc/runtime.h>
#import "UIView+KYTabBarControllerExtention.h"
#import "KYConstants.h"

@implementation UIControl (KYTabBarControllerExtention)

- (void)ky_showTabBadgePoint {
    [self ky_setShowTabBadgePointIfNeeded:YES];
}

- (void)ky_removeTabBadgePoint {
    [self ky_setShowTabBadgePointIfNeeded:NO];
}

- (BOOL)ky_isShowTabBadgePoint {
    return !self.ky_tabBadgePointView.hidden;
}

- (void)ky_setShowTabBadgePointIfNeeded:(BOOL)showTabBadgePoint {
    @try {
        [self ky_setShowTabBadgePoint:showTabBadgePoint];
    } @catch (NSException *exception) {
        NSLog(@"KYPlusChildViewController do not support set TabBarItem red point");
    }
}

- (void)ky_setShowTabBadgePoint:(BOOL)showTabBadgePoint {
    if (showTabBadgePoint && self.ky_tabBadgePointView.superview == nil) {
        [self addSubview:self.ky_tabBadgePointView];
        [self bringSubviewToFront:self.ky_tabBadgePointView];
        self.ky_tabBadgePointView.layer.zPosition = MAXFLOAT;
        // X constraint
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.ky_tabBadgePointView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:0
                                         toItem:self.ky_tabImageView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:self.ky_tabBadgePointViewOffset.horizontal]];
        //Y constraint
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.ky_tabBadgePointView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:0
                                         toItem:self.ky_tabImageView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:self.ky_tabBadgePointViewOffset.vertical]];
    }
    self.ky_tabBadgePointView.hidden = showTabBadgePoint == NO;
    self.ky_tabBadgeView.hidden = showTabBadgePoint == YES;
}

- (void)ky_setTabBadgePointView:(UIView *)tabBadgePointView {
    UIView *tempView = objc_getAssociatedObject(self, @selector(ky_tabBadgePointView));
    if (tempView) {
        [tempView removeFromSuperview];
    }
    if (tabBadgePointView.superview) {
        [tabBadgePointView removeFromSuperview];
    }
    
    tabBadgePointView.hidden = YES;
    objc_setAssociatedObject(self, @selector(ky_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ky_tabBadgePointView {
    UIView *tabBadgePointView = objc_getAssociatedObject(self, @selector(ky_tabBadgePointView));
    
    if (tabBadgePointView == nil) {
        tabBadgePointView = self.ky_defaultTabBadgePointView;
        objc_setAssociatedObject(self, @selector(ky_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tabBadgePointView;
}

- (void)ky_setTabBadgePointViewOffset:(UIOffset)tabBadgePointViewOffset {
    objc_setAssociatedObject(self, @selector(ky_tabBadgePointViewOffset), [NSValue valueWithUIOffset:tabBadgePointViewOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//offset如果都是正数，则往右下偏移
- (UIOffset)ky_tabBadgePointViewOffset {
    id tabBadgePointViewOffsetObject = objc_getAssociatedObject(self, @selector(ky_tabBadgePointViewOffset));
    UIOffset tabBadgePointViewOffset = [tabBadgePointViewOffsetObject UIOffsetValue];
    return tabBadgePointViewOffset;
}

- (UIView *)ky_tabBadgeView {
    for (UIView *subview in self.subviews) {
        if ([subview ky_isTabBadgeView]) {
            return (UIView *)subview;
        }
    }
    return nil;
}

- (UIImageView *)ky_tabImageView {
    for (UIImageView *subview in self.subviews) {
        if ([subview ky_isTabImageView]) {
            return (UIImageView *)subview;
        }
    }
    return nil;
}

- (UILabel *)ky_tabLabel {
    for (UILabel *subview in self.subviews) {
        if ([subview ky_isTabLabel]) {
            return (UILabel *)subview;
        }
    }
    return nil;
}

#pragma mark - private method

- (UIView *)ky_defaultTabBadgePointView {
    UIView *defaultRedTabBadgePointView = [UIView ky_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
    return defaultRedTabBadgePointView;
}

@end
