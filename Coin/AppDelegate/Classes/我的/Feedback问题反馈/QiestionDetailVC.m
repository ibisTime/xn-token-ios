//
//  QiestionDetailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "QiestionDetailVC.h"
#import "QuestionDetail.h"
#import <MJRefresh/MJRefresh.h>
#import "NSString+Date.h"
#import "TLUIHeader.h"
#import "CoinUtil.h"
#import "NSString+Check.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface QiestionDetailVC () <UIScrollViewDelegate>

@property (nonatomic ,strong) UIImageView *bgImage;
@property (nonatomic ,strong) QuestionDetail *tableView;
@property (nonatomic,strong) NSArray <QuestionModel *>*questions;
@property (nonatomic ,strong) QuestionModel *questionModel;
@property (nonatomic ,strong) UIScrollView *contentView;
@property (nonatomic ,strong)  UIImageView *imageView;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;

@property (nonatomic ,strong) UILabel *desLab;
@property (nonatomic ,strong) UILabel *desLab2;

@property (nonatomic ,strong) UILabel *comLab;
@property (nonatomic ,strong) UILabel *comLab2;

@property (nonatomic ,strong) UILabel *noteLab;
@property (nonatomic ,strong) UILabel *noteLab2;

@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UILabel *timeLab2;

@property (nonatomic ,strong) UILabel *bugLab;
@property (nonatomic ,strong) UILabel *bugLab2;

@property (nonatomic ,strong) UILabel *sureLab;
@property (nonatomic ,strong) UILabel *sureLab2;
@property (nonatomic ,strong) UIView *line2;
@property (nonatomic ,strong) UIView *line3;
@property (nonatomic ,strong) UIView *line4;
@property (nonatomic ,strong) UIView *line5;
@property (nonatomic ,strong) UIView *line6;
@property (nonatomic ,strong) UILabel *symbolBlance;

@end

@implementation QiestionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"问题详情" key:nil];

    [self initHeadView];
    [self loadList];
    // Do any additional setup after loading the view.
}
- (void)initHeadView
{
    UIView *top = [[UIView alloc] init];
    [self.view addSubview:top];
    top.backgroundColor = kHexColor(@"#0848DF");
    
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    
    self.bgImage = bgImage;
    bgImage.image = kImage(@"提背景");
    bgImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@90);
        
    }];
    
    UILabel *blance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    blance.text = [LangSwitcher switchLang:@"最终发放奖励金额" key:nil];
    [bgImage addSubview:blance];
    [blance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_top).offset(19);
        make.centerX.equalTo(bgImage.mas_centerX);
        
    }];
    UILabel *symbolBlance = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#007AFF") font:22];
    [bgImage addSubview:symbolBlance];
    self.symbolBlance = symbolBlance;
    CoinModel *currentCoin = [CoinUtil getCoinModel:@"WAN"];
    
//    NSString *leftAmount = [self.questionModel.payAmount subNumber:currentCoin.withdrawFeeString];
//    NSString *text1 =  [CoinUtil convertToRealCoin:leftAmount coin:@"WAN"];
//    symbolBlance.text = [NSString stringWithFormat:@"%.2f",[text1 floatValue]];
//    [NSString stringWithFormat:@"%.6f %@",[self.currency.balance doubleValue]/1000000000000000000,self.currency.symbol];
    [symbolBlance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blance.mas_bottom).offset(2);
        make.centerX.equalTo(bgImage.mas_centerX);
        
    }];
    UIScrollView *contentView = [[UIScrollView alloc] init];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    contentView.userInteractionEnabled = YES;
    contentView.scrollEnabled = YES;
    contentView.delegate = self;
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(90, 0, 0, 0));
//    }];
    contentView.frame = CGRectMake(0, 90, kScreenWidth, kScreenHeight - 90 - kNavigationBarHeight);
//    contentView.contentSize = CGSizeMake(0, kScreenHeight);
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.nameLab];
    
    self.stateLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.stateLab];
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(20);
//        make.width.equalTo(@100);

    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLab.mas_centerY);
        make.left.equalTo(self.nameLab.mas_right).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-10);
        
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kLineColor;
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    
    self.desLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.desLab];
    
    self.desLab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.desLab2];
    self.desLab2.numberOfLines = 0;
    
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
//        make.width.equalTo(@100);

    }];
    [self.desLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.desLab.mas_centerY);
        make.left.equalTo(self.desLab.mas_right).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kLineColor;
    [self.contentView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    
    self.comLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.comLab];
    
    self.comLab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.comLab2];
    
    
    [self.comLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
//        make.width.equalTo(@100);
        
    }];
    [self.comLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.comLab.mas_centerY);
        make.left.equalTo(self.comLab.mas_right).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        
        
    }];
    self.comLab2.numberOfLines = 0;

    UIView *line2 = [UIView new];
    self.line2 = line2;
    line2.backgroundColor = kLineColor;
    [self.contentView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    
//    UIView *imageView = [UIView new];
//
//    UILabel *photo = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
//
//    [imageView addSubview:photo];
//    imageView.hidden = YES;
//    [self.contentView addSubview:imageView];
//
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.comLab2.mas_bottom).offset(30);
//        make.left.equalTo(self.nameLab.mas_left);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.height.equalTo(@100);
//
//
//    }];
    
    self.noteLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.noteLab];
    
    self.noteLab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.noteLab2];
    
    
    
