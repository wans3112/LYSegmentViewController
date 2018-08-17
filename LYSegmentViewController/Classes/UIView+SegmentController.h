//
//  UIView+SegmentController.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SegmentController)

@property (nonatomic, weak, readonly) LYSMSubBaseViewController               *subBaseViewController; //!< 主控制器

@property (nonatomic, weak, readonly) LYSegmentViewController                 *segmentViewController ; //!< 子控制器

@end
