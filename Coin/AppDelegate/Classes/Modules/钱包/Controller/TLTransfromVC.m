//
//  TLTransfromVC.m
//  Coin
//
//  Created by shaojianfei on 2018/7/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTransfromVC.h"

@interface TLTransfromVC ()
@property (nonatomic ,strong) TLPlaceholderView *placeholderView;
@end

@implementation TLTransfromVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
//    [LangSwitcher currentLang];
    self.title = [LangSwitcher switchLang:@"一键划转" key:nil];
    UIImageView *image =   [UIImageView new];
    image.contentMode = UIViewContentModeScaleToFill;
    if ([LangSwitcher currentLangType] == LangTypeKorean) {
        image.image = kImage(@"洞悉-一键划转--韩文");


    }else{
        image.image = kImage(@"洞悉一键划转");

    }
    [self.view addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"敬请期待!" key:nil] textColor:kTextColor];
//
//        [self.view addSubview:self.placeholderView];
    // Do any additional setup after loading the view.
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
