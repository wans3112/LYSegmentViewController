//
//  LYSegmentStickViewController.m
//  LYSegmentStickViewController
//
//  Created by wans on 2017/12/21.
//

#import "LYSegmentStickViewController.h"

@interface LYSegmentStickViewController ()<UITableViewDelegate, UITableViewDataSource, LYSegmentDelegate, LYSegmentDataSource>

@end

@implementation LYSegmentStickViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshingPolicy = LYSementRefrshingPolicyChild;

    [self.tableView setEstimatedSectionFooterHeight:20];
    
    if ( self.segmentChildControllers && self.segmentChildControllers.count > 0 ) {
        self.segmentDataSource = self;
    }
}

#pragma mark - LYSegmentDataSource

- (NSInteger)numberOfSegment {
    
    return self.segmentChildControllers.count;
}

- (UIViewController *)controllerOfSegmentWithIndex:(NSInteger)index {
    
    return self.segmentChildControllers[index];
}

- (NSString *)titleOfSegmentWithIndex:(NSInteger)index {
    
    return self.segmentChildTitles[index];
}

- (LYSegmentPageMenuDictionary *)segmentPageMenuDictionary {
    
    if ( self.segmentPageMenuAttribute && self.segmentPageMenuAttribute.count > 0 ) {
        return self.segmentPageMenuAttribute;
    }
    
    return @{@"selectedItemTitleColor":LYSegColorHexString(@"00ccb1"),
             @"unSelectedItemTitleColor":LYSegColorHexString(@"666666"),
             @"tracker.backgroundColor":LYSegColorHexString(@"00ccb1"),
             @"dividingLine.backgroundColor" : LYSegColorHexString(@"e5e5e5"),
             };
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO: 2.按需求配置参数生成SegmentCell
    UITableViewCell *segcell = [tableView dequeueReusableSegmentCellWithDelegate];

    return segcell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
