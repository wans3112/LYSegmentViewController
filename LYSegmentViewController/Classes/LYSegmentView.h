//
//  LYSegmentView.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSegmentView : UIView

@property (nonatomic, strong) LYSegmentAttributedArray                                    *attribute;

@property (nonatomic, strong) LYSegmentPageMenuDictionary                                 *pageMenuAttribute;

@property (nonatomic, strong) NSArray<LYSMSubBaseViewController *>                        *controllers;

@property (nonatomic, strong) NSArray<NSString *>                                         *pageTitles;

@property (nonatomic, assign) CGFloat                                                     pageMenuHeight;

@property (nonatomic, assign) NSInteger                                                   selectedIndex;

- (instancetype)initWithTrackerStyle:(LYSPPageMenuTrackerStyle)trackerStyle;

- (void)refreshCurrentSubControllerWithComplete:(void(^)(id))complete;
- (void)refreshCurrentSubController;

@end
