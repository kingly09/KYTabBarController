//
//  KYTabBar.m
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

#import "KYTabBar.h"
#import "KYPlusButton.h"
#import "KYTabBarController.h"

static void *const KYTabBarContext = (void*)&KYTabBarContext;

@interface KYTabBar ()

/** 发布按钮 */
@property (nonatomic, strong) UIButton<KYPlusButtonSubclassing> *plusButton;
@property (nonatomic, assign) CGFloat tabBarItemWidth;
@property (nonatomic, copy) NSArray *tabBarButtonArray;

@end

@implementation KYTabBar

#pragma mark -
#pragma mark - LifeCycle Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    if (KYExternPlusButton) {
        self.plusButton = KYExternPlusButton;
        [self addSubview:(UIButton *)self.plusButton];
    }
    // KVO注册监听
    _tabBarItemWidth = KYTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:KYTabBarContext];
    return self;
}

/**
 *  lazy load tabBarButtonArray
 *
 *  @return NSArray
 */
- (NSArray *)tabBarButtonArray {
    if (_tabBarButtonArray == nil) {
        _tabBarButtonArray = @[];
    }
    return _tabBarButtonArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat taBarWidth = self.bounds.size.width;
    CGFloat taBarHeight = self.bounds.size.height;
    KYTabBarItemWidth = (taBarWidth - KYPlusButtonWidth) / KYTabbarItemsCount;
    self.tabBarItemWidth = KYTabBarItemWidth;
    NSArray *sortedSubviews = [self sortedSubviews];
    self.tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    [self setupTabImageViewDefaultOffset:self.tabBarButtonArray[0]];
    if (!KYExternPlusButton) {
        return;
    }
    CGFloat multiplierOfTabBarHeight = [self multiplierOfTabBarHeight:taBarHeight];
    CGFloat constantOfPlusButtonCenterYOffset = [self constantOfPlusButtonCenterYOffsetForTabBarHeight:taBarHeight];
    self.plusButton.center = CGPointMake(taBarWidth * 0.5, taBarHeight * multiplierOfTabBarHeight + constantOfPlusButtonCenterYOffset);
    NSUInteger plusButtonIndex = [self plusButtonIndex];
    [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= plusButtonIndex) {
            childViewX = buttonIndex * KYTabBarItemWidth + KYPlusButtonWidth;
        } else {
            childViewX = buttonIndex * KYTabBarItemWidth;
        }
        //仅修改childView的x和宽度,yh值不变
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     KYTabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
    }];
    //bring the plus button to top
    [self bringSubviewToFront:self.plusButton];
}

#pragma mark -
#pragma mark - Private Methods

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != KYTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == KYTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KYTabBarItemWidthDidChangeNotification object:self];
    }
}

- (void)dealloc {
    // KVO反注册
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat )tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

- (void)setTabImageViewDefaultOffset:(CGFloat)tabImageViewDefaultOffset {
    if (tabImageViewDefaultOffset != 0.f) {
        [self willChangeValueForKey:@"tabImageViewDefaultOffset"];
        _tabImageViewDefaultOffset = tabImageViewDefaultOffset;
        [self didChangeValueForKey:@"tabImageViewDefaultOffset"];
    }
}

