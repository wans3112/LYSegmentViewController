//
//  LYTVSegmentCell.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSAttribute : NSObject

@property (nonatomic, strong) LYSegmentAttributedArray                                    *attribute;

@property (nonatomic, strong) LYSegmentPageMenuDictionary                                 *pageMenuAttribute;

@end

typedef void(^LYSegmentParams)(LYSAttribute *params);

@interface LYTVSegmentCell : UITableViewCell

@property (nonatomic, assign) NSInteger                                                   selectedIndex;

@end

@interface UITableView (Segment)

@property (nonatomic, strong, readonly) LYTVSegmentCell                                   *segmentCell;


/**
 注意：此方式加载Cell必须实现LYSegmentDelegate和LYSegmentDataSource

 @return LYTVSegmentCell
 */
- (LYTVSegmentCell *)dequeueReusableSegmentCellWithDelegate;
- (LYTVSegmentCell *)dequeueReusableSegmentCellWithAttributeDelegate;
- (LYTVSegmentCell *)dequeueReusableSegmentCellWithAttribute:(LYSegmentParams)params;

- (void)refreshCurrentSubControllerWithComplete:(void(^)(id))complete;
- (void)refreshCurrentSubController;

@end
