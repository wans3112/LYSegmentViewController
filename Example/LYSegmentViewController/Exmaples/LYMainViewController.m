//
//  LYMainViewController.m
//  LYSegmentViewController
//
//  Created by wans3112 on 11/29/2017.
//  Copyright (c) 2017 wans3112. All rights reserved.
//

#import "LYMainViewController.h"
#import <Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <LYSegmentViewController/LYSegment.h>
#import "LYMacroUtils.h"

#define kCellIdentifier         @"UITableViewCell"

@interface LYMainViewController ()<UITableViewDelegate, UITableViewDataSource, LYSegmentDelegate, LYSegmentDataSource>

@end

@implementation LYMainViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = LYSegColorHexString(@"f2f2f2");
    
    //TODO:1.设置tableview的代理为子类，之类现实UITableViewDataSource/UITableViewDelegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //TODO:2.设置现实LYSegmentDelegate和LYSegmentDataSource代理
    self.segmentDelegate = self;
    self.segmentDataSource = self;
    
    //TODO:4. （可选）添加下拉刷新，下拉刷新加载主列表的顶部，刷新数据为当前segment选中的子控制器中的数据（子控制器必须实现loadData方法）
//    self.refreshingPolicy = LYSementRefrshingPolicyMain;
    
    [self.tableView registerClass:NSClassFromString(kCellIdentifier)
           forCellReuseIdentifier:kCellIdentifier];
    [self.tableView setEstimatedSectionFooterHeight:20];
    
    if ( self.refreshingPolicy == LYSementRefrshingPolicyMain ) {
        // 添加下拉刷新
        __weak typeof(self) weakSelf = self;
        weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongWeak = weakSelf;
            [strongWeak.tableView refreshCurrentSubController];
        }];
    }
    
}

/**
 收起下拉刷新
 */
- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == 2 ) {
        return 1;
    }
    return 3;
}

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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( section == 2 ) {
        return 0.01;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//TODO:2.1 现实LYSegmentDelegate和LYSegmentDataSource
#pragma mark - LYSegmentDelegate

- (void)segmentController:(id)controller didSelectedWithIndex:(NSInteger)index {
    
    NSLog(@"con:%@,index:%ld",controller,  index);
}

#pragma mark - LYSegmentDataSource

- (NSInteger)numberOfSegment {
    
    return 3;
}

- (UIViewController *)controllerOfSegmentWithIndex:(NSInteger)index {
    
    LYSMSubBaseViewController *vc = [NSClassFromString(@"LYSMSubViewController") new];
    
    return vc;
}

- (NSString *)titleOfSegmentWithIndex:(NSInteger)index {
    
    return @[@"热门文章", @"快速咨询", @"案例分析"][index];
}

- (LYSegmentPageMenuDictionary *)segmentPageMenuDictionary {
    
    return @{@"selectedItemTitleColor":LYSegColorHexString(@"00ccb1"),
             @"unSelectedItemTitleColor":LYSegColorHexString(@"666666"),
             @"tracker.backgroundColor":LYSegColorHexString(@"00ccb1"),
             @"dividingLine.backgroundColor" : [UIColor clearColor]};
}


#pragma mark - UITableViewDataSource

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
