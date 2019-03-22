//
//  WalletLocalWebVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletLocalWebVC.h"
#import "AppConfig.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface WalletLocalWebVC ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView *web;
@end

@implementation WalletLocalWebVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [LangSwitcher switchLang:@"更多" key:nil];
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT - kNavigationBarHeight)];
//    self.web.scalesPageToFit = YES;
    [self.view addSubview:self.web];
    self.web.delegate = self;
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *type;
    
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT type from THALocal where symbol = '%@'",self.currentModel.symbol];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            type = [set stringForColumn:@"type"];
//            
//        }
//        [set close];
//    }
    
    NSArray *muArray = [[NSUserDefaults standardUserDefaults]objectForKey:COINARRAY];
    for (int i = 0; i < muArray.count; i ++) {
        if ([self.currentModel.symbol isEqualToString:muArray[i][@"symbol"]]) {
            type = muArray[i][@"type"];
        }
    }
    
    [dataBase.dataBase close];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.currentModel.symbol isEqualToString:@"USDT"]) {
        
        [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://omniexplorer.info/search/",self.urlString]]]];
        
    }else
    {
        if ([type isEqualToString:@"0"]) {
            if ([self.currentModel.symbol isEqualToString:@"ETH"]) {
                [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].ethHash,self.urlString]]]];
            }else if([self.currentModel.symbol isEqualToString:@"WAN"]){
                
                [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].wanHash,self.urlString]]]];
                NSLog(@"====== %@",[NSString stringWithFormat:@"%@/%@",[AppConfig config].wanHash,self.urlString]);
            }else{
                [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/tx/%@",[AppConfig config].btcHash,self.urlString]]]];
            }
        }else if ([type isEqualToString:@"1"])
        {
            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].ethHash,self.urlString]]]];
            
        }else{
            
            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[AppConfig config].ethHash,self.urlString]]]];
        }
    }
    
    
   
   
    
    
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


@end
