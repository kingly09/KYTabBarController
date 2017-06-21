//
//  UIControl+KYTabBarControllerExtention.h
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
@interface UIControl (KYTabBarControllerExtention)

- (UIImageView *)ky_imageView;
- (UIView *)ky_tabBadgeView;
- (UIImageView *)ky_tabImageView;
- (UILabel *)ky_tabLabel;

/*!
 * 调用该方法前已经添加了系统的角标，调用该方法后，系统的角标并未被移除，只是被隐藏，调用 `-ky_removeTabBadgePoint` 后会重新展示。
 */
- (void)ky_showTabBadgePoint;
- (void)ky_removeTabBadgePoint;
- (BOOL)ky_isShowTabBadgePoint;

@property (nonatomic, strong, setter=ky_setTabBadgePointView:, getter=ky_tabBadgePointView) UIView *ky_tabBadgePointView;
@property (nonatomic, assign, setter=ky_setTabBadgePointViewOffset:, getter=ky_tabBadgePointViewOffset) UIOffset ky_tabBadgePointViewOffset;

@end

