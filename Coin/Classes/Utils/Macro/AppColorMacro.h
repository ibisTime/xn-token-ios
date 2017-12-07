//
//  AppColorMacro.h
//  YS_iOS
//
//  Created by 蔡卓越 on 17/1/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#ifndef AppColorMacro_h
#define AppColorMacro_h

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

#pragma mark - UIMacros

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

// 主色
#define kAppCustomMainColor [UIColor colorWithHexString:@"#f15353"]

// 颜色配置
#define kNavBarMainColor  [UIColor appNavBarMainColor]
#define kNavBarBgColor    [UIColor appNavBarBgColor]


#define kTabbarMainColor   [UIColor appTabbarMainColor]
#define kTabbarBgColor     [UIColor appTabbarBgColor]


// 界面背景颜色
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//151, 215, 76 RGB(195, 207, 72)
#define kNavBarBackgroundColor  RGB(241, 241, 241)

#define kBackgroundColor        [UIColor colorWithHexString:@"#F7F7F7"]   //背景色
#define kLineColor              [UIColor colorWithHexString:@"#EEEEEE"]   //分割线
#define kTextColor              [UIColor colorWithHexString:@"#484848"]   //一级文字
#define kTextColor2             [UIColor colorWithHexString:@"#999999"]   //二级文字
#define kTextColor3             [UIColor colorWithHexString:@"#666666"]   //三级文字
#define kTextColor4             [UIColor colorWithHexString:@"#b3b3b3"]   //四级文字
#define kThemeColor             [UIColor colorWithHexString:@"#f15353"]  //红色文字
#define kPaleBlueColor          [UIColor colorWithHexString:@"#48b0fb"]    //蓝色文字
#define kRiseColor              [UIColor colorWithHexString:@"#2ac64c"]  //涨

#define kAuxiliaryTipColor      [UIColor colorWithHexString:@"#FF254C"]   //辅助提示颜色
#define kBottomItemGrayColor    [UIColor colorWithHexString:@"#FAFAFA"]   //底栏灰色
#define kCommentSecondColor     [UIColor colorWithHexString:@"#FAFAFA"]   //评论二级颜色
#define kPlaceholderColor       [UIColor colorWithHexString:@"#CCCCCC"]
    //占位颜色
/****颜色列表***/


#define kLightGreyColor RGB(153, 153, 153)         //亮灰色 #999999
#define kOrangeRedColor RGB(255, 83, 27)           //橘红色 #ff531b
#define kPaleGreyColor RGB(245, 245, 245)          //淡灰色 #f5f5f5
#define kDeepGreenColor RGB(65, 117, 5)            //深绿色 #417505
#define kLightGreenColor RGB(200, 220, 81)         //浅绿色 #c8dc51
#define kDarkGreenColor kButtonBackgroundColor     //暗绿色 #335322  RGBa(51, 83, 34)
#define kBrickRedColor RGB(240, 41, 0)             //砖红色 #fo2900
#define kWhiteColor RGB(255, 255, 255)             //白色   #ffffff
#define kBlackColor RGB(0, 0, 0)                   //黑色   #000000
#define kSilverGreyColor RGB(236, 236, 236)        //银灰色 #ececec
#define kShallowGreyColor RGB(206, 206, 206)       //浅灰色 #cecece
#define kClearColor [UIColor clearColor]           //透明

#pragma mark - 界面尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(x) (x)*(kScreenWidth)/375.0
#define kHeight(y) (y)*(kScreenHeight)/667.0

#define kDevice_Is_iPhoneX (kScreenHeight == 812 ? YES : NO)
#define kNavigationBarHeight  (kDevice_Is_iPhoneX == YES ? 88: 64)
#define kStatusBarHeight (kDevice_Is_iPhoneX == YES ? 44: 20)

#define kTabBarHeight  (49 + kBottomInsetHeight)
#define kBottomInsetHeight  (kDevice_Is_iPhoneX == YES ? 34: 0)
#define kSuperViewHeight    kScreenHeight - kNavigationBarHeight

#define kLeftMargin 15
#define kLineHeight 0.5

#define kImage(I)       [UIImage imageNamed:I]
#define kFontHeight(F)  [Font(F) lineHeight]

#define Font(F)         [UIFont systemFontOfSize:(F)]

#define boldFont(F)     [UIFont boldSystemFontOfSize:(F)]

#pragma mark - Image

#define USER_PLACEHOLDER_SMALL [UIImage imageNamed:@"头像"]
#define PLACEHOLDER_SMALL @"icon"
#define kCancelIcon @"cancel"
#define GOOD_PLACEHOLDER_SMALL [UIImage imageNamed:@"icon"]

#define kDateFormmatter @"MMM dd, yyyy hh:mm:ss aa"

#pragma mark - 轮播图

#define kCarouselHeight (kScreenWidth/5*3)

//View圆角和加边框

#define kViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
\
[View.layer setMasksToBounds:YES];\
\
[View.layer setBorderWidth:(Width)];\
\
[View.layer setBorderColor:[Color CGColor]]

// View圆角

#define kViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
\
[View.layer setMasksToBounds:YES]

#endif /* AppColorMacro_h */
