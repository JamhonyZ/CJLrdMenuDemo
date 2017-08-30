//
//  ViewController.m
//  CJLrdMenuDemo
//
//  Created by 创建zzh on 2017/6/8.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "ViewController.h"
#import "CJLrdMenu.h"
@interface ViewController ()

@property (nonatomic, strong)CJLrdMenu *menu;
@property (nonatomic, strong)NSArray *titleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    [self.view addSubview:self.menu];
    [self.menu startReloadData];
}


- (NSArray *)getMenuList:(NSString *)title menuCount:(NSInteger)count {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i<count; i++) {
        [arr addObject:[NSString stringWithFormat:@"%@%@",title,@(i)]];
    }
    return arr;
}
- (CJLrdMenu *)menu {
    if (!_menu) {
        _titleArr = @[@"标题一",@"标题二"];
        NSArray *list0 = [self getMenuList:_titleArr[0] menuCount:4];
        NSArray *list1 = [self getMenuList:_titleArr[1] menuCount:5];
        
        _menu = [[CJLrdMenu alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)
                                        topItems:_titleArr
                                        subItems:@[list0,list1]
                                     chooseBlock:^(NSInteger chooseMainIndex, NSInteger chooseSubIndex) {
            NSLog(@"选择标题:%@,列表：%@",@(chooseMainIndex),@(chooseSubIndex));
        }];
        _menu.ifNeedFoot = YES;
        _menu.titleNormalColor = [UIColor blueColor];
        _menu.titleSelectColor = [UIColor orangeColor];
        _menu.cellNormalColor = [UIColor blueColor];
        _menu.cellSelectColor = [UIColor orangeColor];
        _menu.defaultSubIndexArr = @[@"2",@"3"];
        _menu.ifNeedChangeTitle = NO;
        _menu.maxShowTbCellCount = 5;
    }
    return _menu;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
