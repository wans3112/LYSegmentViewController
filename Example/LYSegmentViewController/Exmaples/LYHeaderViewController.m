//
//  LYHeaderViewController.m
//  LYSegmentViewController_Example
//
//  Created by wans on 2017/12/25.
//  Copyright © 2017年 wans3112. All rights reserved.
//

#import "LYHeaderViewController.h"
#import "LYSMSubViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface LYHeaderViewController ()<UITableViewDelegate, LYSegmentHeaderDelegate, LYSegmentDataSource>

@end

@implementation LYHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = LYSegColorHexString(@"f2f2f2");

//    self.selectedIndex = 2;
    
    self.segmentHeaderDelegate = self;
    self.segmentDataSource = self;
    
//    self.refreshingPolicy = LYSementRefrshingPolicyMain;
//
//    @weakify(self)
//    [self.tableView ly_addHeaderRefresh:^{
//        @strongify(self)
//        [self.tableView refreshCurrentSubController];
//    }];

}

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
- (UIViewController *)controllerOfSegmentWithIndex:(NSInteger)index {
    
    LYSMSubViewController *vc = [LYSMSubViewController new];
    
    if ( index == 1 ) {
        return [[LYSMSubViewController alloc] initWithParams:nil tableViewStyle:UITableViewStyleGrouped];
    }
    
    return vc;
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

#pragma mark - LYSegmentDelegate

#pragma mark - LYSegmentHeaderDelegate


/**
 segment的封面视图

 @return 封面视图
 */
- (UIView *)headerOfSegment {
    
    UIImageView *header = [[UIImageView alloc] init];
//    header.backgroundColor = UIColor.yellowColor;
    header.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200);
    header.image = [UIImage imageNamed:@"cover.jpg"];
    
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
