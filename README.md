# toolBar


>toolBar很常用，所以做了个工具类扩展性很好
![](http://upload-images.jianshu.io/upload_images/4185621-c360e3a12044bdf7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
# 基本介绍：
**一、写了两个创建方法**
```
+ (instancetype)toolBarViewWithFrame:(CGRect)frame andOptionStrArray:(NSArray<NSString *> *)optionStrArray;
- (instancetype)initWithFrame:(CGRect)frame andOptionStrArray:(NSArray<NSString *> *)optionStrArray;
```
**二、其实你直接这样创建就会出来这种效果：**


```
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建
    self.toolBarView = [[PYToolBarView alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 30) andOptionStrArray:@[@"有",@"美",@"女"]];
    //添加
    [self.view addSubview:self.toolBarView];
}
```

**三、里面有很多属性可以设置下面来看看：**

**1. 点击事件的回调**
```
/**item点击事件回调*/
@property (nonatomic,copy) void(^clickOptionItemBlock)(UIButton *button,NSString *itemText, NSInteger index);
````
**2. 选中的索引**
>修改了这个值，那么选中的item也会跟着变
```
/**选中的item索引*/
@property (nonatomic,assign) NSInteger selectItemIndex;
```

**3. toolBar选项描述的集合**
>改变这个将会重绘，并且自动生成相应的toolBar
```
/**
 * item描述的集合
 * 这个程序根据这个属性进行划线和分配item
 */
@property (nonatomic,strong) NSArray <NSString *>* optionStrArray;
```

**4. show方法**
>其实optionStrArray这个属性中默认调用了这个方法
```
//重绘
/**展示toolBar*/
- (void)show;
```

# 可扩展的重要属性
**一、线的一些属性**
1. 每个item你都可以拿到
```
/**
 * 储存了optionItem的button
 * Button的tag值加了1000
 */
@property (nonatomic,strong,readonly) NSArray <UIButton *>* optionItemInfo;
```
2. item文本的颜色
>都有默认值
```
/**item的颜色*/
@property (nonatomic,strong) UIColor *itemTextColor_Select;
@property (nonatomic,strong) UIColor *itemTextColor_Normal;
@property (nonatomic,strong) UIColor *itemTextColor_Highlighted;
```
3. 重复点击是否有效
```
/**button是否可以重复点击*/
@property (nonatomic,assign) BOOL isRecurClickItem;
```

**二、自定义背景的View**
1. block回调的view
>这个用了一个block回调了一个UIVeiw，这个view就是上面图片中的蓝色的VIew
有了这个view，你就可以干所有的事情了
```
/**关于item底部的view自定义*/
@property (nonatomic,copy) void(^setUpItemSelectBarViewBlock)(UIView *barView);
```
2. 另外不想自定义只想小调一下那么看这里
```
 /*
  item默认的底部的barView
   view默认是隐藏的
   view具有默认样式
 */
@property (nonatomic,assign) CGFloat itemBottomBarViewWidth;//宽度默认与item等宽
@property (nonatomic,assign) CGFloat itemBottomBarViewHeight;//高度默认是2dp
//颜色默认蓝(r:0.29 g:0.56 b:0.89 a:1.00)
@property (nonatomic,strong) UIColor *itemBottomBarViewColor;
```

**三、实战**
>1. 从这样
![](http://upload-images.jianshu.io/upload_images/4185621-794183e5254c5d34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
2. 点一下变这样
![](http://upload-images.jianshu.io/upload_images/4185621-807af219a5ebb9cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
