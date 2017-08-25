<p align="center">
<a href=""><img src="https://img.shields.io/badge/pod-v0.0.4-brightgreen.svg"></a>
<a href=""><img src="https://img.shields.io/badge/Swift-compatible-orange.svg"></a>
<a href=""><img src="https://img.shields.io/badge/platform-iOS%208.0%2B-ff69b5152950834.svg"></a>
<a href="https://github.com/ChenYilong/KYTabBarController/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat"></a>
</p>


# KYTabBarController
KYTabBarController是一个只需要两个简单的数组即可搭建主流的App框架库 


# 安装

### 要求

* Xcode 7 +
* iOS 8.0 +


### 手动安装

下载DEMO后,将子文件夹 **libs** 拖入到项目中, 导入头文件`KYConstants.h` 开始使用.

### CocoaPods安装

CocoaPods 如果不知道怎么使用？请参考  [https://my.oschina.net/kinglyphp/blog/795027](https://my.oschina.net/kinglyphp/blog/795027)

你可以在 **Podfile** 中加入下面一行代码来使用 `KYTabBarController`

```
	pod 'KYTabBarController', '~> 0.0.4'
```


# 如何使用

### 基本功能

### step 1 : 设置KYTabBarController的两个数组：控制器数组和TabBar属性数组

在这个字典中，`KYTabBarItemImage` 和 `KYTabBarItemSelectedImage` 支持 `NSString`、`UIImage` 两种格式。`KYTabBarItemTitle` 不设置将只展示图标，并会对布局作出居中处理。

```
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

```

### step 2 : 将KYTabBarController设置为window的RootViewController

在 `AppDelegate.m` 导入如下两个文件 

```
#import "KYTabBarControllerConfig.h"
#import "KYPlusButtonSubclass.h"
```

将`KYTabBarController`设置为`window`的`RootViewController`，代码示例如下：

```

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [KYPlusButtonSubclass registerPlusButton];
    KYTabBarControllerConfig *tabBarControllerConfig = [[KYTabBarControllerConfig alloc] init];
    KYTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];    
    tabBarController.delegate = self;
    [self.window makeKeyAndVisible];

    return YES;
}

```

## step 3 （可选）：创建自定义的形状不规则加号按钮

创建一个继承于 KYPlusButton 的类，要求和步骤：


 1. 实现  `KYPlusButtonSubclassing`  协议 

 2. 子类将自身类型进行注册，需要在 `-application:didFinishLaunchingWithOptions:` 方法里面调用 `[YourClass registerPlusButton]` 

   这里注意，不能在子类的 `+load` 方法中调用，比如像下面这样做，在 iOS10 系统上有 Crash 的风险：

 ```Objective-C
 + (void)load {
    [super registerPlusButton];
 }
 ```

协议提供了可选方法：

 ```Objective-C
+ (NSUInteger)indexOfPlusButtonInTabBar;
+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight;
+ (UIViewController *)plusChildViewController;
+ (BOOL)shouldSelectPlusChildViewController;
 ```

作用分别是：

 ```Objective-C
 + (NSUInteger)indexOfPlusButtonInTabBar;
 ```
用来自定义加号按钮的位置，如果不实现默认居中，但是如果 `tabbar` 的个数是奇数则必须实现该方法，否则 `KYTabBarController` 会抛出 `exception` 来进行提示。

主要适用于如下情景：

![enter image description here](http://a64.tinypic.com/2mo0h.jpg)

如：Airbnb-app效果


 ```Objective-C
+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight;
 ```

该方法是为了调整自定义按钮中心点Y轴方向的位置，建议在按钮超出了 `tabbar` 的边界时实现该方法。返回值是自定义按钮中心点Y轴方向的坐标除以 `tabbar` 的高度，如果不实现，会自动进行比对，预设一个较为合适的位置，如果实现了该方法，预设的逻辑将失效。

内部实现时，会使用该返回值来设置 PlusButton 的 centerY 坐标，公式如下：
              
`PlusButtonCenterY = multiplierOfTabBarHeight * taBarHeight + constantOfPlusButtonCenterYOffset;`

也就是说：如果 constantOfPlusButtonCenterYOffset 为0，同时 multiplierOfTabBarHeight 的值是0.5，表示 PlusButton 居中，小于0.5表示 PlusButton 偏上，大于0.5则表示偏下。


 ```Objective-C
+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight;
 ```

参考 `+multiplierOfTabBarHeight:` 中的公式：

`PlusButtonCenterY = multiplierOfTabBarHeight * taBarHeight + constantOfPlusButtonCenterYOffset;`

也就是说： constantOfPlusButtonCenterYOffset 大于0会向下偏移，小于0会向上偏移。

注意：实现了该方法，但没有实现 `+multiplierOfTabBarHeight:` 方法，在这种情况下，会在预设逻辑的基础上进行偏移。

详见Demo中的 `KYPlusButtonSubclass` 类的实现。

 ```Objective-C
+ (UIViewController *)plusChildViewController;
 ```

详见： [点击 PlusButton 跳转到指定 UIViewController](#点击-plusbutton-跳转到指定-uiviewcontroller) 


另外，如果加号按钮超出了边界，一般需要手动调用如下代码取消 tabbar 顶部默认的阴影，可在 AppDelegate 类中调用：


 ```Objective-C
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
 ```

如何调整、自定义 `PlusButton` 与其它 `TabBarItem` 的宽度？

`KYTabBarController` 规定：

 ```Objective-C
 TabBarItem 宽度 ＝  ( TabBar 总宽度 －  PlusButton 宽度  ) / (TabBarItem 个数)
 ```

所以想自定义宽度，只需要修改 `PlusButton` 的宽度即可。

比如你就可以在 Demo中的 `KYPlusButtonSubclass.m` 类里：
   
把

 ```Objective-C
 [button sizeToFit]; 
 ```

改为

 ```Objective-C
 button.frame = CGRectMake(0.0, 0.0, 250, 100);
 button.backgroundColor = [UIColor redColor];
 ```

效果如下，

![enter image description here](http://i64.tinypic.com/vx16r5.jpg)

同时你也可以顺便测试下 `KYTabBarController` 的这一个特性：

 > 即使加号按钮超出了tabbar的区域，超出部分依然能响应点击事件

并且你可以在项目中的任意位置读取到 `PlusButton` 的宽度，借助 `KYTabBarController.h` 定义的 `KYPlusButtonWidth` 这个extern。可参考 `+[KYTabBarControllerConfig customizeTabBarAppearance:]` 里的用法。


##  更多扩展功能

* [自定义 TabBar 样式](#自定义 TabBar 样式)
* [捕获 TabBar 点击事件](#捕获 TabBar 点击事件)
* [点击 TabBarButton 时添加动画](#点击 TabBarButton 时添加动画)
* [横竖屏适配](#横竖屏适配)
* [访问初始化好的 KYTabBarController 对象](#访问初始化好的 KYTabBarController 对象)
* [点击 PlusButton 跳转到指定 UIViewController](#点击 PlusButton 跳转到指定 UIViewController)
* [让TabBarItem仅显示图标，并使图标垂直居中](#让TabBarItem仅显示图标，并使图标垂直居中)


###  <a name="自定义 TabBar 样式"></a>自定义 TabBar 样式

如果想更进一步的自定义 `TabBar` 样式可在 `-application:didFinishLaunchingWithOptions:` 方法中设置

 ```Objective-C
 /**
 *  tabBarItem 的选中和不选中文字属性、背景图片
 */
- (void)customizeInterface {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
}

 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 /* *省略部分：   * */
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    return YES;
}
 ```

### <a name="捕获 TabBar 点击事件"></a>捕获 TabBar 点击事件

实现 `KYTabBarController` 的如下几个代理方法即可捕获点击事件。 
  
  下面这个方法能捕获当前点击的 `TabBar` 上的控件，可以是 `UITabBarButton`、也可以 `PlusButton`、也可以是添加到 `TabBar` 上的任意 `UIControl` 的子类。但是如果 `PlusButton` 也添加了点击事件，那么点击 `PlusButton` 将不会被触发这个代理方法。
  
 ```Objective-C
//KYTabBarController.h

@protocol KYTabBarControllerDelegate <NSObject>

/*!
 * @param tabBarController The tab bar controller containing viewController.
 * @param control Selected UIControl in TabBar.
 * @attention If PlusButton also add an action, then this delegate method will not be invoked when the PlusButton is selected.
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control;

@end

 ```

 下面这个方法能捕获跳转前所在的控制器，以及跳转到的目标控制器。
 
 ```Objective-C
//UITabBarController.h
@protocol UITabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);
@end

 ```

注意：在调用该方法时应该始终调用
`    [[self ky_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];` 来确保 `PlusButton` 的选中状态。示例如下：

 ```Objective-C
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self ky_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}
 ```

相关用法已经在 Demo 中展示。

 遵循协议的方式如下：
 
 
 ```Objective-C
@interface AppDelegate ()<UITabBarControllerDelegate, KYTabBarControllerDelegate>

@end

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //...
        tabBarControllerConfig.tabBarController.delegate = self;
    //...
    return YES;
}
 ```
 

### <a name="点击 TabBarButton 时添加动画"></a>点击 TabBarButton 时添加动画

实现如下代理方法，就能得到对应的选中控件，可以在控件上直接添加动画。


 ```Objective-C
//KYTabBarController.h

@protocol KYTabBarControllerDelegate <NSObject>

/*!
 * @param tabBarController The tab bar controller containing viewController.
 * @param control Selected UIControl in TabBar.
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control;

@end

 ```
 
 Demo 中示例代码如下：

 遵循协议
 
 
 ```Objective-C
@interface AppDelegate ()<UITabBarControllerDelegate, KYTabBarControllerDelegate>

@end
 ```

 
 ```Objective-C
 //AppDelegate.m
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    // 如果 PlusButton 也添加了点击事件，那么点击 PlusButton 后不会触发该代理方法。
    if ([control isKindOfClass:[KYExternPlusButton class]]) {
        UIButton *button = KYExternPlusButton;
        animationView = button.imageView;
    } else if ([control isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        for (UIView *subView in control.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                animationView = subView;
            }
        }
    }
    
    if ([self ky_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}
 ```

### <a name="横竖屏适配"></a>横竖屏适配

`TabBar` 横竖屏适配时，如果你添加了 `PlusButton`，且适配时用到了 `TabBarItem` 的宽度, 不建议使用系统的`UIDeviceOrientationDidChangeNotification` , 请使用库里的 `KYTabBarItemWidthDidChangeNotification` 来更新 `TabBar` 布局，最典型的场景就是，根据 `TabBarItem` 在不同横竖屏状态下的宽度变化来切换选中的`TabBarItem` 的背景图片。Demo 里 `KYTabBarControllerConfig.m` 给出了这一场景的用法:


 `KYTabBarController.h`  中提供了 `KYTabBarItemWidth` 这一extern常量，并且会在 `TabBarItem` 的宽度发生变化时，及时更新该值，所以用法就如下所示：

 ```Objective-C
- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        [self tabBarItemWidthDidUpdate];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:KYTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)tabBarItemWidthDidUpdate {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
        NSLog(@"Landscape Left or Right !");
    } else if (orientation == UIDeviceOrientationPortrait){
        NSLog(@"Landscape portrait!");
    }
    CGSize selectionIndicatorImageSize = CGSizeMake(KYTabBarItemWidth, [self ky_tabBarController].tabBar.bounds.size.height);
    [[self ky_tabBarController].tabBar setSelectionIndicatorImage:[[self class]
                                                                    imageFromColor:[UIColor yellowColor]
                                                                    forSize:selectionIndicatorImageSize
                                                                    withCornerRadius:0]];
}
 ```
 

### <a name="访问初始化好的 KYTabBarController 对象"></a>访问初始化好的 KYTabBarController 对象


对于任意 `NSObject` 对象：

 `KYTabBarController.h`  中为 `NSObject` 提供了分类方法 `-ky_tabBarController` ，所以在任意对象中，一行代码就可以访问到一个初始化好的  `KYTabBarController`  对象，`-ky_tabBarController` 的作用你可以这样理解：与获取单例对象的  `+shareInstance` 方法作用一样。

接口如下：

 ```Objective-C
// KYTabBarController.h

@interface NSObject (KYTabBarController)

/**
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `KYTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, readonly) KYTabBarController *ky_tabBarController;

@end
 ```

用法：


 ```Objective-C
//导入 KYTabBarController.h
#import "KYTabBarController.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    KYTabBarController *tabbarController = [self ky_tabBarController];
    /*...*/
}
 ```



###  <a name="点击 PlusButton 跳转到指定 UIViewController"></a>点击 PlusButton 跳转到指定 UIViewController

提供了一个协议方法来完成本功能：

实现该方法后，能让 PlusButton 的点击效果与跟点击其他 TabBar 按钮效果一样，跳转到该方法指定的 UIViewController 。

注意：必须同时实现 `+indexOfPlusButtonInTabBar` 来指定 PlusButton 的位置。

遵循几个协议：



另外你可以通过下面这个方法获取到 `PlusButton` 的点击事件：

```Objective-C
+ (BOOL)shouldSelectPlusChildViewController;
```

用法如下：


```Objective-C
+ (BOOL)shouldSelectPlusChildViewController {
    BOOL isSelected = KYExternPlusButton.selected;
    if (isSelected) {
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is selected");
    } else {
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is not selected");
    }
    return YES;
}

```


### <a name="让TabBarItem仅显示图标，并使图标垂直居中"></a>让TabBarItem仅显示图标，并使图标垂直居中


要想实现该效果，只需要在设置 `tabBarItemsAttributes`该属性时不传 title 即可。

还可以通过这种方式来达到 Airbnb-app 的效果：

果想手动设置偏移量来达到该效果：
可以在 `-setViewControllers:` 方法前设置 `KYTabBarController` 的 `imageInsets` 和 `titlePositionAdjustment` 属性

这里注意：设置这两个属性后，`TabBar` 中所有的 `TabBarItem` 都将被设置。并且第一种做法的逻辑将不会执行，也就是说该做法优先级要高于第一种做法。

做法如下：

```
  UIEdgeInsets imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
        UIOffset titlePositionAdjustment =UIOffsetMake(0, MAXFLOAT);
        
        KYTabBarController *tabBarController = [KYTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment];
        
```


但是想达到Airbnb-app的效果只有这个接口是不行的，还需要自定义下 `TabBar` 的高度，你需要设置 `KYTabBarController` 的 `tabBarHeight` 属性。你可以在Demo的 `KYTabBarControllerConfig.m` 中的 `-customizeTabBarAppearance:` 方法中设置。

注：“仅显示图标，并使图标垂直居中”这里所指的“图标”，其所属的类是私有类： `UITabBarSwappableImageView`，所以 `KYTabBarController` 在相关的接口命名时会包含 `SwappableImageView` 字样。另外，使用该特性需要 `pod update` 到 1.5.5以上的版本。

#### 如何实现添加选中背景色的功能 ，像下面这样：
<img width="409" alt="screen shot 2015-10-28 at 9 21 56 am" src="https://cloud.githubusercontent.com/assets/7238866/10777333/5d7811c8-7d55-11e5-88be-8cb11bbeaf90.png">

详情见 `KYTabBarControllerConfig`  类中下面方法的实现：

 ```Objective-C
/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController;

 ```


#  联系与建议反馈

>
> **weibo:** [http://weibo.com/balenn](http://weibo.com/balenn)
>
> **QQ:** 362108564
>

如果有任何你觉得不对的地方，或有更好的建议，以上联系都可以联系我。 十分感谢！



# 鼓励

它若不慎给您帮助，请不吝啬给它点一个**star**，是对它的最好支持，非常感谢！🙏


# LICENSE

KYTabBarController 被许可在 **MIT** 协议下使用。查阅 **LICENSE** 文件来获得更多信息。


