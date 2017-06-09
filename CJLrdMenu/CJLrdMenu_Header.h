//
//  CJLrdMenu_Header.h
//  CJLrdMenuDemo
//
//  Created by 创建zzh on 2017/6/9.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#ifndef CJLrdMenu_Header_h
#define CJLrdMenu_Header_h

#pragma mark -- 宏配置
//cell高度
static CGFloat const kSubMenuCellHeight = 44.f;
//cell选中的打钩图片
static NSString *const kSubMenuSelIconName = @"ser_choice";
//下拉列表弹出收起动画时间
static NSTimeInterval const kAnimateTime = .25f;
//tableView高度
static CGFloat const kTbViewHeight = kSubMenuCellHeight*4;
//标题图片距离左侧距离（默认标题为去除图片之后居中）
static CGFloat const kTitleIcon_rightSpace = 10.f;
//列表图片距离左侧距离
static CGFloat const kSubTbCellLeft_Space = 30.f;
//列表的tag值
static NSInteger const kTbBasicTag = 100;

//标题未选中的图片
#define kArrowLrdMenuDown [UIImage imageNamed:@"lrdMenu_arrow_down"]
//标题选中的图片
#define kArrowLrdMenuUp [UIImage imageNamed:@"lrdMenu_arrow_up"]

//颜色状态
#define kTitleNormalColor [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1]
#define kTitleSelectColor [UIColor colorWithRed:0/255.0f green:179/255.0f blue:138/255.0f alpha:1]
#define kCellNormalColor [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]
#define kCellSelectColor  [UIColor colorWithRed:0/255.0f green:179/255.0f blue:138/255.0f alpha:1]

#pragma mark --- 宏

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#define KCJScreenWidth [UIScreen mainScreen].bounds.size.width
#define KCJScreenHeight [UIScreen mainScreen].bounds.size.height
#define KCJScreenBounds [UIScreen mainScreen].bounds

// 设置颜色 示例：UIColorHex(0x26A7E8)
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kFontSizeUse(num) [UIFont fontWithName:@"PingFangSC-Regular" size:num]


#endif /* CJLrdMenu_Header_h */
