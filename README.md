# CJLrdMenuDemo

简易的控制器页面设置标题栏，点击后弹出悬浮屏幕的列表。

第一步：init初始化创建
/**
 *  topItemArr: 标题数组
 *  subMenuArr: 包含列表数组的数组
 */
- (instancetype)initWithFrame:(CGRect)frame
                     topItems:(NSArray *)topItemArr
                     subItems:(NSArray *)subMenuArr
                  chooseBlock:(CJMenuChooseBlock)chooseBlcok
                  
第二步: 相关配置
//如果是标签页面，UI需要遮盖 标签栏 赋值为YES
@property (nonatomic, assign)BOOL ifShowTabBarMask;
//是否需要底部收起的按钮
@property (nonatomic, assign)BOOL ifNeedFoot;
//标题图片距离等分控件 右侧间距
@property (nonatomic, assign)NSInteger titleIconRightSpace;
/**
 * 默认的条件索引 传入数组
 * _menu.defaultSubIndexArr = @[@"2",@"3",@"1"];
 */
@property (nonatomic, strong)NSArray *defaultSubIndexArr;
@property (nonatomic, strong)UIColor *titleNormalColor;
@property (nonatomic, strong)UIColor *titleSelectColor;
@property (nonatomic, strong)UIColor *cellNormalColor;
@property (nonatomic, strong)UIColor *cellSelectColor;
//选中之后的样式
@property (nonatomic, assign)kCJLrdSelectMenuType selectType;
第三步:
//开始加载数据 在确保menu添加到父视图之后 调用 ，并且配置好各属性
- (void)startReloadData;

/**********更多详情参考demo************/
