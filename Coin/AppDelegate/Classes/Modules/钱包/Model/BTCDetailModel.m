//
//  BTCDetailModel.m
//  Coin
//
//  Created by shaojianfei on 2018/8/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BTCDetailModel.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
@implementation BTCDetailModel

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        //
        self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);

            //            make.width.equalTo(@60);
//            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentLeft;
        self.rightLabel.numberOfLines = 0;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.titleLbl.mas_top);
            
        }];
        
    }
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = kBackgroundColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@2);
        
        
    }];
    
    return self;
}

-(void)setLocalInfo:(NSArray *)localInfo
{
    _localInfo = localInfo;
    
}

-(void)localInfoWithData:(NSArray *)arr index:(NSInteger)inter
{
    self.titleLbl.text = arr[inter];
    
}


- (void)localInfoWithRightData:(NSArray *)arr index:(NSInteger)inter
{
    self.rightLabel.text = arr[inter];
   
    
}

@end
