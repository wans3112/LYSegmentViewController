//
//  LYSegmentCoverViewController.h
//  LYSegmentCoverViewController
//
//  Created by wans on 2017/12/21.
//

#import "LYSegmentViewController.h"

@interface LYSegmentCoverViewController : LYSegmentViewController

@property (nonatomic, weak) id<LYSegmentHeaderDelegate>                              segmentHeaderDelegate; //!< 带haeder的segment代理

@end
