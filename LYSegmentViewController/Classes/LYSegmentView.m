//
//  LYSegmentView.m
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import "LYSegmentView.h"

@interface LYSegmentView ()<UIScrollViewDelegate, LYSPPageMenuDelegate>

@property (nonatomic, strong) LYSPPageMenu                             *pageMenu;

@property (nonatomic, strong) UIScrollView                             *scrollView;

@property (nonatomic, strong) UIView                                   *containerView;

@property (nonatomic, assign) BOOL                                     canScroll;

@property (nonatomic, assign) BOOL                                     isLayoutSubviews;

@property (nonatomic, assign) NSInteger                                currentIndex;

@property (nonatomic, assign) LYSPPageMenuTrackerStyle                 trackerStyle;

@end

@implementation LYSegmentView

- (instancetype)initWithTrackerStyle:(LYSPPageMenuTrackerStyle)trackerStyle {
    self.trackerStyle = trackerStyle;
    return [self init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDataSource];
        [self createUI];
    }
    return self;
}

#pragma mark - Private Methods

/**
 *  构建视图
 */
- (void)createUI {
    
    [self addSubview:self.pageMenu];

    [self addSubview:self.scrollView];

    [self.scrollView addSubview:self.containerView];
    
}

/**
 *  构建数据
 */
- (void)createDataSource {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ( self.pageMenuHeight == 0 )  self.pageMenuHeight = kPageMenuHeight;
    
    self.pageMenu.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.pageMenuHeight);

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pageMenuHeight);
        make.right.left.bottom.mas_equalTo(0);
    }];
    
    CGFloat containerHeight = CGRectGetHeight(self.frame) - self.pageMenuHeight - self.segmentViewController.ignoredTopEdge;
    if (@available(iOS 11.0, *)) {
        containerHeight -= self.segmentViewController.tableView.adjustedContentInset.top;
        containerHeight -= self.segmentViewController.tableView.adjustedContentInset.bottom;
    }
    NSInteger pageCount = 0;
    if ( self.pageTitles.count > 0 ) pageCount = self.pageTitles.count;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(containerHeight);
        make.width.mas_equalTo(pageCount * CGRectGetWidth(self.frame));
    }];
    
    if ( self.pageMenu.items.count == 0 ) {
        [self.pageMenu setItems:self.pageTitles selectedItemIndex:self.selectedIndex];
    }
    
    // 设置是否可以横向滑动
    self.scrollView.scrollEnabled = !self.segmentViewController.segmentScrollDisable;

}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self postNotifWithState:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ( !decelerate ) {
        [self postNotifWithState:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self postNotifWithState:YES];
}

#pragma mark - LYSPPageMenuDelegate

- (void)pageMenu:(LYSPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    LYSMSubBaseViewController *controller = self.segmentViewController.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ( controller && ![controller isViewLoaded] && ![self.containerView.subviews containsObject:controller.view]) {
        
        controller.view.tag = toIndex;
        [self.containerView addSubview:controller.view];
        [controller didMoveToParentViewController:self.segmentViewController];
        [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.equalTo(self);
            make.left.mas_equalTo(toIndex * CGRectGetWidth(self.frame));
        }];
    }
    
    [self.containerView layoutIfNeeded];
    
    CGPoint offsetPoint = CGPointMake(CGRectGetWidth(self.frame) * toIndex, 0);
    if ( abs((int)(toIndex - fromIndex)) > 1 ) {
        // 跨页翻页，自动划到目标页的相邻页
//        NSInteger borderIndex = fromIndex > toIndex ? (fromIndex - 1) : (fromIndex + 1);
//        offsetPoint = CGPointMake(CGRectGetWidth(self.frame) * borderIndex, 0);
//        self.scrollView.contentOffset = offsetPoint;
        [self.scrollView setContentOffset:offsetPoint animated:NO];
    }else {
        [self.scrollView setContentOffset:offsetPoint animated:YES];
    }
    
    self.currentIndex = toIndex;
    
    [self.segmentViewController setValue:@(toIndex) forKey:@"currentIndex"];
    
    // 分页点击回调
    id<LYSegmentDelegate> delegate = self.segmentViewController.segmentDelegate;
    if ( delegate && [delegate respondsToSelector:@selector(segmentController:didSelectedWithIndex:)]) {
        [delegate segmentController:controller didSelectedWithIndex:self.currentIndex];
    }
}

