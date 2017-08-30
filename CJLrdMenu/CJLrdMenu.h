//
//  CJLrdMenu.h
//  XJCardPro
//
//  Created by 创建zzh on 2017/6/6.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark -- block&enum

typedef void(^CJMenuChooseBlock)(NSInteger chooseMainIndex,NSInteger chooseSubIndex);


typedef NS_ENUM(NSUInteger, CJLrdSelectMenuType) {
    kLrdSelectTypeNormal,        //选中图片加文字变色
    kLrdSelectTypeEnlarge,       //选中放大
    kLrdSelectTypeDeviation,     //选中偏移
    kLrdSelectTypeShadow,        //选中后背景变阴影
};

/******Cell********/
#pragma mark -- Cell
@interface CJLrdMenuCell : UITableViewCell
//操作按钮
@property (nonatomic, strong)UIButton *mainBtn;
//所在主索引
@property (nonatomic, assign)NSInteger chooseMainIndex;
//所在子索引
@property (nonatomic, assign)NSInteger chooseSubIndex;
//选中显示样式
@property (nonatomic, assign)CJLrdSelectMenuType selectType;
//选中状态
@property (nonatomic, copy)NSString *ifChoose;
//选择反馈
@property (nonatomic, copy)void(^selectMenuBlock)(NSInteger chooseMainIndex,NSInteger chooseSubIndex);

@end


/******UIView*********/
#pragma mark -- Menu
@interface CJLrdMenu : UIView

//回调
@property (nonatomic, copy)CJMenuChooseBlock chooseBlock;

#pragma mark -- 初始化 第一步
/**
 *  topItemArr: 标题数组
 *  subMenuArr: 包含列表数组的数组
 */
- (instancetype)initWithFrame:(CGRect)frame
                     topItems:(NSArray *)topItemArr
                     subItems:(NSArray *)subMenuArr
                  chooseBlock:(CJMenuChooseBlock)chooseBlcok;

#pragma mark -- 最后一步
//开始加载数据 在确保menu添加到父视图之后 调用 ，并且配置好各属性
- (void)startReloadData;

/*****可配置属性******/
#pragma mark -- 第二步 可配置属性
//如果是标签页面，UI需要遮盖 标签栏 赋值为YES
@property (nonatomic, assign)BOOL ifShowTabBarMask;

//是否需要底部收起的按钮
@property (nonatomic, assign)BOOL ifNeedFoot;

//标题图片距离等分控件 右侧间距
@property (nonatomic, assign)NSInteger titleIconRightSpace;

/**
 * 默认的条件索引 传入数组,需要和 topItemArr 数量一致
 * _menu.defaultSubIndexArr = @[@"2",@"3",@"1"];
 */
@property (nonatomic, strong)NSArray *defaultSubIndexArr;

//默认为YES，标题随着下面的选项变更的。设置为NO，则标题不变。
@property (nonatomic, assign)BOOL ifNeedChangeTitle;

//下拉框可见cell的最大个数 默认是4个
@property (nonatomic, assign)NSInteger maxShowTbCellCount;

@property (nonatomic, strong)UIColor *titleNormalColor;
@property (nonatomic, strong)UIColor *titleSelectColor;
@property (nonatomic, strong)UIColor *cellNormalColor;
@property (nonatomic, strong)UIColor *cellSelectColor;


//选中之后的样式
@property (nonatomic, assign)CJLrdSelectMenuType selectType;

@end
