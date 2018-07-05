//
//  BuildCheckVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CurrencyTitleModel.h"
@interface BuildCheckVC : TLBaseVC
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *> *bottomtitles;
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*titles;
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*tempTitles;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*userTitles;

@property (nonatomic, copy) NSString *titleWord;

@property (nonatomic, copy) NSString *pwd;


@property (nonatomic, assign) BOOL isCopy;


@end
