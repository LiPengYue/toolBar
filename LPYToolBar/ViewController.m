//
//  ViewController.m
//  LPYToolBar
//
//  Created by 李鹏跃 on 17/2/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "PYToolBarView.h"
@interface ViewController ()
@property (nonatomic,strong) PYToolBarView *toolBarView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建
    self.toolBarView = [[PYToolBarView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30) andOptionStrArray:@[@"有",@"美",@"女"]];
    //添加
    [self.view addSubview:self.toolBarView];
    
    
    //加一个button
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(200, 200, 200, 200);
    [self.view addSubview:button];
    [button setTitle:@"变" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setupToolBarView) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setupToolBarView {
    //默认的选中下标
    self.toolBarView.selectItemIndex = 0;
    _toolBarView.itemBottomBarViewHeight = 30;
   
    //自定义toolBar的view
    [_toolBarView setSetUpItemSelectBarViewBlock:^(UIView *barView) {
        barView.backgroundColor = [UIColor colorWithRed:.4 green:.3 blue:.6 alpha:.7];
        UIImageView *imageView = [[UIImageView alloc]init];
        [barView addSubview: imageView];
        imageView.frame = CGRectMake(13, barView.frame.size.height / 2 - 3.5, 12, 7);
        imageView.image = [UIImage imageNamed:@"jiantou"];
    }];
    //toolBar的item的秒数的颜色设置
    _toolBarView.itemTextColor_Normal = [UIColor colorWithRed:.5 green:.6 blue:.7 alpha:1];
    _toolBarView.itemTextColor_Select = [UIColor whiteColor];
    _toolBarView.itemTextColor_Highlighted = [UIColor colorWithRed:.7 green:.5 blue:.9 alpha:1];
    //点击事件的回调
    [self.toolBarView setClickOptionItemBlock:^(UIButton *item, NSString *text, NSInteger index) {
        NSLog(@"%@",@(index));
    }];
    self.toolBarView.lineHeight = 17;
    self.toolBarView.lineColor = [UIColor colorWithRed:.4 green:.5 blue:.7 alpha:.9];
    //重绘
     _toolBarView.optionStrArray = @[@"是",@"真",@"的",@"吗"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
