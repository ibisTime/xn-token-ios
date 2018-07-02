//
//  TLDataBase.m
//  Coin
//
//  Created by shaojianfei on 2018/6/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLDataBase.h"

@implementation TLDataBase
// 数据库名称
NSString *const dbName = @"THAWallet.db";
+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TLDataBase alloc] init];
    });
    return _instance;
}
- (instancetype)init {
    if (self = [super init]) {
       
        // 使用数据库路径初始化FMDatabase
        self.dataStr = [self dataFilePath];
        self.localStr = [self localFilePath];

        NSLog(@"数据库创建%@",self.dataStr);
        self.dataBase = [FMDatabase databaseWithPath:self.dataStr];

        [self createTable];
        
        if (self.dataStr) {
            FMDatabase *base = [FMDatabase databaseWithPath:self.dataStr];
            if (!base.open)
                
            {
                NSLog(@"fail to open database");
         }
            
        }

        [self createTable];
        
//        NSLog(@"数据库创建%@",self.localStr);
//        self.localDataBase = [FMDatabase databaseWithPath:self.localStr];
//
//        [self createLocalTable];
//        
//        if (self.localStr) {
//            FMDatabase *base = [FMDatabase databaseWithPath:self.localStr];
//            if (!base.open)
//                
//            {
//                NSLog(@"fail to open database");
//            }
//            
//        }
//        
//        [self createLocalTable];
    }
    return self;
}
- (NSString *) dataFilePath//应用程序的沙盒路径
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    return[document stringByAppendingPathComponent:@"THAWallet.sqlite"];
}

- (NSString *) localFilePath//应用程序的沙盒路径//自选表
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    return[document stringByAppendingPathComponent:@"LocalWallet.sqlite"];
}
- (void)createTable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    FMDatabase *db = self.dataBase;
    if(![fileManager fileExistsAtPath:_dataStr]) {
        NSLog(@"还未创建数据库，现在正在创建数据库");
        if([db open]) {
            
            [db executeUpdate:@"create table if not exists THAWallet(walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,MoneyType text)"];
             [db executeUpdate:@"create table if not exists LocalWallet(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"];
            [db close];
        }else{
            NSLog(@"database open error");
        }
    }
    NSLog(@"FMDatabase:---------%@",db);
    
}


@end