- (CGFloat)multiplierOfTabBarHeight:(CGFloat)taBarHeight {
    CGFloat multiplierOfTabBarHeight;
    if ([[self.plusButton class] respondsToSelector:@selector(multiplierOfTabBarHeight:)]) {
        multiplierOfTabBarHeight = [[self.plusButton class] multiplierOfTabBarHeight:taBarHeight];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if ([[self.plusButton class] respondsToSelector:@selector(multiplerInCenterY)]) {
        multiplierOfTabBarHeight = [[self.plusButton class] multiplerInCenterY];
    }
#pragma clang diagnostic pop
    
    else {
        CGSize sizeOfPlusButton = self.plusButton.frame.size;
        CGFloat heightDifference = sizeOfPlusButton.height - self.bounds.size.height;
        if (heightDifference < 0) {
            multiplierOfTabBarHeight = 0.5;
        } else {
            CGPoint center = CGPointMake(self.bounds.size.height * 0.5, self.bounds.size.height * 0.5);
            center.y = center.y - heightDifference * 0.5;
            multiplierOfTabBarHeight = center.y / self.bounds.size.height;
        }
    }
    return multiplierOfTabBarHeight;
}

- (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)taBarHeight {
    CGFloat constantOfPlusButtonCenterYOffset = 0.f;
    if ([[self.plusButton class] respondsToSelector:@selector(constantOfPlusButtonCenterYOffsetForTabBarHeight:)]) {
        constantOfPlusButtonCenterYOffset = [[self.plusButton class] constantOfPlusButtonCenterYOffsetForTabBarHeight:taBarHeight];
    }
    return constantOfPlusButtonCenterYOffset;
}

- (NSUInteger)plusButtonIndex {
    NSUInteger plusButtonIndex;
    if ([[self.plusButton class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
        plusButtonIndex = [[self.plusButton class] indexOfPlusButtonInTabBar];
        //仅修改self.plusButton的x,ywh值不变
        self.plusButton.frame = CGRectMake(plusButtonIndex * KYTabBarItemWidth,
                                           CGRectGetMinY(self.plusButton.frame),
                                           CGRectGetWidth(self.plusButton.frame),
                                           CGRectGetHeight(self.plusButton.frame)
                                           );
    } else {
        if (KYTabbarItemsCount % 2 != 0) {
            [NSException raise:@"KYTabBarController" format:@"If the count of KYTabbarControllers is odd,you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果KYTabbarControllers的个数是奇数，你必须在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = KYTabbarItemsCount * 0.5;
    }
    KYPlusButtonIndex = plusButtonIndex;
    return plusButtonIndex;
}

/*!
 *  Deal with some trickiness by Apple, You do not need to understand this method, somehow, it works.
 *  NOTE: If the `self.title of ViewController` and `the correct title of tabBarItemsAttributes` are different, Apple will delete the correct tabBarItem from subViews, and then trigger `-layoutSubviews`, therefore subViews will be in disorder. So we need to rearrange them.
 */
- (NSArray *)sortedSubviews {
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];
    return sortedSubviews;
}

- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews {
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj ky_isTabButton]) {
            [tabBarButtonMutableArray addObject:obj];
        }
    }];
    if (KYPlusChildViewController) {
        [tabBarButtonMutableArray removeObjectAtIndex:KYPlusButtonIndex];
    }
    return [tabBarButtonMutableArray copy];
}

- (void)setupTabImageViewDefaultOffset:(UIView *)tabBarButton {
    __block BOOL shouldCustomizeImageView = YES;
    __block CGFloat tabImageViewHeight = 0.f;
    __block CGFloat tabImageViewDefaultOffset = 0.f;
    CGFloat tabBarHeight = self.frame.size.height;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj ky_isTabLabel]) {
            shouldCustomizeImageView = NO;
        }
        tabImageViewHeight = obj.frame.size.height;
        BOOL isTabImageView = [obj ky_isTabImageView];
        if (isTabImageView) {
            tabImageViewDefaultOffset = (tabBarHeight - tabImageViewHeight) * 0.5 * 0.5;
        }
        if (isTabImageView && tabImageViewDefaultOffset == 0.f) {
            shouldCustomizeImageView = NO;
        }
    }];
    if (shouldCustomizeImageView) {
        self.tabImageViewDefaultOffset = tabImageViewDefaultOffset;
    }
}

/*!
 *  Capturing touches on a subview outside the frame of its superview.
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //1. 边界情况：不能响应点击事件
    
    BOOL canNotResponseEvent = self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO);
    if (canNotResponseEvent) {
        return nil;
    }
    
    //2. 优先处理 PlusButton （包括其突出的部分）、TabBarItems 未凸出的部分
    //这一步主要是在处理只有两个 TabBarItems 的场景。
    // 2.1先考虑clipsToBounds情况：子view超出部分没有显示出来
    if (self.clipsToBounds && ![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    if (KYExternPlusButton) {
        CGRect plusButtonFrame = self.plusButton.frame;
        BOOL isInPlusButtonFrame = CGRectContainsPoint(plusButtonFrame, point);
        if (isInPlusButtonFrame) {
            return KYExternPlusButton;
        }
    }
    NSArray *tabBarButtons = self.tabBarButtonArray;
    if (self.tabBarButtonArray.count == 0) {
        tabBarButtons = [self tabBarButtonFromTabBarSubviews:self.subviews];
    }
    for (NSUInteger index = 0; index < tabBarButtons.count; index++) {
        UIView *selectedTabBarButton = tabBarButtons[index];
        CGRect selectedTabBarButtonFrame = selectedTabBarButton.frame;
        BOOL isTabBarButtonFrame = CGRectContainsPoint(selectedTabBarButtonFrame, point);\
        if (isTabBarButtonFrame) {
            return selectedTabBarButton;
        }
    }
    
    //3. 最后处理 TabBarItems 凸出的部分、添加到 TabBar 上的自定义视图、点击到 TabBar 上的空白区域
    
    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    return nil;
}
@end