#pragma mark - Event Reaponse

- (void)postNotifWithState:(BOOL)state {
    [[NSNotificationCenter defaultCenter] postNotificationName:LYSScrollViewNotificationName
                                                        object:nil
                                                      userInfo:@{@"canScroll":@(state)}];
}

- (void)refreshCurrentSubController {
    
    LYSMSubBaseViewController *controller = self.segmentViewController.childViewControllers[self.currentIndex];
    
    [controller loadData];
}

- (void)refreshCurrentSubControllerWithComplete:(void (^)(id))complete {
    
    LYSMSubBaseViewController *controller = self.segmentViewController.childViewControllers[self.currentIndex];
    
    [controller loadDataWithComplete:complete];
}

#pragma mark - Getter&&Setter

- (LYSPPageMenu *)pageMenu {
    
    if (!_pageMenu) {
        _pageMenu = [LYSPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:self.trackerStyle];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:16];
        _pageMenu.selectedItemTitleColor = [UIColor blackColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = [UIColor orangeColor];
        _pageMenu.permutationWay = LYSPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
    }
    return _pageMenu;
}

- (UIScrollView *)scrollView {
    if( !_scrollView ){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if( !_containerView ) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

// 初始化子控制器
- (void)setAttribute:(LYSegmentAttributedArray *)attribute {
    
    if ( attribute.count == 0 ) return;

    _attribute = attribute;

    NSMutableArray *pageMenuItems = @[].mutableCopy;
    NSMutableArray *controllers = @[].mutableCopy;
    [_attribute enumerateObjectsUsingBlock:^(LYSegmentAttributedDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UITableViewStyle style = UITableViewStylePlain;
        if ( obj && [obj.allKeys containsObject:LYSStyleAttributeName] ) {
            style = [[obj objectForKey:LYSStyleAttributeName] intValue];
        }
        
        LYSMSubBaseViewController *controller = [[NSClassFromString(obj[LYSClassAttributeName]) alloc] initWithParams:obj[LYSParamsAttributeName] tableViewStyle:style];
        if ( !controller ) {
            controller = [LYSMSubBaseViewController new];
        }

        [pageMenuItems addObject:obj[LYSTitleAttributeName] ?: @""];
        [controllers addObject:controller];
    }];
    
    self.pageTitles = pageMenuItems;
    self.controllers = controllers;

}

- (void)setPageMenuAttribute:(LYSegmentPageMenuDictionary *)pageMenuAttribute {
    
    if ( pageMenuAttribute.count == 0 ) return;

    // 设置表情属性
    __weak typeof(self) weakSelf = self;
    [pageMenuAttribute enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weakSelf.pageMenu setValue:obj forKeyPath:key];
    }];
    
}

- (void)setControllers:(NSArray<LYSMSubBaseViewController *> *)controllers {
    
    if ( controllers.count == 0 ) return;

    _controllers = controllers;
    
    [_controllers enumerateObjectsUsingBlock:^(LYSMSubBaseViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
        
        controller.segmentIndex = idx;
        [self.segmentViewController addChildViewController:controller];
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if ( selectedIndex >= self.pageTitles.count ) {
        NSLog(@"selectedIndex：%ld is invaild",selectedIndex);
        return;
    }
    
    _selectedIndex = selectedIndex;
    [self.pageMenu setSelectedItemIndex:_selectedIndex];
}

@end
