//
//  LYSegmentViewController.m
//  LYSegmentViewController
//
//  Created by wans on 2017/12/16.
//

#import "LYSegmentViewController.h"

@interface LYSegmentViewController ()

@property (nonatomic, strong) LYSegmentTableView                            *tableView;

@property (nonatomic, assign) CGRect                                        segmentCellRect;

// tabbar能否滑动
@property (nonatomic, assign) BOOL                                          isTopIsCanNotMoveTabView;

// tabbar能否滑动改变状态之前的状态
@property (nonatomic, assign) BOOL                                          isTopIsCanNotMoveTabViewPre;

// 外层列表是否能滑动
@property (nonatomic, assign) BOOL                                          canScroll;

// tableview类型
@property (nonatomic, assign) UITableViewStyle                              style;

@property (nonatomic, assign) NSInteger                                     currentIndex;

// 分页菜单的样式
@property (nonatomic, assign) LYSPPageMenuTrackerStyle                      trackerStyle;

@end

@implementation LYSegmentViewController

#pragma mark - Init

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style {
    
    self = [super init];
    if ( self) {
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ( ![self.view.subviews containsObject:self.tableView] ) {
        [self.view insertSubview:self.tableView atIndex:0];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.tableView registerClass:NSClassFromString(LYSegmentCellIdentifier)
               forCellReuseIdentifier:kLYSegmentCellIdentifier];
    }
}

/**
 *  构建视图
 */
- (void)createUI {

    
}

/**
 *  构建数据
 */
- (void)createDataSource {
    //TODO: fetch data
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(acceptMsg:)
                                                 name:LYSLeaveTopNotificationName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(acceptMsgState:)
                                                 name:LYSScrollViewNotificationName
                                               object:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if ( self.refreshingPolicy == LYSementRefrshingPolicyChild ) {
        if ( contentOffsetY < 0 ) {
            self.tableView.contentOffset = CGPointZero;
        }
    }
    
    if ( CGRectIsEmpty(self.segmentCellRect) ) {
        // 获取segmentcell的位置，设置悬浮效果
        self.segmentCellRect = [self segmentCellWithSuspend];
    }
    
    CGFloat tabOffsetY = self.segmentCellRect.origin.y + self.tableView.contentInset.top - self.ignoredTopEdge;
    if (@available(iOS 11.0, *)) {
        tabOffsetY -= self.tableView.adjustedContentInset.top;
    }
    self.isTopIsCanNotMoveTabViewPre = self.isTopIsCanNotMoveTabView;
    if ( contentOffsetY >= tabOffsetY ) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.isTopIsCanNotMoveTabView = YES;
    }else{
        self.isTopIsCanNotMoveTabView = NO;
    }
    
    if ( self.isTopIsCanNotMoveTabView != self.isTopIsCanNotMoveTabViewPre ) {
        if (!self.isTopIsCanNotMoveTabViewPre && self.isTopIsCanNotMoveTabView) {
            // 滑动到顶端
            [[NSNotificationCenter defaultCenter] postNotificationName:LYSGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            self.canScroll = NO;
            if ( self.isShowIndicator )  self.tableView.showsVerticalScrollIndicator = NO;
        }
        if(self.isTopIsCanNotMoveTabViewPre && !self.isTopIsCanNotMoveTabView) {
            // 离开顶端
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                if ( self.isShowIndicator ) self.tableView.showsVerticalScrollIndicator = YES;
            }
        }
    }
}

- (CGRect)segmentCellWithSuspend {
    
    NSInteger sections = [self.tableView numberOfSections];
    for (int s = 0; s < sections; s++) {
        NSInteger rows = [self.tableView numberOfRowsInSection:s];
        for (int r = 0; r < rows; r++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
            LYTVSegmentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ( [cell isKindOfClass:NSClassFromString(@"LYTVSegmentCell")]) {
                return [self.tableView rectForRowAtIndexPath:indexPath];
            }
        }
    }
    return CGRectNull;
}

#pragma mark - Private Methods

/**
 收起下拉刷新
 */
- (void)endRefreshing {

}

#pragma mark - Event Reaponse

- (void)acceptMsg:(NSNotification *)notification {
    self.canScroll = [notification.userInfo[@"canScroll"] boolValue];
}

- (void)acceptMsgState:(NSNotification *)notification {
    self.tableView.scrollEnabled = [notification.userInfo[@"canScroll"] boolValue];
}

#pragma mark - Http


#pragma mark - Getter&&Setter

- (UITableView *)tableView {
    if( !_tableView ) {
        _tableView = [[LYSegmentTableView alloc] initWithFrame:CGRectZero style:self.style];
        [_tableView setBackgroundColor:UIColor.clearColor];
    }
    return _tableView;
}

- (void)setRefreshingPolicy:(LYSementRefrshingPolicy)refreshingPolicy {
    
    _refreshingPolicy = refreshingPolicy;

    if ( _refreshingPolicy == LYSementRefrshingPolicyMain ) {
    
        // 注册下拉刷新通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endRefreshing)
                                                     name:LYSegmentEndRefreshNotificationName object:nil];
    }    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    
    self.tableView.segmentCell.selectedIndex = _selectedIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (LYSPPageMenuTrackerStyle)trackerStyle {
    
    LYSPPageMenuTrackerStyle trackerStyle = LYSPPageMenuTrackerStyleLine;
    if ( [[self.segmentDataSource segmentPageMenuDictionary].allKeys containsObject:LYSegViewControllerTrackerStyleKey] ) {
        trackerStyle = [[[self.segmentDataSource segmentPageMenuDictionary] objectForKey:LYSegViewControllerTrackerStyleKey] intValue];
    }
    
    return trackerStyle;
}

@end
