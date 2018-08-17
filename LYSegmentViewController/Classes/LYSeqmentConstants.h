//
//  LYSeqmentConstants.h
//  HomePage https://github.com/wans3112/LYSegmentViewController
//
//  Created by wans on 2017/12/16.
//  Copyright © 2017年 wans,www.wans3112.cn All rights reserved.
//

#ifndef LYSeqmentConstants_h
#define LYSeqmentConstants_h

static NSString *const LYSGoTopNotificationName                   =   @"gotoTop"; // 进入置顶通知
static NSString *const LYSLeaveTopNotificationName                =   @"leaveTop"; // 离开置顶通知
static NSString *const LYSScrollViewNotificationName              =   @"scrollview"; // 主列表是否可以滑动滑动状态

typedef NSString * LYSegmentAttributedStringKey;  //!< 定义segment主要属性key类型，key为下面定义的四种类型
typedef NSString * LYSegmentPageMenuValuePathKey; //!< 定义pagemenu属性key类型，key为SPPageMenu头文件中对应的属性名或属性路径

typedef NSDictionary<LYSegmentAttributedStringKey,id> LYSegmentAttributedDictionary;
typedef NSArray<NSDictionary<LYSegmentAttributedStringKey,id> *> LYSegmentAttributedArray;
typedef NSDictionary<LYSegmentPageMenuValuePathKey,id> LYSegmentPageMenuDictionary;

static LYSegmentAttributedStringKey const LYSTitleAttributeName   =   @"seg_title"; //!< 分页按钮栏的名称
static LYSegmentAttributedStringKey const LYSClassAttributeName   =   @"seg_className"; //!< 子控制器的类名
static LYSegmentAttributedStringKey const LYSParamsAttributeName  =   @"seg_params"; //!< 子控制器的参数
static LYSegmentAttributedStringKey const LYSStyleAttributeName   =   @"seg_style"; //!< 子控制器tableview的style

static NSString *const LYSegmentBeginRefreshNotificationName      =   @"seg_notify_begin_refresh"; // 子控制器开始刷新
static NSString *const LYSegmentEndRefreshNotificationName        =   @"seg_notify_end_refresh"; // 子控制器结束刷新

static NSString *const LYSegmentCellIdentifier                    =   @"LYTVSegmentCell"; //!< LYSegmentCell标识

// 下拉刷新策略
typedef enum : NSUInteger {
    LYSementRefrshingPolicyNone = 1,            // 无下拉刷新
    LYSementRefrshingPolicyMain = 2,            // 主控制器下拉刷新
    LYSementRefrshingPolicyChild = 3,           // 子控制器下拉刷选
} LYSementRefrshingPolicy;

#define kPageMenuHeight                                               44 // 标签栏高度

#define kClassNameSegmentViewController                               @"LYSegmentViewController"     // 主控制器基类名
#define kClassNameSubBaseViewController                               @"LYSMSubBaseViewController"   // 子控制器基类名

#define LYSegmentCommonViewController(className) \
({ \
    id value = self; \
    UIViewController *viewController = nil; \
    if ( !className && [value isKindOfClass:[UIViewController class]] && ![value isKindOfClass:NSClassFromString(kClassNameSubBaseViewController)]) { \
        viewController = (UIViewController *)value; \
    }else if ( className && [value isKindOfClass:NSClassFromString(kClassNameSubBaseViewController)] ) { \
        viewController = (UIViewController *)value; \
    }else if ( [value isKindOfClass:NSClassFromString(kClassNameSegmentViewController)] ) { \
        viewController = (UIViewController *)value; \
    }else { \
        for (UIView *view = value; view; view = [view isKindOfClass:NSClassFromString(kClassNameSubBaseViewController)] ? ((UIViewController *)view).view.superview : view.superview) { \
            UIResponder *nextResponder = [view nextResponder]; \
            if ( className && [nextResponder isKindOfClass:NSClassFromString(className)]) { \
                viewController = (UIViewController *)nextResponder; \
                break; \
            } \
            if ( !className && [nextResponder isKindOfClass:[UIViewController class]]) { \
                viewController = (UIViewController *)nextResponder; \
                break; \
            } \
        } \
    } \
    viewController; \
})

// 获取主控制器
#define LYSegViewController                                      LYSegmentCommonViewController(nil)

// 获取子控制器
#define LYSegSubViewController                                   LYSegmentCommonViewController(kClassNameSubBaseViewController)

#define LYSegViewControllerTrackerStyleKey                       @"trackerStyle"

// LYSegmentCell的默认标识
#define kLYSegmentCellIdentifier                                 [NSString stringWithFormat:@"_%d%@%d", [[LYSegViewController valueForKey:LYSegViewControllerTrackerStyleKey] intValue], LYSegmentCellIdentifier, (int)CGRectGetHeight(LYSegViewController.view.frame)]

#define kLYSegmentCellHeight(reuseIdentifier)                    [[reuseIdentifier substringFromIndex:LYSegmentCellIdentifier.length + 1 + 1] intValue]

#define kLYSegmentCellTrackerStyle(reuseIdentifier)              [[reuseIdentifier substringWithRange:NSMakeRange(1, 1)] intValue]

/**
 将十六进制色值字符串转换成颜色
 
 @param hexString 十六进制色值（0x/#）
 @return UIColor
 */
#undef  LYSegColorHexString
#define LYSegColorHexString( hexString ) \
({ \
    NSLog(@"%@:hexString exist",hexString); \
    UIColor *tempColor = nil; \
    UIColor *hexColor = nil; \
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; \
    if ([cString length] < 6) { \
        tempColor = [UIColor clearColor]; \
    }else { \
        if ([cString hasPrefix:@"0X"]) \
            cString = [cString substringFromIndex:2]; \
        if ([cString hasPrefix:@"#"]) \
            cString = [cString substringFromIndex:1]; \
        NSRange range; \
        range.location = 0; \
        range.length = 2; \
        NSString *rString = [cString substringWithRange:range]; \
        range.location = 2; \
        NSString *gString = [cString substringWithRange:range]; \
        range.location = 4; \
        NSString *bString = [cString substringWithRange:range]; \
        unsigned int r, g, b; \
        [[NSScanner scannerWithString:rString] scanHexInt:&r]; \
        [[NSScanner scannerWithString:gString] scanHexInt:&g]; \
        [[NSScanner scannerWithString:bString] scanHexInt:&b]; \
        tempColor = [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f]; \
    } \
    hexColor = tempColor; \
}) \

#endif /* LYSeqmentConstants_h */
