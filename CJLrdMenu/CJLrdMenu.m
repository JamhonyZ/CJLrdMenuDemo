//
//  CJLrdMenu.m
//  XJCardPro
//
//  Created by 创建zzh on 2017/6/6.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "CJLrdMenu.h"
#import "UIButton+cjBtn.h"
#import "CJLrdMenu_Header.h"

#pragma mark -- /*****Cell******/

@implementation CJLrdMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mainBtn.frame = CGRectMake(0, 0, KCJScreenWidth, kSubMenuCellHeight);
        [_mainBtn setImage:[UIImage imageNamed:kSubMenuSelIconName] forState:UIControlStateSelected];
        [_mainBtn setImage:nil forState:UIControlStateNormal];
        _mainBtn.titleLabel.font = kFontSizeUse(15);
        [_mainBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGSize imageSize = [UIImage imageNamed:kSubMenuSelIconName].size;
        CGFloat pic_title_space = 5;
        _mainBtn.titleRect = CGRectMake(kSubTbCellLeft_Space+imageSize.width+pic_title_space, 0, CGRectGetWidth(_mainBtn.frame)-(kSubTbCellLeft_Space+imageSize.width+pic_title_space), CGRectGetHeight(_mainBtn.frame));
        _mainBtn.imageRect = CGRectMake(kSubTbCellLeft_Space, (CGRectGetHeight(_mainBtn.frame)-imageSize.height)/2, imageSize.width, imageSize.height);
        [self.contentView addSubview:_mainBtn];
        
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSubMenuCellHeight-1, CGRectGetWidth(_mainBtn.frame), 1)];
        lineView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
        [self.contentView addSubview:lineView];
    }
    return self;
}
- (void)clickBtn:(UIButton *)button {
    if (button.selected) {
        return;
    }
    if (self.selectMenuBlock) {
        self.selectMenuBlock(self.chooseMainIndex,self.chooseSubIndex);
    }
}
- (void)setIfChoose:(NSString *)ifChoose {
    _ifChoose = ifChoose;
    _mainBtn.selected = [ifChoose isEqualToString:@"1"];
    _mainBtn.backgroundColor = self.contentView.backgroundColor;
    switch (_selectType) {
        case kLrdSelectTypeNormal: {
            
        }
            break;
        case kLrdSelectTypeEnlarge: {
            NSTimeInterval deley = [ifChoose isEqualToString:@"1"] ? .1 : 0;
            [UIView animateWithDuration:deley animations:^{
                _mainBtn.titleLabel.font = [ifChoose isEqualToString:@"1"] ?kFontSizeUse(18):kFontSizeUse(15);
            }];
        }
            break;
        case kLrdSelectTypeDeviation: {
            
            NSTimeInterval deley = [ifChoose isEqualToString:@"1"] ? .2 : 0;
            [UIView animateWithDuration:deley animations:^{
                CGFloat left = [ifChoose isEqualToString:@"1"] ? 20 : 0;
                _mainBtn.frame = CGRectMake(left, 0, KCJScreenWidth-left, kSubMenuCellHeight);
            }];
        }
            break;
        case kLrdSelectTypeShadow: {
            UIColor *color = [ifChoose isEqualToString:@"1"] ? [UIColor colorWithRed:149/255.0f green:149/255.0f blue:149/255.0f alpha:0.4] : self.contentView.backgroundColor;
            _mainBtn.backgroundColor = color;
        }

        default:
            break;
    }
}
@end

#pragma mark -- /*****Menu******/

@interface CJLrdMenu ()<UITableViewDelegate,UITableViewDataSource>

/*基础控件*/
@property (nonatomic, strong)UIView *topItemView;
//存放标题
@property (nonatomic, strong)NSArray *topItemArr;
//存放列表数组
@property (nonatomic, strong)NSArray *subMenuArr;
//背景模糊
@property (nonatomic, strong)UIView *maskBgView;

//上一个选中的标题
@property (nonatomic, strong)UIButton *lastChooseTitle;
//上一个选中的列表
@property (nonatomic, strong)UITableView *lastChooseTbView;
//上一个标题索引
@property (nonatomic, assign)NSInteger lastMainIndex;
//上一个列表
@property (nonatomic, assign)NSInteger lastSubIndex;
//所有列表
@property (nonatomic, strong)NSMutableArray *subTbArr;
//所有标题
@property (nonatomic, strong)NSMutableArray *mainTitleArr;
//存放 选中的cell 列表
@property (nonatomic, strong)NSMutableArray *lrdModelArr;

@property (nonatomic, strong)UIView *tabBarMaskView;

@property (nonatomic, strong)UIButton *closeFootView;

@end


@implementation CJLrdMenu

