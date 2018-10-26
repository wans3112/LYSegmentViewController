//
//  LYSMSubBaseViewController.m
//  HomePage https://github.com/wans3112/LYSegmentViewController
//  segment子控制器的基类
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import "LYSMSubBaseViewController.h"

@interface LYSMSubBaseViewController ()

@property (nonatomic, strong) UITableView                 *tableView;

@property (nonatomic, assign) BOOL                        canScroll;

@property (nonatomic, strong) id                          params;

@property (nonatomic, assign) UITableViewStyle            style;

@end

@implementation LYSMSubBaseViewController

#pragma mark - Init

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style {
    
    return [self initWithParams:nil tableViewStyle:style];
}

- (instancetype)initWithParams:(id)params tableViewStyle:(UITableViewStyle)style {
    
    self = [super init];
    if ( self) {
        self.params = params;
        self.style = style;
    }
    
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createDataSource];
}

#pragma mark - Private Methods

/**
 *  构建视图
 */
- (void)createUI {

    self.view.backgroundColor = [UIColor clearColor];
    
    if ( self.isCollectionView ) {
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        return;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    // 如果子控制器初始化时，已经是悬浮状态了，那就将子控制器设置可以滑动。
    self.canScroll = ![[self.view.segmentViewController valueForKey:@"canScroll"] boolValue];
}

/**
 *  构建数据
 */
- (void)createDataSource {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollListener:)
                                                 name:LYSGoTopNotificationName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollListener:)
                                                 name:LYSLeaveTopNotificationName
                                               object:nil];
    

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    /** 添加下拉刷新
    if ( self.refreshingPolicy == LYSementRefrshingPolicyChild ) {
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongWeak = weakSelf;
            [strongWeak loadData];
        }];
    }
     **/
    
}

#pragma mark - Event Reaponse

-(void)scrollListener:(NSNotification *)notification {

    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:LYSGoTopNotificationName]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            if( self.isShowIndicator ) self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:LYSLeaveTopNotificationName]){
        self.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        if( self.isShowIndicator ) self.tableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ( self.isNeedRefreshingOnChild && !self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat yoffset = scrollView.contentOffset.y;
    
    if ( self.isNeedRefreshingOnChild && yoffset < 0 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LYSLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
        [scrollView setContentOffset:CGPointZero];
        self.canScroll = NO;
    }
}

#pragma mark - Getter&&Setter

- (UITableView *)tableView {
    if( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if( !_collectionView ){
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation LYSMSubBaseViewController (Refreshing)
@dynamic refreshingDisEnable;

- (LYSementRefrshingPolicy)refreshingPolicy {
    
    LYSegmentViewController *segVC = (LYSegmentViewController *)LYSegViewController;
    
    return segVC.refreshingPolicy;
}

- (void)setRefreshingDisEnable:(BOOL)refreshingDisEnable {
    
    if ( refreshingDisEnable ) {
        //TODO: remove header refreshing
    }
}

- (BOOL)isNeedRefreshingOnChild {
    
    LYSegmentViewController *segVC = (LYSegmentViewController *)LYSegViewController;
    CGFloat mainOffsetY = segVC.tableView.contentOffset.y;
    
    if ( self.refreshingPolicy != LYSementRefrshingPolicyChild || ( mainOffsetY > 0 && self.refreshingPolicy == LYSementRefrshingPolicyChild ) ) {
        return YES;
    }
    
    return NO;
}

- (void)loadDataWithComplete:(void(^)(id))complete {
    
    //TODO:子控制器重写实现数据获取操作
}

- (void)loadData {
    
    [self loadDataWithComplete:nil];
}

- (void)endRefreshingWithMain {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LYSegmentEndRefreshNotificationName object:nil];
}

- (void)endRefreshingCommon:(void(^)(void))action {
   
    if ( self.refreshingPolicy == LYSementRefrshingPolicyChild ) {
        if ( action ) action();
    }else {
        [self endRefreshingWithMain];
    }
}

@end
