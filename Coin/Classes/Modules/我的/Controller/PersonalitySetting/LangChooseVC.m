//
//  LangChooseVC.m
//  Coin
//
//  Created by  tianlei on 2017/12/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "LangChooseVC.h"
#import "SettingModel.h"
#import "CoinHeader.h"

@interface LangChooseVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *langChooseTV;
@property (nonatomic, strong) NSMutableArray <SettingModel *>*models;
@end

@implementation LangChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"语言" key:nil];
    self.models = [[NSMutableArray alloc] init];
    
    self.langChooseTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.langChooseTV];
    self.langChooseTV.delegate = self;
    self.langChooseTV.dataSource = self;
    self.langChooseTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakself = self;
    //
    SettingModel *simpleModel = [[SettingModel alloc] init];
    simpleModel.text = [LangSwitcher switchLang:@"简体中文" key:nil];
    simpleModel.isSelect = [LangSwitcher currentLangType] == LangTypeSimple;
    [simpleModel setAction:^{
        
        [weakself langType:LangTypeSimple];
    }];
    //
    SettingModel *tridationModel = [[SettingModel alloc] init];
    tridationModel.text = [LangSwitcher switchLang:@"繁体中文" key:nil];
    tridationModel.isSelect = [LangSwitcher currentLangType] == LangTypeTraditional;
    [tridationModel setAction:^{
        
        [weakself langType:LangTypeTraditional];

    }];
    
    //
    [self.models addObjectsFromArray:@[simpleModel,tridationModel]];
    
    
}

- (void)langType:(LangType)type {
    
        [TLAlert alertWithTitle:@""
                            msg:[LangSwitcher switchLang:@"切换语言需要退出应用" key:nil]
                     confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                      cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                         cancle:^(UIAlertAction *action) {
    
                         } confirm:^(UIAlertAction *action) {
    
                             [LangSwitcher changLangType:type];
                             //                             UIView *v = nil;
                             //                             [v sizeToFit];
                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                             dict[nil] = @"";
                         }];
    
}

- (void)viewDidLayoutSubviews {
    self.langChooseTV.frame = self.view.bounds;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.models[indexPath.row].action) {
        
        self.models[indexPath.row].action();
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.7);
            make.left.bottom.right.equalTo(cell);
        }];
        
        
        
    }
    
    // 判断出当前类型
    
    SettingModel *settingModel = self.models[indexPath.row];
    cell.textLabel.text = settingModel.text;

    if (settingModel.isSelect) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        iv.backgroundColor = [UIColor orangeColor];
        [cell addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-20);
            make.height.width.mas_equalTo(20);
        }];

    }
    
    
    return cell;
    
}


@end
