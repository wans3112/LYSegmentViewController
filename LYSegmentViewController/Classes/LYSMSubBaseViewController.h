//
//  LYSMSubBaseViewController.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//  segment子控制器的基类
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSMSubBaseViewController : UIViewController

/**
 父类已为子类初始化好了列表（子类不可自己初始化新的列表，不然无法监听子类列表滑动），子类直接调用，可重新设置属性，然后实现相关代理。
 */
@property (nonatomic, strong, readonly) UITableView                  *tableView;

@property (nonatomic, strong) UICollectionView                       *collectionView;

@property (nonatomic, assign) bool                                   isCollectionView;//!< 如果子类主视图为collectionView 需设置为yes

@property (nonatomic, assign) NSInteger                              segmentIndex; //!< 在segment控制器中的序号

@property (nonatomic, assign) BOOL                                   isShowIndicator; //!< 是否显示主列表滑动条

@property (nonatomic, strong, readonly) id                           params; //!< 传递的参数

/**
 初始化实例

 @param params AttributeDelegate方式生成segment时，可以传入参数
 @param style tableview的样式
 @return 子控件实例
 */
- (instancetype)initWithParams:(id)params tableViewStyle:(UITableViewStyle)style;
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

@end


/**
 子控制器下拉刷新相关控制
 */
@interface LYSMSubBaseViewController (Refreshing)

@property (nonatomic, assign, readonly) LYSementRefrshingPolicy        refreshingPolicy; //!< 下拉刷新策略

@property (nonatomic, assign) BOOL                                     refreshingDisEnable; //!< 取消下拉刷新

@property (nonatomic, assign, readonly) BOOL                           isNeedRefreshingOnChild; //!< 是否需要在子控制器下拉刷新

/**
 注意：子类加载数据必须重写此方法

 @param complete 子控件加载数据完成回调
 */
- (void)loadDataWithComplete:(void(^)(id))complete;
- (void)loadData;


/**
 子控制器调用收起下拉刷新

 @param action 如果在主列表头部刷新，则传空，否则设置收起子列表的刷新操作
 */
- (void)endRefreshingCommon:(void(^)(void))action;

@end
