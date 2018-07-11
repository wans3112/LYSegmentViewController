//
//  LYStickViewController.m
//  LYSegmentViewController_Example
//
//  Created by wans on 2017/12/25.
//  Copyright © 2017年 wans3112. All rights reserved.
//

#import "LYStickViewController.h"
#import "LYMacroUtils.h"
#import "LYSMSubViewController.h"

@interface LYStickViewController ()<LYSegmentDataSource>

@end

@implementation LYStickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LYSegColorHexString(@"f2f2f2");

    self.segmentDataSource = self;
    self.segmentScrollDisable = YES;
    
    [self.tableView setEstimatedRowHeight:10];

}

#pragma mark - LYSegmentDataSource

- (NSInteger)numberOfSegment {
    
    return 3;
}

- (UIViewController *)controllerOfSegmentWithIndex:(NSInteger)index {
    
    LYSMSubBaseViewController *vc = [LYSMSubViewController new];
    
    return vc;
}

- (NSString *)titleOfSegmentWithIndex:(NSInteger)index {
    
    return @[@"热门文章", @"快速", @"案例分析"][index];
}

- (LYSegmentPageMenuDictionary *)segmentPageMenuDictionary {
    
    LYSegmentPageMenuDictionary *superdir = [super segmentPageMenuDictionary];
    NSMutableDictionary *dir = @{@"trackerStyle":@0,
                                 @"trackerHeight":@3}.mutableCopy;
    [dir addEntriesFromDictionary:superdir];
    
    return dir;
}

@end
