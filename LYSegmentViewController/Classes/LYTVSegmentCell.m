//
//  LYTVSegmentCell.m
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/18.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#import "LYTVSegmentCell.h"
#import "objc/runtime.h"

static const void *LYTVSegmentCellKey = &LYTVSegmentCellKey;

@implementation LYSAttribute

@end

@interface LYTVSegmentCell ()

@property (nonatomic, strong) LYSegmentView                                               *segmentView;

@property (nonatomic, strong) LYSegmentAttributedArray                                    *attribute;

@property (nonatomic, strong) LYSegmentPageMenuDictionary                                 *pageMenuAttribute;

@property (nonatomic, strong) NSArray<LYSMSubBaseViewController *>                        *controllers;

@property (nonatomic, strong) NSArray<NSString *>                                         *pageTitles;

@property (nonatomic, assign) CGFloat                                                     pageMenuHeight;

@property (nonatomic, assign) LYSPPageMenuTrackerStyle                                    trackerStyle;

@end

@implementation LYTVSegmentCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutContentView];
        
        self.trackerStyle = kLYSegmentCellTrackerStyle(reuseIdentifier);
        
        [self.contentView addSubview:self.segmentView];
        [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kLYSegmentCellHeight(reuseIdentifier)).priorityHigh();
        }];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutContentView {
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
    if ( !self.segmentView.attribute ) {
        self.segmentView.attribute = self.attribute;
    }
    
    if ( !self.segmentView.pageMenuAttribute ) {
        self.segmentView.pageMenuAttribute = self.pageMenuAttribute;
    }
    
    if ( self.segmentView.controllers.count == 0 ) {
        self.segmentView.controllers = self.controllers;
    }
    
    if ( self.segmentView.pageTitles.count == 0 ) {
        self.segmentView.pageTitles = self.pageTitles;
    }
    
    if ( self.segmentView.pageMenuHeight == 0 ) {
        self.segmentView.pageMenuHeight = self.pageMenuHeight;
    }
    
}

#pragma mark - Http


#pragma mark - Getter&&Setter

- (LYSegmentView *)segmentView {
    if( !_segmentView ){
        _segmentView = [[LYSegmentView alloc] initWithTrackerStyle:self.trackerStyle];
        _segmentView.backgroundColor = UIColor.clearColor;
    }
    return _segmentView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    
    self.segmentView.selectedIndex = self.selectedIndex;
}

@end

@implementation UITableView (Segment)
@dynamic segmentCell;

- (LYTVSegmentCell *)dequeueReusableSegmentCellWithDelegate {
    
    LYTVSegmentCell *cell = objc_getAssociatedObject(self, LYTVSegmentCellKey);
    if ( cell ) {
        return cell;
    }
    
    cell = [self dequeueReusableCellWithIdentifier:kLYSegmentCellIdentifier];
    cell.selectedIndex = [[self.segmentViewController valueForKey:@"currentIndex"] integerValue];

    id<LYSegmentDataSource> dataSource = self.segmentViewController.segmentDataSource;
    
    if ( !dataSource )  return cell;
    
    NSMutableArray<LYSMSubBaseViewController *> *controllers = @[].mutableCopy;
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    NSInteger numbers = 0;
    if ( [dataSource respondsToSelector:@selector(numberOfSegment)] ) {
        numbers = [dataSource numberOfSegment];
    }
    for (int i = 0; i < [dataSource numberOfSegment]; i++) {
        
        LYSMSubBaseViewController *controller = nil;
        if ( [dataSource respondsToSelector:@selector(controllerOfSegmentWithIndex:)] ) {
            controller = [dataSource controllerOfSegmentWithIndex:i];
            if ( ![controller isKindOfClass:LYSMSubBaseViewController.class] ) {
                continue;
            }
            [controllers addObject:controller];
        }
        
        if ( [dataSource respondsToSelector:@selector(titleOfSegmentWithIndex:)] ) {
            NSString *title = [dataSource titleOfSegmentWithIndex:i];
            [titles addObject:title];
        }
    }
    
    cell.pageTitles = titles;
    cell.controllers = controllers;

    if ( [dataSource respondsToSelector:@selector(segmentPageMenuDictionary)]) {
        cell.pageMenuAttribute = [dataSource segmentPageMenuDictionary];
    }
    
    id<LYSegmentDelegate> delegate = self.segmentViewController.segmentDelegate;
    if ( delegate && [delegate respondsToSelector:@selector(heightOfSegmentPageMenu)]) {
        cell.pageMenuHeight = [delegate heightOfSegmentPageMenu];
    }
    
    objc_setAssociatedObject(self, LYTVSegmentCellKey, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return cell;
}

- (LYTVSegmentCell *)dequeueReusableSegmentCellWithAttributeDelegate {
    
    LYTVSegmentCell *cell = objc_getAssociatedObject(self, LYTVSegmentCellKey);
    if ( cell ) {
        return cell;
    }
    
    cell = [self dequeueReusableCellWithIdentifier:kLYSegmentCellIdentifier];
    cell.selectedIndex = [[self.segmentViewController valueForKey:@"currentIndex"] integerValue];

    id<LYSegmentDataSource> dataSource = self.segmentViewController.segmentDataSource;
    if ( !dataSource )  return cell;

    if ( [dataSource respondsToSelector:@selector(segmentAttributedArray)]) {
        cell.attribute = [dataSource segmentAttributedArray];
    }
    
    if ( [dataSource respondsToSelector:@selector(segmentPageMenuDictionary)]) {
        cell.pageMenuAttribute = [dataSource segmentPageMenuDictionary];
    }
    
    objc_setAssociatedObject(self, LYTVSegmentCellKey, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return cell;

}

- (LYTVSegmentCell *)dequeueReusableSegmentCellWithAttribute:(LYSegmentParams)params {

    LYTVSegmentCell *cell = objc_getAssociatedObject(self, LYTVSegmentCellKey);
    if ( cell ) {
        return cell;
    }
    
    LYSAttribute *attModel = [LYSAttribute new];
    params(attModel);

    cell = [self dequeueReusableCellWithIdentifier:kLYSegmentCellIdentifier];
    cell.selectedIndex = [[self.segmentViewController valueForKey:@"currentIndex"] integerValue];
    cell.attribute = attModel.attribute;
    cell.pageMenuAttribute = attModel.pageMenuAttribute;

    objc_setAssociatedObject(self, LYTVSegmentCellKey, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return cell;

}

- (void)refreshCurrentSubController {
    
    [self.segmentCell.segmentView refreshCurrentSubController];
}

- (void)refreshCurrentSubControllerWithComplete:(void (^)(id))complete {
    
    [self.segmentCell.segmentView refreshCurrentSubControllerWithComplete:complete];
}

- (LYTVSegmentCell *)segmentCell {
    NSInteger sections = [self numberOfSections];
    for (int s = 0; s < sections; s++) {
        NSInteger rows = [self numberOfRowsInSection:s];
        for (int r = 0; r < rows; r++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
            LYTVSegmentCell *cell = [self cellForRowAtIndexPath:indexPath];
            if ( [cell isKindOfClass:LYTVSegmentCell.class]) {
                return cell;
            }
        }
    }
    return nil;
}

@end