//    [self.noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(line2.mas_bottom).offset(20);
//            make.left.equalTo(self.view.mas_left).offset(20);
//    }];
////    self.noteLab.backgroundColor = [UIColor redColor];
//
//    [self.noteLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.noteLab.mas_centerY);
//        make.left.equalTo(self.noteLab.mas_right).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//
//    }];
//    self.noteLab2.backgroundColor = [UIColor redColor];

    UIView *line3 = [UIView new];
    line3.backgroundColor = kLineColor;
    [self.contentView addSubview:line3];
    self.line3 = line3;

    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    
    self.timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.timeLab];
    
    self.timeLab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.timeLab2];
    
    
//    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line3.mas_bottom).offset(20);
//        make.left.equalTo(self.view.mas_left).offset(10);
//
//    }];
//    [self.timeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.timeLab.mas_centerY);
//        make.left.equalTo(self.timeLab.mas_right).offset(20);
////        make.right.equalTo(self.view.mas_right).offset(-10);
//
//    }];

    UIView *line4 = [UIView new];
    line4.backgroundColor = kLineColor;
    [self.contentView addSubview:line4];
    self.line4 = line4;

    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    
    self.bugLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.bugLab];
    
    self.bugLab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.bugLab2];
    
    
//    [self.bugLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line4.mas_top).offset(20);
//        make.left.equalTo(self.view.mas_left).offset(10);
//
//    }];
//    [self.bugLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bugLab.mas_centerY);
//        make.left.equalTo(self.bugLab.mas_right).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//
//    }];

    UIView *line5 = [UIView new];
    line5.backgroundColor = kLineColor;
    [self.contentView addSubview:line5];
    self.line5 = line5;

    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bugLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    
    self.sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.contentView addSubview:self.sureLab];
    
    self.sureLab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.sureLab2];
    
    

    
    UIView *line6 = [UIView new];
    self.line6 = line6;
    line6.backgroundColor = kLineColor;
    [self.contentView addSubview:line6];
    
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureLab.mas_bottom).offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
        
    }];
    

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    NSLog(@"contentSize%@",NSStringFromCGSize(self.contentView.contentSize));
    NSLog(@"frame%@",NSStringFromCGRect(self.contentView.frame));

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"contentSize%@",NSStringFromCGSize(self.contentView.contentSize));
    NSLog(@"frame%@",NSStringFromCGRect(self.contentView.frame));
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"contentSize%@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"frame%@",NSStringFromCGRect(scrollView.frame));
    
}


- (void)loadmore
{
    [self loadList];
}
- (void)loadNew
{
    [self loadList];

}

