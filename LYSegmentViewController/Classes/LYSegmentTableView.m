//
//  LYSegmentTableView.m
//  LYSegmentViewController
//
//  Created by wans on 2017/12/19.
//

#import "LYSegmentTableView.h"

@implementation LYSegmentTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


@end
