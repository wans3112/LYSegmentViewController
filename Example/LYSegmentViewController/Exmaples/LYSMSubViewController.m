//
//  LYSMSubViewController.m
//  LYSegmentViewController_Example
//
//  Created by wans on 2017/12/20.
//  Copyright © 2017年 wans3112. All rights reserved.
//

#import "LYSMSubViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LYMacroUtils.h"

@interface LYSMSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray                                *dataSource;

@end

@implementation LYSMSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setEstimatedSectionHeaderHeight:10];
//    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self loadData];
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 添加下拉刷新
    if ( self.refreshingPolicy == LYSementRefrshingPolicyChild ) {
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongWeak = weakSelf;
            [strongWeak loadData];
        }];
    }
}

- (void)loadData {
    [self loadDataWithComplete:nil];
}

- (void)loadDataWithComplete:(void (^)(id))complete {

    if ( !self.dataSource ) {
        self.dataSource = @[].mutableCopy;
    }
    
    for (int i = 0; i < 20; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"row %d", i]];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView reloadData];
        
        [weakSelf endRefreshingCommon:^{
            __strong typeof(weakSelf) strongWeak = weakSelf;
            [strongWeak.tableView.mj_header endRefreshing];
        }];
    });
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%@", self.segmentIndex, self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UIViewController *vc = [UIViewController new];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
