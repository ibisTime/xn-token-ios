//
//  TLMoneyDetailsTableView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDetailsTableView.h"
#import "TLMoneyDetailsHeadView.h"
#import "TLMoneyDeailCell.h"
#define TLMoneyDeail @"TLMoneyDeailCell"
#import "TLMoneyDetailsAttributesCell.h"
#define TLMoneyDetailsAttributes @"TLMoneyDetailsAttributesCell"
#import "TLMoneyDeailWebViewCell.h"
#define TLMoneyDeailWebView @"TLMoneyDeailWebViewCell"
@interface TLMoneyDetailsTableView()<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate>
{
    BOOL isOrOpen[5];
    CGFloat webViewHeight1;
    CGFloat webViewHeight2;
    CGFloat webViewHeight3;
    TLMoneyDeailWebViewCell *_cell1;
    TLMoneyDeailWebViewCell *_cell2;
    TLMoneyDeailWebViewCell *_cell3;

    TLMoneyDeailWebViewCell *cell;


}



//声明一个区号，用来记录上一个
@property (nonatomic , assign)NSInteger selectSxtion;



@end

@implementation TLMoneyDetailsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[TLMoneyDeailCell class] forCellReuseIdentifier:TLMoneyDeail];
        [self registerClass:[TLMoneyDetailsAttributesCell class] forCellReuseIdentifier:TLMoneyDetailsAttributes];
        [self registerClass:[TLMoneyDeailWebViewCell class] forCellReuseIdentifier:TLMoneyDeailWebView];
//        [self registerClass:[TLMoneyDeailWebViewce class] forCellReuseIdentifier:@"cell"];



        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        //    标注区
        isOrOpen[0] = YES;
        self.selectSxtion = 0;
    }

    return self;
}



