//
//  PYToolView.m
//  Prome
//
//  Created by 李鹏跃 on 17/2/9.
//  Copyright © 2017年 品一. All rights reserved.
//

#import "PYToolBarView.h"

@interface PYToolBarView ()
@property(nonatomic,assign) CGFloat spacing;//
@property (nonatomic,strong) NSArray <NSValue *>*lineArray;//线的集合（位置大小）
@property (nonatomic,strong) NSMutableArray <NSDictionary *>*optionArray;//button的位置及名称集合
@property (nonatomic,strong) NSMutableArray <NSValue *>*optionRectArrayM;
//记忆选中的Button
@property (nonatomic,strong) UIButton *selectItem;
@end

@implementation PYToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame andOptionStrArray:(NSArray<NSString *> *)optionStrArray {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.optionStrArray = optionStrArray;
    }
    return self;
}
+ (instancetype)toolBarViewWithFrame:(CGRect)frame andOptionStrArray:(NSArray<NSString *> *)optionStrArray {
    return [[self alloc]initWithFrame:frame andOptionStrArray:optionStrArray];
}


#pragma mark - 展示
- (void)show {
    //MARK: 如果没有值那么就强制刷新
    if (!self.frame.size.width) {
        [self layoutIfNeeded];
    }
    //选项Button的宽度
    _optionWidth = (self.frame.size.width - (self.optionStrArray.count - 1) * self.lineWidth) / self.optionStrArray.count;
    //线的信息数组
    [self setLineArrayInfo];
    
    //设置选项的信息
    [self setOptionItemArrayInfo];
    
    //创建button
    [self setSubButton];
    
    //重绘
    [self setNeedsDisplay];
}


#pragma mark - setter方法 及小方法：
//计算了画线的信息（CGRect）
- (void) setOptionStrArray:(NSArray<NSString *> *)optionStrArray {
    _optionStrArray = optionStrArray;
    //清除数据
    self.itemBottomBarViewWidth = 0;
    [self show];
}


#pragma mark - 画线
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(!self.optionStrArray.count) return;//没数据有返回
    for (int i = 0; i < self.lineArray.count; i++) {
        //划线
        [self.lineColor setFill];
        UIRectFill(self.lineArray[i].CGRectValue);
    }
}


#pragma mark - 设置一些线/选项 信息
//MARK: 设置线的信息数组
- (void)setLineArrayInfo{
    NSMutableArray *lineArrayM = [[NSMutableArray alloc]init];
    for (int i = 1; i < self.optionStrArray.count; i++) {
        //线的XY坐标
        CGFloat lineX = (i * self.optionWidth) + ((i - 1) * self.lineWidth);
        CGFloat lineY = (self.frame.size.height - self.lineHeight) /2;
        CGRect lineRect = CGRectMake(lineX, lineY, self.lineWidth, self.lineHeight);
        [lineArrayM addObject:[NSValue valueWithCGRect:lineRect]];
    }
    self.lineArray = lineArrayM.copy;
}

//设置选项信息数组
- (void)setOptionItemArrayInfo {
    //放入了item的坐标和标题
    NSMutableArray <NSDictionary *>*optionArrayM = [[NSMutableArray alloc]initWithCapacity:self.optionStrArray.count];
    NSMutableArray <NSValue *>*optionRectArrayM = [[NSMutableArray alloc] init];
   
    for (int i = 0; i < self.optionStrArray.count; i++) {
        CGFloat opstionX = i * (self.lineWidth + self.optionWidth);
        CGFloat opstionY = 0;
        CGRect opstionRect = CGRectMake(opstionX, opstionY, self.optionWidth, self.frame.size.height);
        NSValue *optionRectValue = [NSValue valueWithCGRect:opstionRect];
        NSString *optionStr = self.optionStrArray[i];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjects:@[optionRectValue,optionStr] forKeys:@[@"optionRectValue",@"optionStr"]];
        //添加
        [optionRectArrayM addObject:optionRectValue];
        [optionArrayM addObject:dic];
    }
    //copy
    self.optionRectArrayM = optionRectArrayM.copy;
    self.optionArray = optionArrayM.copy;
}

