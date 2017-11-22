//
//  PublishBuyTableView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishBuyTableView.h"

#import "PublishBuyCell1.h"
#import "PublishBuyCell2.h"

#import "TLTextView.h"

@interface PublishBuyTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PublishBuyTableView

static NSString *identifierCell1 = @"PublishBuyCell1";

static NSString *identifierCell2 = @"PublishBuyCell2";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[PublishBuyCell1 class] forCellReuseIdentifier:identifierCell1];
        
        [self registerClass:[PublishBuyCell2 class] forCellReuseIdentifier:identifierCell2];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            PublishBuyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.textTF mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(@0);
                make.left.equalTo(cell.leftTextLbl.mas_right).offset(20);
                make.height.equalTo(@50);
               
                switch (indexPath.row) {
                    case 0:
                    case 1:
                    {
                        make.right.equalTo(cell.promptBtn.mas_left).offset(0);
                    }break;
                        
                    case 2:
                    case 3:
                    case 5:
                    {
                        make.right.equalTo(cell.rightTextLbl.mas_left).offset(-10);
                    }break;
                        
                    case 4:
                    {
                        make.right.equalTo(cell.arrowIV.mas_left).offset(-10);
                    }break;
                        
                    default:
                        break;
                }
                
            }];
            
            return cell;
        }break;
          
        case 1:
        {
            PublishBuyCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }break;
            
        default:
            break;
    }

    PublishBuyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        
        TLTextView *textView = [[TLTextView alloc] initWithFrame:headerView.bounds];
        
        textView.font = Font(14.0);

        textView.placholder = @"请写下您的广告留言吧";
        
        [headerView addSubview:textView];
        
        return headerView;

    }
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

@end
