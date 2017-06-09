//
//  HomeViewController.m
//  CJLrdMenuDemo
//
//  Created by 创建zzh on 2017/6/8.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "HomeViewController.h"
#import "CJLrdMenu.h"
@interface HomeViewController ()

@property (nonatomic, strong)CJLrdMenu *menu;
@property (nonatomic, strong)NSArray *titleArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.menu];
    [self.menu startReloadData];
}



- (CJLrdMenu *)menu {
    if (!_menu) {
        _titleArr = @[@"标题一",@"标题二",@"标题三"];
        NSArray *list0 = [self getMenuList:_titleArr[0] menuCount:4];
        NSArray *list1 = [self getMenuList:_titleArr[1] menuCount:4];
        NSArray *list2 = [self getMenuList:_titleArr[2] menuCount:4];
        _menu = [[CJLrdMenu alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 44)
                                        topItems:_titleArr
                                        subItems:@[list0,list1,list2]
                                     chooseBlock:^(NSInteger chooseMainIndex, NSInteger chooseSubIndex) {
                                         NSLog(@"选择标题:%@,列表：%@",@(chooseMainIndex),@(chooseSubIndex));
                                     }];
        //_menu.selectType = kLrdSelectTypeShadow;
        //_menu.ifShowTabBarMask = YES;
        //_menu.ifNeedFoot = YES;
        //_menu.defaultSubIndexArr = @[@"2",@"3",@"1"];
        //_menu.titleIconRightSpace = 15;
    }
    return _menu;
}


- (NSArray *)getMenuList:(NSString *)title menuCount:(NSInteger)count {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i<count; i++) {
        [arr addObject:[NSString stringWithFormat:@"%@%@",title,@(i)]];
    }
    return arr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