- (instancetype)initWithFrame:(CGRect)frame
                     topItems:(NSArray *)topItemArr
                     subItems:(NSArray *)subMenuArr
                  chooseBlock:(CJMenuChooseBlock)chooseBlcok {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.chooseBlock = chooseBlcok;
        
        _titleNormalColor = kTitleNormalColor;
        _titleSelectColor = kTitleSelectColor;
        _cellNormalColor = kCellNormalColor;
        _cellSelectColor = kCellSelectColor;
        _titleIconRightSpace = kTitleIcon_rightSpace;
        //背景色
        self.backgroundColor = [UIColor whiteColor];
        
        //标题数量
        self.topItemArr = topItemArr.copy;
        
        //决定列表数组数量
        self.subMenuArr = subMenuArr.copy;
        
        _lastMainIndex = -1;
    }
    return self;
}


- (void)configTitleView {
    //标题
    CGFloat kItemW = self.frame.size.width/_topItemArr.count;
    for (int idx = 0; idx<_topItemArr.count; idx++) {
        NSString *obj = _topItemArr[idx];
        
        //存在赋值默认索引
        if (_defaultSubIndexArr.count == _topItemArr.count) {
            NSInteger defaultSubIndex = [_defaultSubIndexArr[idx] integerValue];
            if (defaultSubIndex <= ((NSArray *)_subMenuArr[idx]).count) {
                obj = [((NSArray *)_subMenuArr[idx]) objectAtIndex:defaultSubIndex];
            }
        }
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(idx*kItemW, 0, kItemW, self.frame.size.height);
        [titleBtn setTitle:obj forState:UIControlStateNormal];
        [titleBtn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        titleBtn.titleLabel.font = kFontSizeUse(15);
        titleBtn.tag = 1000+idx;
        [titleBtn setImage:kArrowLrdMenuDown forState:UIControlStateNormal];
        [titleBtn setImage:kArrowLrdMenuUp forState:UIControlStateSelected];
        
        CGSize imageSize = kArrowLrdMenuDown.size;
        
        titleBtn.titleRect = CGRectMake(0, 0, CGRectGetWidth(titleBtn.frame)-_titleIconRightSpace-imageSize.width, CGRectGetHeight(titleBtn.frame));
        
        titleBtn.imageRect = CGRectMake(CGRectGetWidth(titleBtn.frame)-imageSize.width-_titleIconRightSpace, (CGRectGetHeight(titleBtn.frame)-imageSize.height)/2, imageSize.width, imageSize.height);
        
        titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleBtn];
        
        [self.mainTitleArr addObject:titleBtn];
        
        [titleBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        if (idx != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 1, CGRectGetHeight(titleBtn.frame)-10)];
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
            [titleBtn addSubview:lineView];
        }
    }
    
    
    //分割线
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, KCJScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    [self addSubview:lineView];
}


- (void)configTbView {
    //列表
    CGFloat kTbWidth = CGRectGetWidth(self.frame);
    
    for (int i = 0; i<_subMenuArr.count; i++) {
        UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.frame),kTbWidth , 0) style:UITableViewStylePlain];
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.rowHeight = 44;
        tbView.backgroundColor = [UIColor whiteColor];
        tbView.tag = kTbBasicTag+i;
        tbView.dataSource = self;
        tbView.delegate = self;
        [tbView registerClass:[CJLrdMenuCell class] forCellReuseIdentifier:[self creatTbCellIden:tbView.tag]];
        
        [self.subTbArr addObject:tbView];
        
        if (i == 0) {
            self.lastChooseTbView = tbView;
        }
        
        if (self.superview) {
            [self.superview insertSubview:tbView aboveSubview:self];
        }
        
        
        
        //组装是否选择的模型
        __block NSMutableArray *models = @[].mutableCopy;
        NSArray *subMenuArr = _subMenuArr[i];
        NSString *defaultIndexStr = self.defaultSubIndexArr?self.defaultSubIndexArr[i]:@"0";
        NSInteger defaultIndex = [defaultIndexStr integerValue];
        if (defaultIndex >= subMenuArr.count) {
            NSLog(@"默认传入索引值越界");
        }
        [subMenuArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ifChoose = (idx == defaultIndex)?@"1":@"0";
            [models addObject:ifChoose];
        }];
        [self.lrdModelArr addObject:models];
        
        //加载
        [tbView reloadData];
        
    }
    
    if (_ifNeedFoot) {
        [self.superview addSubview:self.closeFootView];
    }
}
#pragma mark -- set
- (void)setIfShowTabBarMask:(BOOL)ifShowTabBarMask {
    _ifShowTabBarMask = ifShowTabBarMask;
}

