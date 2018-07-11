### LYSegmentViewController

[![Version](https://img.shields.io/cocoapods/v/LYEmptySet.svg?style=flat)](http://192.168.10.81/IOS/commline/LYSegmentViewController)
[![License](https://img.shields.io/cocoapods/l/LYEmptySet.svg?style=flat)](http://192.168.10.81/IOS/commline/LYSegmentViewController)
[![Platform](https://img.shields.io/cocoapods/p/LYEmptySet.svg?style=flat)](http://192.168.10.81/IOS/commline/LYSegmentViewController)

LYSegmentViewController是一个可以快速在UITableView/UICollactionView中集成segment分页控制器。主要包含一下三种风格。

######  带封面的segment控制器

![design](https://github.com/wans3112/LYSegmentViewController/blob/master/Example/LYSegmentViewController/segment_header.gif?raw=true)

- 主控制器

1、 主控制器继承自LYSegmentHeaderViewController

```
#import <LYSegmentViewController/LYSegmentHeaderViewController.h>

@interface LYDiscoverRootViewController : LYSegmentHeaderViewController

@end
```

2、  设置segmentDataSource与segmentHeaderDelegate，并实现相关代理。

```
// 设置数据源代理
self.segmentDataSource = self;

// 设置事件代理
self.segmentHeaderDelegate = self;



#pragma mark - LYSegmentDataSource

/**
 segment子控制器的数量

 @return 数量
 */
- (NSInteger)numberOfSegment {

    return 3;
}

/**
 segment的子控制器

 @param index 序号
 @return 子控制器
 */
- (LYSMSubBaseViewController *) controllerOfSegmentWithIndex:(NSInteger)index {

    NSArray<NSString *> *classNames = @[@"LYHotArticleViewController", @"LYQuickConsultViewController", @"LYCaseAnalyseViewController"];
    LYSMSubBaseViewController *controller = [[NSClassFromString(classNames[index]) alloc] initWithTableViewStyle:UITableViewStyleGrouped];

    return controller;
}

/**
 segment分页标签栏的标题

 @param index 序号
 @return 标题
 */
- (NSString *)titleOfSegmentWithIndex:(NSInteger)index {

    NSArray *titles = @[@"热门文章", @"快速咨询", @"案例分析"];

    return titles[index];
}

#pragma mark - LYSegmentHeaderDelegate

/**
 segment分页标签栏的高度

 @return 高度
 */
- (CGFloat)heightOfSegmentPageMenu {

    return 40;
}

/**
 segment的封面视图

 @return 封面视图
 */
- (UIView *)headerOfSegment {

    return self.cycleView;
}

```

3、 设置下拉刷新策略

```
    self.refreshingPolicy = LYSementRefrshingPolicyMain;

```

- 子控制器

1、  子控制器继承自LYSMSubBaseViewController

```
#import <LYSegmentViewController/LYSMSubBaseViewController.h>

@interface LYCaseAnalyseViewController : LYSMSubBaseViewController

@end
```

2、 将父控制器(LYSMSubBaseViewController)的tableview的dataSource和delegate代理设置为子类。

```
// 父类已为子类初始化好了列表子类直接调用，可重新设置属性，然后正常的实现代理。

self.tableView.dataSource = self;
self.tableView.delegate = self;
```

> 主控制器添加下拉刷新，刷新子控制器内容时，子控制器网络请求完成，收起下拉刷新调用父类的`[self endRefreshing]`即可。

###### 置顶的segment控制器

![design](https://github.com/wans3112/LYSegmentViewController/blob/master/Example/LYSegmentViewController/segment_stick.gif?raw=true)

- 主控制器

1、  主控制器继承自LYSegmentHeaderViewController

```
#import <LYSegmentViewController/LYSegmentStickViewController.h>

@interface LYStickViewController : LYSegmentStickViewController

@end
```

2、  设置segmentDataSource，并实现相关代理。`同上`

- 子控制器

1、   子控制器继承自LYSMSubBaseViewController。`同上`

2、   将父控制器(LYSMSubBaseViewController)的tableview的dataSource和delegate代理设置为子类。`同上`


###### 可自定义的segment控制器

![design](https://github.com/wans3112/LYSegmentViewController/blob/master/Example/LYSegmentViewController/segment_costom.gif?raw=true)

1、  主控制器继承自LYSegmentViewController

```
#import <LYSegmentViewController/LYSegmentViewController.h>

@interface LYDiscoverRootViewController : LYSegmentViewController

@end
```

2、  将父控制器(LYSegmentViewController)的tableview的dataSource和delegate代理设置为子类。

```
// 父类已为子类初始化好了列表子类直接调用，可重新设置属性，然后正常的实现代理。

self.tableView.dataSource = self;
self.tableView.delegate = self;
```

3、  设置segmentDataSource与segmentDelegate，并实现相关代理。`代理实现同上`

```
// 设置数据源代理
self.segmentDataSource = self;

// 设置事件代理
self.segmentDelegate = self;

```


4、   根据业务为tableview初始化segmentCell

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *maincell = nil;
    if ( indexPath.section == 2 ) {
        //TODO: 3.按需求配置参数生成SegmentCell
        UITableViewCell *segcell = [tableView dequeueReusableSegmentCellWithDelegate];

        maincell = segcell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        cell.textLabel.text = [indexPath description];
        maincell = cell;

    }

    return maincell;
}
```

5、  设置下拉刷新策略 `同上`

- 子控制器

1、   子控制器继承自LYSMSubBaseViewController。`同上`

2、   将父控制器(LYSMSubBaseViewController)的tableview的dataSource和delegate代理设置为子类。`同上`

###### 下拉刷新策略

定义刷新策略如下：

```
 typedef enum : NSUInteger {
    LYSementRefrshingPolicyNone = 1,            // 无下拉刷新
    LYSementRefrshingPolicyMain = 2,            // 主控制器下拉刷新
    LYSementRefrshingPolicyChild = 3,           // 子控制器下拉刷选
} LYSementRefrshingPolicy;
```

1、  主控制器添加下拉刷新，下拉刷新从主控制器列表的顶部开始下拉操作，刷新子控制器内容结束，子控制器调用` [self endRefreshing]`可以收起主控制器列表的刷新状态。

2、 子控制器添加下拉刷新，下拉刷新从子控制器列表的顶部开始下拉操作。


![design](https://github.com/wans3112/LYSegmentViewController/blob/master/Example/LYSegmentViewController/segment_subvc_pull.gif?raw=true)

> 这三种下拉刷新策略都可运用在以上三种segment控制器。


###### segment分页标签栏样式

```
#pragma mark - LYSegmentDataSource

- (LYSegmentPageMenuDictionary *)segmentPageMenuDictionary {

    return @{@"selectedItemTitleColor":[UIColor colorWithHexString:@"00ccb1"],
             @"unSelectedItemTitleColor":[UIColor colorWithHexString:@"666666"],
             @"tracker.backgroundColor":[UIColor colorWithHexString:@"00ccb1"],
             @"dividingLine.backgroundColor" : [UIColor colorWithHexString:@"e5e5e5"],
             };
}
```


###### segment初始化方法

- Attribute代理模式初始化

1、  根据业务为tableview初始化segmentCell

```
UITableViewCell *segcell = [tableView dequeueReusableSegmentCellWithAttributeDelegate];
```

2、  实现LYSegmentDataSource代理

```
- (LYSegmentAttributedArray *)segmentAttributedArray {
    return @[ @{LYSTitleAttributeName:@"热门文章", LYSClassAttributeName:@"LYSMSubViewController",LYSParamsAttributeName:@1},
              @{LYSTitleAttributeName:@"快速咨询", LYSClassAttributeName:@"LYSMSubViewController",LYSStyleAttributeName:@(UITableViewStyleGrouped)},
              @{LYSTitleAttributeName:@"案例分析", LYSClassAttributeName:@"LYSMSubViewController"}];
}

```

- block直接传值模式初始化`此方式无需实现代理`

```
    // 按需求配置参数生成SegmentCell
    NSArray<NSDictionary<LYSegmentAttributedStringKey,id> *> *attribute = @[@{LYSTitleAttributeName:@"热门文章", LYSClassAttributeName:@"LYSMSubViewController",LYSParamsAttributeName:@1},
                               @{LYSTitleAttributeName:@"快速咨询", LYSClassAttributeName:@"LYSMSubViewController",LYSParamsAttributeName:@2},
                               @{LYSTitleAttributeName:@"案例分析", LYSClassAttributeName:@"LYSMSubViewController"}];
    // 配置分页标签的样式                           
    NSDictionary *pageMenuattribute = @{@"selectedItemTitleColor":[UIColor LY_ColorWithHexString:@"00ccb1"],
                                        @"unSelectedItemTitleColor":[UIColor LY_ColorWithHexString:@"666666"],
                                        @"tracker.backgroundColor":[UIColor LY_ColorWithHexString:@"00ccb1"],
                                        @"dividingLine.backgroundColor" : [UIColor clearColor]};

    UITableViewCell *segcell = [tableView dequeueReusableCellWithAttribute:^(LYSAttribute *params) {
        params.attribute = attribute;
        params.pageMenuAttribute = pageMenuattribute;
    }];       
```
