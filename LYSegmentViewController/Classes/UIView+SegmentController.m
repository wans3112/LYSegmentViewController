//
//  UIView+SegmentController.m
//  LYSegmentViewController
//
//  Created by wans on 2017/12/22.
//

#import "UIView+SegmentController.h"

@implementation UIView (SegmentController)
@dynamic segmentViewController;
@dynamic subBaseViewController;

- (LYSegmentViewController *)segmentViewController {
    
    return (LYSegmentViewController *)LYSegViewController;
}

- (LYSMSubBaseViewController *)subBaseViewController {
    
    return (LYSMSubBaseViewController *)LYSegSubViewController;
}

@end