- (void)setDefaultSubIndexArr:(NSArray *)defaultSubIndexArr {
    _defaultSubIndexArr = defaultSubIndexArr;
}
#pragma mark -- Action
- (void)startReloadData {
    [self configTitleView];
    [self configTbView];
}
- (NSString *)creatTbCellIden:(NSInteger)tag {
    return [NSString stringWithFormat:@"CJLrdMenuListCell%@",@(tag)];
}
- (void)clickBtnAction:(UIButton *)btn {
    [self changeTitleItem:btn.tag - 1000];
}
- (void)changeTitleItem:(NSInteger)index {
    if (_lastMainIndex == index) {
        NSLog(@"重复点击同一个");
        [self stopChooseAction];
        return;
    }
    NSLog(@"切换");
    _lastMainIndex = index;
    //改变显示的列表
    [self showTbView:index];
    
    
    //上一个选中的标题
    _lastChooseTitle.selected = NO;
    [_lastChooseTitle setImage:kArrowLrdMenuDown forState:UIControlStateNormal];
    _lastChooseTitle.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView animateWithDuration:kAnimateTime animations:^{
        _lastChooseTitle.imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    //即将选中的标题
    UIButton *currentTitleBtn = self.mainTitleArr[_lastMainIndex];
    currentTitleBtn.selected = YES;
    [currentTitleBtn setImage:kArrowLrdMenuUp forState:UIControlStateNormal];
    currentTitleBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView animateWithDuration:kAnimateTime animations:^{
        currentTitleBtn.imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.lastChooseTitle = currentTitleBtn;
    }];
    
    
}

