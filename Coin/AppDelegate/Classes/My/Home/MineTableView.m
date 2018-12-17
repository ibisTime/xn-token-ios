//
//  MineTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MineTableView.h"
#import "MineCell.h"
#import "MyAssetsTableViewCell.h"
@interface MineTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MineTableView

static NSString *identifierCell = @"MineCell";
static NSString *MyAssetsTableView = @"MyAssetsTableViewCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[MineCell class] forCellReuseIdentifier:identifierCell];
        [self registerClass:[MyAssetsTableViewCell class] forCellReuseIdentifier:MyAssetsTableView];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyAssetsTableView forIndexPath:indexPath];
        if ([TLUser isBlankString:self.priceStr] == NO) {
            cell.allAssetsLabel.text = self.priceStr;
        }
        if ([TLUser isBlankString:self.earningsStr] == NO) {
            
//            NSString *incomeTotal = [CoinUtil convertToRealCoin2:self.earningsStr setScale:4  coin:@"BTC"];
            cell.earningsLabel.text = self.earningsStr;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([TLUser isBlankString:[TLUser user].idNo] == NO) {
        if (indexPath.row == 1) {
            cell.iconImageView.hidden = YES;
            cell.titleLbl.hidden = YES;
            cell.line.hidden = YES;
        }
    }
    if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == YES) {

        if (indexPath.row == 3) {
            cell.iconImageView.hidden = YES;
            cell.titleLbl.hidden = YES;
            cell.line.hidden = YES;
        }
    }
    
    
    NSArray *imgArray = @[@"收益",@"身份验证",@"账号安全",@"账号安全",@"my通讯录",@"反馈",@"帮助(4)",@"设置"];
    NSArray *textArray = @[@"我的收益",@"身份验证",@"账号安全",@"钱包工具",@"加入社群",@"问题反馈",@"帮助中心",@"设置",];
    
    [cell.iconImageView setImage:kImage(imgArray[indexPath.row]) forState:(UIControlStateNormal)];
    cell.titleLbl.text = [LangSwitcher switchLang:textArray[indexPath.row] key:nil];

    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:scrollView:)]) {
        [self.refreshDelegate refreshTableView:self scrollView:scrollView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 76;
    }
    
    if([TLUser isBlankString:[TLUser user].idNo] == NO)
    {
        if (indexPath.row == 1) {
            return 0;
        }
    }
    
    if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == YES) {
        if (indexPath.row == 3) {
            return 0;
        }
    }
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

@end