#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0 || section == 1) {
        return 1;
    }
    if (isOrOpen[section] == NO) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        TLMoneyDeailCell *cell1 = [tableView dequeueReusableCellWithIdentifier:TLMoneyDeail forIndexPath:indexPath];

        cell1.moneyModel = self.moneyModel;

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    if (indexPath.section == 1) {
        TLMoneyDetailsAttributesCell *cell1 = [tableView dequeueReusableCellWithIdentifier:TLMoneyDetailsAttributes forIndexPath:indexPath];
        cell1.moneyModel = self.moneyModel;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell1;
    }
    if (indexPath.section == 2) {
        static NSString *identifier = @"webCell1";
        _cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!_cell1){
            _cell1 = [[TLMoneyDeailWebViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            switch ([LangSwitcher currentLangType]) {
                case LangTypeEnglish:
                    [_cell1.web loadHTMLString:self.moneyModel.buyDescEn baseURL:nil];

                    break;
                case LangTypeKorean:
                    [_cell1.web loadHTMLString:self.moneyModel.buyDescKo baseURL:nil];

                    break;
                case LangTypeSimple:
                    [_cell1.web loadHTMLString:self.moneyModel.buyDescZhCn baseURL:nil];

                    break;

                default:
                    break;
            }
            [_cell1.web.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

            [_cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return _cell1;
    }

    if (indexPath.section == 3) {
        static NSString *identifier = @"webCell2";
        _cell2 = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!_cell2){
            _cell2 = [[TLMoneyDeailWebViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            switch ([LangSwitcher currentLangType]) {
                case LangTypeEnglish:
                    [_cell2.web loadHTMLString:self.moneyModel.redeemDescEn baseURL:nil];

                    break;
                case LangTypeKorean:
                    [_cell2.web loadHTMLString:self.moneyModel.redeemDescKo baseURL:nil];

                    break;
                case LangTypeSimple:
                    [_cell2.web loadHTMLString:self.moneyModel.redeemDescZhCn baseURL:nil];

                    break;

                default:
                    break;
            }
            [_cell2.web.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

            [_cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return _cell2;
    }


    static NSString *identifier = @"webCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[TLMoneyDeailWebViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = kWhiteColor;
//        if (indexPath.section == 2) {
//            switch ([LangSwitcher currentLangType]) {
//                case LangTypeEnglish:
//                    [cell.web loadHTMLString:self.moneyModel.buyDescEn baseURL:nil];
//
//                    break;
//                case LangTypeKorean:
//                    [cell.web loadHTMLString:self.moneyModel.buyDescKo baseURL:nil];
//
//                    break;
//                case LangTypeSimple:
//                    [cell.web loadHTMLString:self.moneyModel.buyDescZhCn baseURL:nil];
//
//                    break;
//
//                default:
//                    break;
//            }
//        }
//        if (indexPath.section == 3) {
//
//        }
//        if (indexPath.section == 4) {
//
//        }
        switch ([LangSwitcher currentLangType]) {
            case LangTypeEnglish:
                [cell.web loadHTMLString:self.moneyModel.directionsEn baseURL:nil];

                break;
            case LangTypeKorean:
                [cell.web loadHTMLString:self.moneyModel.directionsKo baseURL:nil];

                break;
            case LangTypeSimple:
                [cell.web loadHTMLString:self.moneyModel.directionsZhCn baseURL:nil];

                break;

            default:
                break;
        }
        [cell.web.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
//        cell = [[TLMoneyDeailWebViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];






//    return cell;

}

//监听触发
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        //通过JS代码获取webview的内容高度
        if (self.selectSxtion == 2) {
//            if (webViewHeight1 == 0) {

                webViewHeight1 = [[_cell1.web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
                _cell1.web.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight1);

//            }
        }
        if (self.selectSxtion == 3) {
//            if (webViewHeight2 == 0) {
                webViewHeight2 = [[_cell2.web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
                _cell2.web.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight2);

//            }
        }
        if (self.selectSxtion == 4) {
//            if (webViewHeight3 == 0) {
                webViewHeight3 = [[cell.web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
                cell.web.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight3);

//            }
        }
        [self reloadData];
    }
}

-(void)dealloc
{
    [cell.web.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    if (indexPath.section == 1) {
        return 143;
    }
    if (indexPath.section == 2) {
        return webViewHeight1;
    }
    if (indexPath.section == 3) {
        return webViewHeight2;
    }

    return webViewHeight3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return 10;
    }
    if (section > 1) {
        return 60;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    if (section == 4) {
        return 40;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section > 1) {

        UIView *headView = [[UIView alloc]init];
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        backView.backgroundColor = kWhiteColor;
        [headView addSubview:backView];
        NSArray *nameArray = @[@"购买属性",@"赎回属性",@"说明书"];
        UIButton *headButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:nameArray[section - 2] key:nil] titleColor:kHexColor(@"#464646") backgroundColor:kClearColor titleFont:16];
        headButton.titleLabel.font = HGboldfont(16);
        headButton.frame = CGRectMake(15, 0, SCREEN_WIDTH - 45, 60);
        [headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        headButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        headButton.tag = section;
        [headView addSubview:headButton];

        UIImageView *youImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 22, 24, 7, 12)];
        youImage.image = kImage(@"更多-灰色");
        [headView addSubview:youImage];
        if (isOrOpen[section] == NO) {
            [UIView animateWithDuration:0.5 animations:^{


                youImage.transform=CGAffineTransformMakeRotation(0*M_PI/180);
            }];
        }else
        {
            [UIView animateWithDuration:0.5 animations:^{

                youImage.transform=CGAffineTransformMakeRotation(90*M_PI/180);
            }];

        }

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = kLineColor;
        [headView addSubview:lineView];

        return headView;

    }
    return nil;
}



-(void)headButtonClick:(UIButton *)sender
{
    if (isOrOpen[sender.tag] == YES) {
        isOrOpen[sender.tag] = NO;
        self.selectSxtion = 0;
    }else
    {
        isOrOpen[sender.tag] = YES;
        self.selectSxtion = sender.tag;

    }
    [self reloadData];
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:sender.tag];
//    [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:scrollView:)]) {
        [self.refreshDelegate refreshTableView:self scrollView:scrollView];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}



@end
