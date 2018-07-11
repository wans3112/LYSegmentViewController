//
//  LYSegmentProcotol.h
//  Pods
//
//  Created by wans on 2017/12/25.
//

#ifndef LYSegmentProcotol_h
#define LYSegmentProcotol_h

#import <LYSegmentViewController/LYSMSubBaseViewController.h>

@protocol LYSegmentDelegate<NSObject>

@optional

/**
 分页按钮栏的高度

 @return 高度
 */
- (CGFloat)heightOfSegmentPageMenu;

/**
 分页控制器的点击事件
 
 @param controller 子控制器
 @param index 序号
 */
- (void)segmentController:(LYSMSubBaseViewController *)controller didSelectedWithIndex:(NSInteger)index;

@end

@protocol LYSegmentDataSource<NSObject>

@optional


/**
 返回page的数量

 @return 数量
 */
- (NSInteger)numberOfSegment;


/**
 返回pagemenu的title的数组

 @param index 序号
 @return title数组
 */
- (NSString *)titleOfSegmentWithIndex:(NSInteger)index;


/**
 返回page的controller

 @param index 序号
 @return 控制器
 */
- (LYSMSubBaseViewController *)controllerOfSegmentWithIndex:(NSInteger)index;

@optional

/**
 返回分页控制的参数
 
 @return 参数数组
 */
- (LYSegmentAttributedArray *)segmentAttributedArray;

/**
 返回分页控制的属性设置参数
 
 @return 主题字典
 */
- (LYSegmentPageMenuDictionary *)segmentPageMenuDictionary;

@end

@protocol LYSegmentHeaderDelegate<LYSegmentDelegate>

@optional

/**
 返回Segment的Header

 */
- (UIView *)headerOfSegment;

@end

#endif /* LYSegmentProcotol_h */
