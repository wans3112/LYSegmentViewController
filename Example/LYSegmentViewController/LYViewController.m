//
//  LYViewController.m
//  LYSegmentViewController
//
//  Created by wans3112 on 11/29/2017.
//  Copyright (c) 2017 wans3112. All rights reserved.
//

#import "LYViewController.h"
#import <Masonry.h>
#import <LYSegmentViewController/LYSegment.h>
#import "LYHeaderViewController.h"
#import "LYStickViewController.h"
#import "LYMainViewController.h"

#define kCellIdentifier         @"UITableViewCell"

@interface LYViewController ()

@end

@implementation LYViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = LYSegColorHexString(@"f2f2f2");

}

- (IBAction)headerSegment:(id)sender {
    LYHeaderViewController *vc = [[LYHeaderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)stickSegment:(id)sender {
    LYStickViewController *vc = [[LYStickViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    /**
     
    LYSegmentStickViewController *controller = [[LYSegmentStickViewController alloc] init];
    controller.segmentScrollDisable = YES;
    controller.segmentChildTitles = @[@"热门文章", @"快速", @"案例分析"];
    controller.segmentChildControllers = @[[NSClassFromString(@"LYSMSubViewController") new], [NSClassFromString(@"LYSMSubViewController") new], [NSClassFromString(@"LYSMSubViewController") new]];
    controller.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.navigationController pushViewController:controller animated:YES];
    
    **/

}

- (IBAction)customSegment:(id)sender {
    LYMainViewController *vc = [[LYMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mainRefreshSegment:(id)sender {
    LYMainViewController *vc = [[LYMainViewController alloc] init];
    vc.refreshingPolicy = LYSementRefrshingPolicyMain;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)subRefreshSegment:(id)sender {
    
    LYMainViewController *vc = [[LYMainViewController alloc] init];
    vc.refreshingPolicy = LYSementRefrshingPolicyChild;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
