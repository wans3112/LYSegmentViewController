//
//  LYSegmentHeaderViewController.m
//  LYSegmentHeaderViewController
//
//  Created by wans on 2017/12/21.
//

#import "LYSegmentCoverViewController.h"

@interface LYSegmentCoverViewController ()<UITableViewDelegate, UITableViewDataSource, LYSegmentDelegate, LYSegmentDataSource>

@end

@implementation LYSegmentCoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.segmentDelegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if ( !self.tableView.tableHeaderView && self.segmentHeaderDelegate && [self.segmentHeaderDelegate respondsToSelector:@selector(headerOfSegment)] ) {
        self.tableView.tableHeaderView = [self.segmentHeaderDelegate headerOfSegment];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *segcell = [tableView dequeueReusableSegmentCellWithDelegate];
    
    return segcell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - LYSegmentDataSource

- (LYSegmentPageMenuDictionary *)segmentPageMenuDictionary {
    
    return @{@"selectedItemTitleColor":LYSegColorHexString(@"00ccb1"),
             @"unSelectedItemTitleColor":LYSegColorHexString(@"666666"),
             @"tracker.backgroundColor":LYSegColorHexString(@"00ccb1"),
             @"dividingLine.backgroundColor" : LYSegColorHexString(@"e5e5e5"),
             };
}

@end
