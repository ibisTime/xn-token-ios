//
//  HTMLStrVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, HTMLType) {
    HTMLTypeAboutUs = 0,    //关于我们
    HTMLTypeRegProtocol,    //注册协议
    HTMLTypeCommonProblem,  //常见问题
    HTMLTypeLinkService,    //联系客服
    HTMLTypeTradeRemind,    //交易提醒
    HTMLTypeMnemonic,    //什么是助记词
    HTMLTypeCreate_wallet,    //创建钱包流程
    HTMLTypeMnemonic_backup,    //如何备份助记词
    HTMLTypeRed_packet_rule,    //红包规则
    HTMLTypePrivacy,    //隐私政策
    HTMLTypeGlobal_master,    // 首创玩法
    HTMLTypeQuantitative_finance,    //量化理财
    HTMLTypeYubibao    //余币宝

    
};

@interface HTMLStrVC : TLBaseVC

@property (nonatomic, assign) HTMLType type;

@property (nonatomic, copy) NSString *des;

@end
