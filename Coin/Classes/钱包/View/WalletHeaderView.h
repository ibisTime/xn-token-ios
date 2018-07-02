//
//  WalletHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WalletHeaderBlock)(void);
typedef void(^WalletAddBlock)(void);
typedef void(^SwitchSelectBlock)(NSInteger teger);
typedef void(^WalletCodeBlock)(void);
typedef void(^WalletclearBlock)(void);

@interface WalletHeaderView : UIView

@property (nonatomic, copy) WalletHeaderBlock headerBlock;
@property (nonatomic, copy) WalletAddBlock addBlock;
@property (nonatomic, copy) SwitchSelectBlock switchBlock;
@property (nonatomic, copy) WalletCodeBlock codeBlock;
@property (nonatomic, copy) WalletclearBlock clearBlock;


//总资产(人民币)
@property (nonatomic, strong) UILabel *cnyAmountLbl;
//美元
@property (nonatomic, strong) UILabel *usdAmountLbl;
//港元
@property (nonatomic, strong) UILabel *hkdAmountLbl;
//美元汇率
@property (nonatomic, copy) NSString *usdRate;
//港元汇率
@property (nonatomic, copy) NSString *hkdRate;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong)  UIView *whiteView;

@property (nonatomic, strong) UILabel *privateMoney;
@property (nonatomic, strong) UILabel *LocalMoney;

@property (nonatomic, strong) UIButton *codeButton;
-(void)swipeBottomClick:(UISwipeGestureRecognizer *)swpie;
@end
