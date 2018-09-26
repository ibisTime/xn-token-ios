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
@interface TLMoneyDetailsTableView()<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate>
{
    BOOL isOrOpen[5];
    CGFloat webViewHeight;
}

@property (nonatomic , strong)TLMoneyDetailsHeadView *headView;

//声明一个区号，用来记录上一个
@property (nonatomic , assign)NSInteger selectSxtion;

@property (nonatomic , strong)UIWebView *web;

@end

@implementation TLMoneyDetailsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[TLMoneyDeailCell class] forCellReuseIdentifier:TLMoneyDeail];
        [self registerClass:[TLMoneyDetailsAttributesCell class] forCellReuseIdentifier:TLMoneyDetailsAttributes];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];



        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        TLMoneyDetailsHeadView *headView = [[TLMoneyDetailsHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235 - 64 + kNavigationBarHeight)];
        headView.backgroundColor = RGB(41, 127, 237);
        self.tableHeaderView = headView;
        self.headView = headView;
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
        TLMoneyDeailCell *cell = [tableView dequeueReusableCellWithIdentifier:TLMoneyDeail forIndexPath:indexPath];

        //    cell.model = self.Moneys[indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        TLMoneyDetailsAttributesCell *cell = [tableView dequeueReusableCellWithIdentifier:TLMoneyDetailsAttributes forIndexPath:indexPath];
        //    cell.model = self.Moneys[indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

//    static NSString *identifier = @"webCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }

    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
        // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (!cell) {

         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
         self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
         self.web.delegate =self;
         self.web.scrollView.bounces=NO;
         self.web.backgroundColor = kWhiteColor;
         self.web.dataDetectorTypes=UIDataDetectorTypeNone;
         [self.web.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
         [cell addSubview:self.web];
         [self.web loadHTMLString:self.moneyModel.Description baseURL:nil];
     }

    return cell;

}

//监听触发
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        //通过JS代码获取webview的内容高度
        webViewHeight = [[self.web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        self.web.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight);
        [self reloadData];
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:self.selectSxtion];
//        [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

    }
}

-(void)dealloc
{
    [self.web.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    if (indexPath.section == 1) {
        return 143;
    }
    return webViewHeight;
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

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = kLineColor;
        [headView addSubview:lineView];

        return headView;

    }
    return nil;
}

-(void)headButtonClick:(UIButton *)sender
{
    //    WGLog(@"%ld",button.tag);
    isOrOpen[self.selectSxtion]=NO;
    isOrOpen[sender.tag] = YES;
    //    重新标记被选中的区
    self.selectSxtion = sender.tag;
    [self reloadData];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:self.selectSxtion];
//    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [UIView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = (235 - 64 + kNavigationBarHeight);
    // 获取到tableView偏移量
    CGFloat Offset_y = scrollView.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if ( Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = height - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / height;
        CGFloat width = SCREEN_WIDTH;
        // 拉伸后图片位置
        self.headView.backImage.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
    }
}

@end
