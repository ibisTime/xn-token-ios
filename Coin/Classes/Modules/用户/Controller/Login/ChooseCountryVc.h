//
//  ChooseCountryVc.h
//  Coin
//
//  Created by shaojianfei on 2018/7/1.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CountryModel.h"

@interface ChooseCountryVc : TLBaseVC

typedef void(^selectCurrent)(CountryModel *model );


@property (nonatomic ,strong)  UIButton *cancelBtn;

@property (nonatomic ,copy)  selectCurrent selectCountry;

@end
