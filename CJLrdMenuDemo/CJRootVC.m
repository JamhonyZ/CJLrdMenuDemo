//
//  CJRootVC.m
//  CJLrdMenuDemo
//
//  Created by 创建zzh on 2017/6/8.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "CJRootVC.h"
#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface CJRootVC ()
@property (nonatomic, strong) UIViewController *vc;
@end

@implementation CJRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self addChildsVc];
    
}
- (void)addChildsVc
{
    
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"HomeViewController",
                                   kTitleKey  : @"首页",
                                   kImgKey    : @"tab_home",
                                   kSelImgKey : @"tab_home_select"},
                                 
                                 @{kClassKey  : @"UIViewController",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"tab_mine",
                                   kSelImgKey : @"tab_mine_select"}];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        self.vc = [[NSClassFromString(dict[kClassKey]) alloc]init];
        self.vc.title = dict[kTitleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
        
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
