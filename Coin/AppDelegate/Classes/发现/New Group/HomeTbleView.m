//
//  HomeTbleView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/19.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "HomeTbleView.h"
#import "HomeCell.h"
@interface HomeTbleView()<UITableViewDelegate, UITableViewDataSource>



@end
@implementation HomeTbleView

static NSString *identifierCell = @"homeCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[HomeCell class] forCellReuseIdentifier:identifierCell];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.findModels.count > 0) {
            return 1;
        }else
        {
            return 0;
        }
    }
    return self.findModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        //商业应用
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kTextBlack font:16.0];
        textLbl.text = [LangSwitcher switchLang:@"推荐应用" key:nil];
        [cell addSubview:textLbl];
        textLbl.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 50);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.findModels.count > 0) {
        cell.findModel = self.findModels[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 50;
    }
    return 113;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.01;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

@end
