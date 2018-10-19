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

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.findModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.findModels.count > 0) {
        cell.findModel = self.findModels[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 113;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 50;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.01;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [UIView new];

    if (self.findModels.count > 0) {
        //商业应用
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextBlack
                                                        font:16.0];
        textLbl.text = [LangSwitcher switchLang:@"推荐应用" key:nil];
        [view addSubview:textLbl];
        textLbl.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 50);
    }

    return view;
}




- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

@end
