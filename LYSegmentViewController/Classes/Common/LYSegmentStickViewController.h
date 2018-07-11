//
//  LYSegmentStickViewController.h
//  LYSegmentStickViewController
//
//  Created by wans on 2017/12/21.
//

#import "LYSegmentViewController.h"

@interface LYSegmentStickViewController : LYSegmentViewController<LYSegmentDataSource>

@property (nonatomic, strong) NSArray<LYSMSubBaseViewController *>                                 *segmentChildControllers;

@property (nonatomic, strong) LYSegmentPageMenuDictionary                                          *segmentPageMenuAttribute;

@property (nonatomic, strong) NSArray                                                              *segmentChildTitles;

@end
