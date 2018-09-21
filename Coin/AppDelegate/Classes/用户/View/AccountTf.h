//
//  AccountTf.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTf : UITextField

@property (nonatomic,strong) UIImageView *leftIconView;

@property (nonatomic,copy) NSString *placeHolder;

//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;

@end
