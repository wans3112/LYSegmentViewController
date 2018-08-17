//
//  LYSegmentStickViewController.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/21.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import "LYSegmentViewController.h"

@interface LYSegmentStickViewController : LYSegmentViewController<LYSegmentDataSource>

@property (nonatomic, strong) NSArray<LYSMSubBaseViewController *>                                 *segmentChildControllers;

@property (nonatomic, strong) LYSegmentPageMenuDictionary                                          *segmentPageMenuAttribute;

@property (nonatomic, strong) NSArray                                                              *segmentChildTitles;

@end