//添加button
- (void)setSubButton {
    //如果有子控件那么移除
    //MAKR: 注意，这里的self.subviews是动态的获取子控件，别管坐标了。直接给0
    if (self.subviews.count) {
        //记录子控件的个数，不要直接去取
        NSInteger j = self.subviews.count;
        for (NSInteger i = 0; i < j; i ++) {
            //直接取第0个元素，不然会数组越界
            [self.subviews[0] removeFromSuperview];
        }
    }
    
    NSMutableArray <UIButton *>*optionItemInfoM = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.optionStrArray.count; i ++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i + 1000;
        [self addSubview:button];
        button.frame = self.optionRectArrayM[i].CGRectValue;
        [button setTitle:self.optionStrArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:self.itemTextColor_Normal forState:UIControlStateNormal];
        [button setTitleColor:self.itemTextColor_Select forState:UIControlStateSelected];
        [button setTitleColor:self.itemTextColor_Highlighted forState:UIControlStateHighlighted];
        //对齐方法
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        //是否变灰
        button.showsTouchWhenHighlighted = self.showsTouchWhenHighlighted;
        //点击事件的添加
        [button addTarget:self action:@selector(clickOptionItem:) forControlEvents:UIControlEventTouchUpInside];
        //添加view的条
        UIView *barView = [[UIView alloc]init];
        //宽度 坐标
        CGFloat barViewX = (button.frame.size.width - self.itemBottomBarViewWidth) / 2;
        CGFloat barViewY = button.frame.size.height - self.itemBottomBarViewHeight;
        barView.frame = CGRectMake(barViewX, barViewY, self.itemBottomBarViewWidth, self.itemBottomBarViewHeight);
        barView.backgroundColor = self.itemBottomBarViewColor;
       
        if (self.setUpItemSelectBarViewBlock) {
            self.setUpItemSelectBarViewBlock (barView);
        }
        barView.hidden = YES;
        [button insertSubview:barView atIndex:0];
        barView.tag = 2000;
        //设置默认的选中的item
        if (i == self.selectItemIndex) {
            button.selected = YES;
            self.selectItem = button;
            barView.hidden = NO;
        }
        [optionItemInfoM arrayByAddingObject:button];
    }
    _optionItemInfo = optionItemInfoM.copy;
}

//MARK:button的点击事件
- (void)clickOptionItem: (UIButton *)button {
    if (self.selectItem == button && !self.isRecurClickItem) return;
    
    self.selectItemIndex = button.tag - 1000;
    if (self.clickOptionItemBlock) {
        self.clickOptionItemBlock(button,self.optionStrArray[button.tag - 1000],button.tag - 1000);
    }
}


#pragma mark - 设置了readonly属性所以重写方法返回NO，防止外部KVC
+ (BOOL)accessInstanceVariablesDirectly{
    return NO;
}

#pragma mark - 懒加载 对某些属性做了默认值处理
//设置初始值

//MARK: 设置----------------line---------------------
- (CGFloat)lineWidth {
    if (!_lineWidth) {
        _lineWidth = .5;
    }
    return _lineWidth;
}
- (CGFloat)lineHeight {
    if (!_lineHeight) {
        if (!self.frame.size.height) [self layoutIfNeeded];//没有值就刷新UI
        _lineHeight = self.frame.size.height;
    }
    return _lineHeight;
}
- (NSArray <NSValue *>*)lineArray {
    if (!_lineArray) {
        _lineArray = [[NSArray alloc] init];
    }
    return _lineArray;
}


//MARK: 设置----------------item---------------------
- (NSMutableArray <NSDictionary *>*)optionArray {
    if (!_optionArray) {
        _optionArray = [[NSMutableArray alloc]init];
    }
    return _optionArray;
}
- (NSMutableArray <NSValue *>*)optionRectArrayM {
    if (!_optionRectArrayM) {
        _optionRectArrayM = [[NSMutableArray alloc]init];
    }
    return _optionRectArrayM;
}

- (UIColor *)itemTextColor_Normal {
    if (!_itemTextColor_Normal) {
        _itemTextColor_Normal = [UIColor blackColor];
    }
    return _itemTextColor_Normal;
}
- (UIColor *)itemTextColor_Highlighted {
    if (!_itemTextColor_Highlighted) {
        _itemTextColor_Highlighted = self.itemTextColor_Normal;
    }
    return _itemTextColor_Highlighted;
}
- (UIColor *)itemTextColor_Select {
    if (!_itemTextColor_Select) {
        _itemTextColor_Select = self.itemTextColor_Normal;
    }
    return _itemTextColor_Select;
}


//MARK: 设置----------------itemButtom---------------------
- (CGFloat)itemBottomBarViewHeight {
    if (!_itemBottomBarViewHeight) {
        _itemBottomBarViewHeight = 2;
    }
    return _itemBottomBarViewHeight;
}
- (CGFloat)itemBottomBarViewWidth {
    if (!_itemBottomBarViewWidth) {
        _itemBottomBarViewWidth = self.optionRectArrayM[0].CGRectValue.size.width;
    }
    return _itemBottomBarViewWidth;
}
- (UIColor *)itemBottomBarViewColor {
    if (!_itemBottomBarViewColor) {
        //(r:0.29 g:0.56 b:0.89 a:1.00)
        _itemBottomBarViewColor = [UIColor colorWithRed:0.29 green:0.56 blue:0.89 alpha:1];
    }
    return _itemBottomBarViewColor;
}

//MARK: ------------------选中的item------------------------
- (void)setSelectItemIndex:(NSInteger)selectItemIndex {
    _selectItemIndex = selectItemIndex;
    self.selectItem = [self viewWithTag:selectItemIndex + 1000];
}
- (void)setSelectItem:(UIButton *)selectItem {
    if (!_selectItem || _selectItem == selectItem) {
        _selectItem = selectItem;
        _selectItem.hidden = NO;
        return;
    }
    
    [_selectItem viewWithTag:2000].hidden = YES;
    _selectItem.selected = NO;
    
    _selectItem = selectItem;
    
    [_selectItem viewWithTag:2000].hidden = NO;
    _selectItem.selected = YES;
}
@end
