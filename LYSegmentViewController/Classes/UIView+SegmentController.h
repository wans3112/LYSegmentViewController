//
//  UIView+SegmentController.h
//  LYSegmentViewController
//
//  Created by wans on 2017/12/22.
//

#import <UIKit/UIKit.h>

@interface UIView (SegmentController)

@property (nonatomic, weak, readonly) LYSMSubBaseViewController               *subBaseViewController; //!< 主控制器

@property (nonatomic, weak, readonly) LYSegmentViewController                 *segmentViewController ; //!< 子控制器

@end
