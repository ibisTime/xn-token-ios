//
//  WalletLocalWebVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletLocalWebVC.h"
#import "AppConfig.h"
@interface WalletLocalWebVC ()
@property (nonatomic ,strong) UIWebView *web;
@end

@implementation WalletLocalWebVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [LangSwitcher switchLang:@"更多" key:nil];
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.web];
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *type;
    
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT type from THALocal where symbol = '%@'",self.currentModel.symbol];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            type = [set stringForColumn:@"type"];
            
        }
        [set close];
    }
    
    [dataBase.dataBase close];
    if ([type isEqualToString:@"0"]) {
        if ([self.currentModel.symbol isEqualToString:@"ETH"]) {
            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].ethHash,self.urlString]]]];
        }else if([self.currentModel.symbol isEqualToString:@"WAN"]){
            
            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].wanHash,self.urlString]]]];
            
        }else{
           [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[AppConfig config].btcHash,self.urlString]]]];
        }
    }else if ([type isEqualToString:@"1"])
    {
         [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].ethHash,self.urlString]]]];
        
    }else{
        
        [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].ethHash,self.urlString]]]];
    }
   
   
    
    
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
