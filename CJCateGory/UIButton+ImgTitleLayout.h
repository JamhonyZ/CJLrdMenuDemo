//
//  UIButton+ImgTitleLayout.h
//  EasyGo
//
//  Created by ZZH on 16/12/13.
//  Copyright © 2016年 Lotto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImgTitleLayout)
/**
 *
 * UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
 * [btn setImage:[UIImage imageNamed:@"右边图片"] forState:UIControlStateNormal];
 * [btn setTitle:@"我在图片的左边啊" forState:UIControlStateNormal];
 * btn.titleRect = CGRectMake(0, 0, btn.width/2, btn.height);
 * btn.imageRect = CGRectMake(btn.width/2, 0, btn.width/2, btn.height);
 *
 */

/**
 *  文字相对于按钮的的位置
 */
@property (nonatomic,assign) CGRect titleRect;
/**
 *  图片相对于按钮的的位置
 */
@property (nonatomic,assign) CGRect imageRect;

@end
