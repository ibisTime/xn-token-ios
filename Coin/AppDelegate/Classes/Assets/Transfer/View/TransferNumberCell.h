//
//  TransferNumberCell.h
//  Coin
//
//  Created by 郑勤宝 on 2018/10/25.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"



@interface TransferNumberCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong)  CurrencyModel *model;

@property (nonatomic ,strong)  UIView *blue;
@property (nonatomic ,strong)  UIView *org;

@property (nonatomic ,strong)  UILabel *myprivate;
@property (nonatomic ,strong)  UILabel *privateKey;
@property (nonatomic ,strong)  UIButton *changebut;

@property (nonatomic ,strong)  TLTextField *inputFiled;
@property (nonatomic ,strong)  TLTextField *googleAuthTF;
@property (nonatomic ,strong)  UIButton *importButton;
@property (nonatomic ,strong) UILabel *Free;

@property (nonatomic ,strong) UIView *wallletView;
@property (nonatomic ,strong) UISlider *slider;
@property (nonatomic ,strong)  UILabel *symbolLab;
//@property (nonatomic ,strong)  UILabel *amountlLab;

@property (nonatomic ,strong)  UIButton *allLab;


@property (nonatomic, strong) UILabel *totalFree;
@property (nonatomic, strong) UILabel *leftAmount;
@property (nonatomic ,strong)  UIView *lineView;

@property (nonatomic, assign) BOOL isLocal;

@end
