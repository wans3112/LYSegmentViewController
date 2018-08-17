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
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-literal-conversion"
    //写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
    return (LYSMSubBaseViewController *)LYSegSubViewController;
#pragma clang diagnostic pop
}

@end