- (void)loadList
{
    CoinWeakSelf;
    
    TLNetworking *helper = [[TLNetworking alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
  
    helper.code = @"805106";
    helper.parameters[@"code"] = self.code;
    
    
    [helper postWithSuccess:^(id responseObject) {
        weakSelf.questionModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        weakSelf.tableView.model = weakSelf.questionModel;
        
        [weakSelf.tableView reloadData];
        
        [self reloadData];
//        NSLog(@"%@",objs);
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    self.nameLab.text = [LangSwitcher switchLang:@"所在端" key:nil];
    self.stateLab.text = [LangSwitcher switchLang:self.questionModel.deviceSystem key:nil];

    self.desLab.text = [LangSwitcher switchLang:@"问题描述" key:nil];
    self.desLab2.text = [LangSwitcher switchLang:self.questionModel.Description key:nil];


    self.comLab.text = [LangSwitcher switchLang:@"复现步骤" key:nil];
    self.comLab2.text = [LangSwitcher switchLang:self.questionModel.reappear key:nil];
    self.sureLab.text = [LangSwitcher switchLang:@"最终确认等级" key:nil];
    self.sureLab2.text = [LangSwitcher switchLang:self.questionModel.level key:nil];
 

    NSArray *arr = [self.questionModel.pic componentsSeparatedByString:@"||"];
    if (self.questionModel.pic) {

        self.imageView = [[UIImageView alloc]init];
        for (int i = 0; i < arr.count; i ++) {
            UIImageView *photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15 + i%4*((SCREEN_WIDTH - 60 )/4 + 10), self.comLab.yy + 100 + i/4*((SCREEN_WIDTH - 60 )/4 + 10), (SCREEN_WIDTH - 60)/4, (SCREEN_WIDTH - 60)/4)];
            kViewRadius(photoImage, 5);
            [photoImage sd_setImageWithURL:[NSURL URLWithString:[arr[i] convertImageUrl]]];
            [self.contentView addSubview:photoImage];
            if (i == arr.count - 1) {
                self.imageView = photoImage;
            }
        }
        [self.noteLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(30);
            make.left.equalTo(self.view.mas_left).offset(10);
        }];

        [self.noteLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.noteLab.mas_centerY);
            make.left.equalTo(self.noteLab.mas_right).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-10);

        }];



        [self.line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noteLab.mas_bottom).offset(20);
            make.left.equalTo(self.nameLab.mas_left);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.height.equalTo(@0.5);
        }];

        [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line3.mas_bottom).offset(20);
            make.left.equalTo(self.view.mas_left).offset(10);

        }];

        [self.timeLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timeLab.mas_centerY);
            make.left.equalTo(self.timeLab.mas_right).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-10);

        }];



        [self.line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLab.mas_bottom).offset(20);
            make.left.equalTo(self.nameLab.mas_left);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.height.equalTo(@0.5);


        }];

        [self.bugLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line4.mas_top).offset(20);
            make.left.equalTo(self.view.mas_left).offset(10);

        }];


        [self.bugLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bugLab.mas_centerY);
            make.left.equalTo(self.bugLab.mas_right).offset(20);
            //                    make.right.equalTo(self.view.mas_right).offset(-10);

        }];

        UIView *line5 = [UIView new];
        line5.backgroundColor = kLineColor;
        [self.contentView addSubview:line5];
        self.line5 = line5;

        [self.line5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bugLab.mas_bottom).offset(20);
            make.left.equalTo(self.nameLab.mas_left);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.height.equalTo(@0.5);


        }];
        [self.sureLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line5.mas_bottom).offset(20);
            make.left.equalTo(self.view.mas_left).offset(10);

        }];
        [self.sureLab sizeToFit];

        [self.sureLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sureLab.mas_centerY);
            make.left.equalTo(self.sureLab.mas_right).offset(20);
            //                    make.right.equalTo(self.view.mas_right).offset(-10);

        }];

        [self.line6 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sureLab.mas_bottom).offset(20);
            make.left.equalTo(self.nameLab.mas_left);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.height.equalTo(@0.5);
        }];

        [self.contentView setNeedsLayout];
        [self.contentView setNeedsDisplay];

    }else{

        self.noteLab.text = [LangSwitcher switchLang:@"备注" key:nil];
        self.noteLab2.text = [LangSwitcher switchLang:self.questionModel.commitNote key:nil];

    }

    self.noteLab.text = [LangSwitcher switchLang:@"备注" key:nil];
    self.noteLab2.text = [LangSwitcher switchLang:self.questionModel.commitNote key:nil];
    self.timeLab.text = [LangSwitcher switchLang:@"提交时间" key:nil];
    self.timeLab2.text = [LangSwitcher switchLang:[self.questionModel.commitDatetime convertDate] key:nil];

    self.bugLab.text = [LangSwitcher switchLang:@"bug状态" key:nil];
    if ([self.questionModel.status isEqualToString:@"0"]) {
        self.bugLab2.text = [LangSwitcher switchLang:@"待确认" key:nil];

    }else if ([self.questionModel.status isEqualToString:@"1"]) {
        self.bugLab2.text = [LangSwitcher switchLang:@"已确认,待奖励" key:nil];

    }
    else if ([self.questionModel.status isEqualToString:@"2"]) {
        self.bugLab2.text = [LangSwitcher switchLang:@"复现不成功" key:nil];

    }else{
        self.bugLab2.text = [LangSwitcher switchLang:@"已领取" key:nil];
    }

    
    self.contentView.contentSize = CGSizeMake(0, self.imageView.yy + 250);

    CoinModel *currentCoin = [CoinUtil getCoinModel:@"WAN"];
    if ([self.questionModel.payAmount isBlank] || !self.questionModel.payAmount) {
        self.symbolBlance.text = [NSString stringWithFormat:@"0wan"];

//        return;
    }else{
//        NSString *leftAmount = [self.questionModel.payAmount subNumber:currentCoin.withdrawFeeString];
        
        NSString *text1 =  [CoinUtil convertToRealCoin:self.questionModel.payAmount  coin:@"WAN"];
        self.symbolBlance.text = [NSString stringWithFormat:@"%.2fwan",[text1 floatValue]];
    }
   
//   self.symbolBlance.text = [NSString stringWithFormat:@"%.0fwan",[self.questionModel.payAmount doubleValue]/1000000000000000000];
    NSLog(@"contentSize%@",NSStringFromCGSize(self.contentView.contentSize));
    NSLog(@"frame%@",NSStringFromCGRect(self.contentView.frame));

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
