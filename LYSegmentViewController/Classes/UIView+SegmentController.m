//
//  UIView+SegmentController.m
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
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
