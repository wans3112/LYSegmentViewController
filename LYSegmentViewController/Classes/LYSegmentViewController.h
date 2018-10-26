//
//  LYSegmentViewController.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/16.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LYSegmentViewController/LYSeqmentConstants.h>
#import <LYSegmentViewController/LYSegmentProcotol.h>

@interface LYSegmentViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView                            *tableView; //!< 主列表

@property (nonatomic, assign) LYSementRefrshingPolicy                          refreshingPolicy; //!< 下拉刷新策略

@property (nonatomic, assign) CGFloat                                          ignoredTopEdge; //!< 主列表顶部忽略的距离

@property (nonatomic, assign) NSInteger                                        selectedIndex; //!< 默认显示页面序号

@property (nonatomic, assign) BOOL                                             isShowIndicator; //!< 是否显示主列表滑动条

@property (nonatomic, weak) id<LYSegmentDelegate>                              segmentDelegate; //!< 事件代理

@property (nonatomic, weak) id<LYSegmentDataSource>                            segmentDataSource; //!< 数据代理

@property (nonatomic, assign) BOOL                                             segmentScrollDisable; //!< 禁止segment横向滑动

@property (nonatomic, strong, readonly) LYSMSubBaseViewController              *firstChildViewController; //!< 第一个子控制器

@property (nonatomic, strong, readonly) LYSMSubBaseViewController              *lastChildViewController; //!< 最后一个子控制器

- (void)reloadData;
/**
 初始化实例

 @param style tableview的风格
 @return 实例
 */
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

/**
 子控制器必须重写此方法，并调用[super scrollViewDidScroll:scrollView]

 @param scrollView 列表
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

// 主控制器调用收起下拉刷新
- (void)endRefreshing;

// 根据index获取子视图
- (LYSMSubBaseViewController *)childViewControllerWithIndex:(NSInteger)index;

- (void)reloadDataForTabs;

@end