- (void)showTbView:(NSInteger)index {
    [self hiddenTbView:YES];
    
    UITableView *currentTbView = self.subTbArr[index];
    [self.superview bringSubviewToFront:currentTbView];
    _lastChooseTbView = currentTbView;
    [self.superview insertSubview:self.maskBgView belowSubview:_lastChooseTbView];
    
    if (_ifShowTabBarMask) {
        [[[UIApplication sharedApplication].delegate window] addSubview:self.tabBarMaskView];
    }
    //开始动画
    [UIView animateWithDuration:kAnimateTime*1.2 animations:^{
        CGFloat kTbWidth = CGRectGetWidth(self.frame);
        currentTbView.frame = CGRectMake(0,CGRectGetMaxY(self.frame),kTbWidth,kTbViewHeight);
        self.maskBgView.alpha = 1;
        
        if (_ifNeedFoot) {
            self.closeFootView.alpha = 1;
            
            self.closeFootView.frame = CGRectMake(0,CGRectGetMaxY(self.frame)+kTbViewHeight, CGRectGetWidth(self.frame), 20);
            
            [self.superview bringSubviewToFront:self.closeFootView];
        }
        
        if (_ifShowTabBarMask) {
            self.tabBarMaskView.alpha = 1;
        }
    } completion:^(BOOL finished) {
    }];
}
- (void)hiddenTbView:(BOOL)ifChange {
    
    if (ifChange) {
        [UIView animateWithDuration:kAnimateTime/4 animations:^{
            CGFloat kTbWidth = CGRectGetWidth(self.frame);
            self.lastChooseTbView.frame = CGRectMake(0,CGRectGetMaxY(self.frame),kTbWidth,0);
            
            if (self.ifNeedFoot) {
                self.closeFootView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0);
                self.closeFootView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.closeFootView.alpha = 0;
        [UIView animateWithDuration:kAnimateTime/2 animations:^{
            CGFloat kTbWidth = CGRectGetWidth(self.frame);
            self.lastChooseTbView.frame = CGRectMake(0,CGRectGetMaxY(self.frame),kTbWidth,0);
            if (self.ifNeedFoot) {
                self.closeFootView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0);
                
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (void)stopChooseAction {
    
    self.maskBgView.alpha = 0;
    [self.tabBarMaskView removeFromSuperview];
    
    _lastMainIndex = -1;
    
    //上一个选中的标题
    _lastChooseTitle.selected = NO;
    [_lastChooseTitle setImage:kArrowLrdMenuDown forState:UIControlStateNormal];
    _lastChooseTitle.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView animateWithDuration:kAnimateTime animations:^{
        _lastChooseTitle.imageView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        _lastChooseTitle = nil;
    }];
    
    [self hiddenTbView:NO];
}
#pragma mark -- TbDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *menuStrArr = self.subMenuArr[tableView.tag-kTbBasicTag];
    return menuStrArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJLrdMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[self creatTbCellIden:tableView.tag]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.chooseMainIndex = tableView.tag-kTbBasicTag;
    cell.chooseSubIndex = indexPath.row;
    [cell.mainBtn setTitleColor:_cellNormalColor forState:UIControlStateNormal];
    [cell.mainBtn setTitleColor:_cellSelectColor forState:UIControlStateSelected];
    cell.selectType = self.selectType;
    NSMutableArray *models = self.lrdModelArr[tableView.tag - kTbBasicTag];
    @weakify(self);
    cell.selectMenuBlock = ^(NSInteger chooseMainIndex,NSInteger chooseSubIndex){
        @strongify(self);
       
        self.lastMainIndex = chooseMainIndex;
        self.lastSubIndex = chooseSubIndex;

        //刷新
        [self refreshModels:chooseSubIndex];

        //传值
        if (self.chooseBlock) {
            self.chooseBlock(chooseMainIndex,chooseSubIndex);
            
            UIButton *chooseBtn = self.mainTitleArr[chooseMainIndex];
            NSArray *titleArr = self.subMenuArr[chooseMainIndex];
            NSString *title = titleArr[chooseSubIndex];
            [chooseBtn setTitle:title forState:UIControlStateNormal];
            
        }
        [self stopChooseAction];
    };
    
    //配置
    NSArray *menuStrArr = self.subMenuArr[tableView.tag-kTbBasicTag];
    if (menuStrArr.count>indexPath.row) {
        NSString *str = menuStrArr[indexPath.row];
        [cell.mainBtn setTitle:str forState:UIControlStateNormal];
        [cell.mainBtn setTitle:str forState:UIControlStateSelected];
    }

    cell.ifChoose = models[indexPath.row];
    
    return cell;
}

- (void)refreshModels:(NSInteger)currentChooseIndex {
    
    NSMutableArray *models = self.lrdModelArr[self.lastMainIndex];
    //重新赋值模型
    NSInteger lastChooseIndex = 0;
    NSMutableArray *newModels = @[].mutableCopy;
    for (int i = 0; i<models.count; i++) {
        NSString *lastIfChoose = models[i];
        if ([lastIfChoose isEqualToString:@"1"]) {
            //记录旧的选中索引
            lastChooseIndex = i;
        }
        //赋值新状态
        NSString *ifChoose = (i == currentChooseIndex)?@"1":@"0";
        [newModels addObject:ifChoose];
    }
    [models removeAllObjects];
    [models addObjectsFromArray:newModels];
    
    //刷新
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:lastChooseIndex inSection:0];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:currentChooseIndex inSection:0];
    [self.lastChooseTbView reloadRowsAtIndexPaths:@[oldIndexPath,newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- LazyLoad
- (UIView *)maskBgView {
    if (!_maskBgView) {
        
        _maskBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.superview.frame)-CGRectGetMaxY(self.frame))];
        _maskBgView.backgroundColor = [UIColor colorWithRed:149/255.0f green:149/255.0f blue:149/255.0f alpha:0.4];
        _maskBgView.alpha = 0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopChooseAction)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [_maskBgView addGestureRecognizer:tap];
    }
    return _maskBgView;
}
- (UIView *)tabBarMaskView {
    if (!_tabBarMaskView) {
        _tabBarMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, KCJScreenHeight-49, CGRectGetWidth(self.frame), 49)];
        _tabBarMaskView.backgroundColor = [UIColor colorWithRed:149/255.0f green:149/255.0f blue:149/255.0f alpha:0.4];
        
        _tabBarMaskView.alpha = 0;
  
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopChooseAction)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [_tabBarMaskView addGestureRecognizer:tap];
    }
    return _tabBarMaskView;
}

- (UIButton *)closeFootView {
    if (!_closeFootView) {
        _closeFootView = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeFootView.frame = CGRectMake(0, kTbViewHeight+CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0);
        [_closeFootView setTitle:@"000⌒∩⌒000" forState:UIControlStateNormal];
        _closeFootView.titleLabel.font = kFontSizeUse(13);
        [_closeFootView setTitleColor:UIColorHex(0x666666) forState:UIControlStateNormal];

        [_closeFootView addTarget:self action:@selector(stopChooseAction) forControlEvents:UIControlEventTouchUpInside];
        _closeFootView.backgroundColor = self.backgroundColor;
        
        _closeFootView.alpha = 0;
    }
    return _closeFootView;
}
- (NSMutableArray *)subTbArr {
    if (!_subTbArr) {
        _subTbArr = @[].mutableCopy;
    }
    return _subTbArr;
}
- (NSMutableArray *)mainTitleArr {
    if (!_mainTitleArr) {
        _mainTitleArr = @[].mutableCopy;
    }
    return _mainTitleArr;
}
- (NSMutableArray *)lrdModelArr {
    if (!_lrdModelArr) {
        _lrdModelArr = @[].mutableCopy;
    }
    return _lrdModelArr;
}

@end
