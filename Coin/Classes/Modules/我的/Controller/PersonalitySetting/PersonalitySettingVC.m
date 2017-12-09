//
//  PersonalitySettingVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PersonalitySettingVC.h"

#import "SettingGroup.h"
#import "SettingModel.h"

#import "CoinHeader.h"

@interface PersonalitySettingVC ()

@property (nonatomic, strong) SettingGroup *group;

@end

@implementation PersonalitySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"个性设置" key:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
