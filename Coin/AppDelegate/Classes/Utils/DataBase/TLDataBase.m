//
//  TLDataBase.m
//  Coin
//
//  Created by shaojianfei on 2018/6/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLDataBase.h"
//#import "FMDBMigrationManager.h"
#import "AppColorMacro.h"
#import "TLUser.h"
#import "FMDBMigrationManager.h"
#import "Migration.h"
#import "CoinModel.h"
@implementation TLDataBase
// 数据库名称

-(NSMutableArray<DataBaseModel *> *)dataBaseModels
{
    if (!_dataBaseModels) {
        _dataBaseModels = [NSMutableArray array];
    }
    
    return _dataBaseModels;
}
-(NSMutableArray<CoinModel *> *)coinModels
{
    
    if (!_coinModels) {
        _coinModels = [NSMutableArray array];
    }
    
    return _coinModels;
}

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
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KIS160];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
        
        [self creatPrivateMsg];
//        if([db open]) {
//
//            [db executeUpdate:@"create table if not exists THAWallet(walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text)"];
//             [db executeUpdate:@"create table if not exists LocalWallet(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"];
//            [db close];
//        }else{
//            NSLog(@"database open error");
//        }
    }else{
        // 如果数据库存在，弃用原来的，创建新库，并迁移数据
      BOOL HasChecked =  [[NSUserDefaults standardUserDefaults] boolForKey:KIS160];
        
        if (HasChecked == YES) {
            return;
        }
        [self updatePrivateMsg];

        /*
         create table if not exists THAUser(walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text)
         */
        
        
        self.dataBaseModels = [NSMutableArray array];
        if ([self.dataBase open]) {
            DataBaseModel *dbModel = [DataBaseModel new];
            NSString *sql = [NSString stringWithFormat:@"SELECT * from THAWallet"];
            //        [sql appendString:[TLUser user].userId];
            /*walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text*/
            FMResultSet *set = [self.dataBase executeQuery:sql];
            while ([set next])
            {
                dbModel.walletId = [set intForColumn:@"walletId"];
                dbModel.userId = [set stringForColumn:@"userId"];
                dbModel.Mnemonics = [set stringForColumn:@"Mnemonics"];
                dbModel.wanaddress = [set stringForColumn:@"wanaddress"];
                dbModel.wanprivate = [set stringForColumn:@"wanprivate"];
                dbModel.ethaddress = [set stringForColumn:@"ethaddress"];
                dbModel.ethprivate = [set stringForColumn:@"ethprivate"];
                dbModel.btcaddress = [set stringForColumn:@"btcaddress"];
                dbModel.btcprivate = [set stringForColumn:@"btcprivate"];
                dbModel.PwdKey = [set stringForColumn:@"PwdKey"];
//                dbModel.name = [set stringForColumn:@"name"];
                [self.dataBaseModels addObject:dbModel];
            }
            [set close];
        }
        [self.dataBase close];
        NSLog(@"%@",self.dataBaseModels);
        
        for (int i = 0; i < self.dataBaseModels.count; i++) {
            DataBaseModel *model = self.dataBaseModels[i];
            
            if ([self.dataBase open]) {
                BOOL sucess = [self.dataBase executeUpdate:@"insert into THAUser(userId,Mnemonics,wanAddress,wanPrivate,ethPrivate,ethAddress,PwdKey) values(?,?,?,?,?,?,?)",model.userId,model.Mnemonics,model.wanaddress,model.wanprivate,model.ethprivate,model.ethaddress,model.PwdKey];
               
                NSLog(@"钱包表迁移%d",sucess);
            }
            [self.dataBase close];
        }
        
        
        self.coinModels = [NSMutableArray array];
        
        if ([self.dataBase open]) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * from LocalWallet"];
            //        [sql appendString:[TLUser user].userId];
            /*(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)*/
            FMResultSet *set = [self.dataBase executeQuery:sql];
            while ([set next])
            {
                CoinModel *coinModel = [CoinModel new];

                coinModel.id = [set stringForColumn:@"id"];
                coinModel.walletId = [set stringForColumn:@"walletId"];
                coinModel.symbol = [set stringForColumn:@"symbol"];
                coinModel.type = [set stringForColumn:@"type"];
                coinModel.status = [set stringForColumn:@"status"];
                coinModel.cname = [set stringForColumn:@"cname"];
                coinModel.unit = [set stringForColumn:@"unit"];
                coinModel.pic1 = [set stringForColumn:@"pic1"];
                coinModel.withdrawFeeString = [set stringForColumn:@"withdrawFeeString"];
                coinModel.withfrawFee = [set stringForColumn:@"withfrawFee"];
                coinModel.orderNo = [set stringForColumn:@"orderNo"];
                coinModel.ename = [set stringForColumn:@"ename"];
                coinModel.icon = [set stringForColumn:@"icon"];
                coinModel.pic2 = [set stringForColumn:@"pic2"];
                coinModel.pic3 = [set stringForColumn:@"pic3"];
                coinModel.address = [set stringForColumn:@"address"];
                coinModel.IsSelect = [set boolForColumn:@"IsSelect"];
                //                coinModel.next = [set intForColumn:@"next"];
                
                [self.coinModels addObject:coinModel];
            }
            [set close];
        }
        [self.dataBase close];
        
        NSLog(@"%@",self.coinModels);
        
        //        }
        
        
        for (int i = 0; i < self.coinModels.count; i++) {
            CoinModel *model = self.coinModels[i];
            
            if ([self.dataBase open]) {
                BOOL sucess = [self.dataBase executeUpdate:@"INSERT INTO  THALocal(walletId,symbol,type,status,cname,unit,pic1,withdrawFeeString,withfrawFee,orderNo,ename,icon,pic2,pic3,address,IsSelect,next) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.walletId,model.symbol,model.type,model.status,model.cname,model.unit,model.pic1,model.withdrawFeeString,model.withfrawFee,model.orderNo,model.ename,model.icon,model.pic2,model.pic3,model.address,[NSNumber numberWithBool:YES],[NSString stringWithFormat:@"%ld",self.coinModels.count]];
                
                NSLog(@"币种表迁移%d",sucess);
                
            }
            [self.dataBase close];
        }
        
        
//        NSString *sql = [NSString stringWithFormat:@"Insert into THAUser (userId,Mnemonics,wanaddress,wanprivate,ethaddress,ethprivate,btcaddress,btcprivate,PwdKey) SELECT (userId,Mnemonics,wanaddress,wanprivate,ethaddress,ethprivate,btcaddress,btcprivate,PwdKey) from THAWallet "];
//
//        if ([self.dataBase open]) {
//            BOOL sucess = [self.dataBase executeUpdate:sql];
//
//            NSLog(@"数据迁移%d",sucess);
//        }
//
//
//
//        return;
//        TLDataBase *dataBase = [TLDataBase sharedManager];
    
        
            //1.6.0之前数据库 需要更新
        
            //取出之前旧版本数据库里面的数据
        
        
        
        
        
    }
    NSLog(@"FMDatabase:---------%@",db);
    
    
    self.dataBaseModels = [NSMutableArray array];
    if ([self.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from THAUser"];
        //        [sql appendString:[TLUser user].userId];
        /*walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text*/
        FMResultSet *set = [self.dataBase executeQuery:sql];
        while ([set next])
        {
            DataBaseModel *dbModel = [DataBaseModel new];

            dbModel.walletId = [set intForColumn:@"walletId"];
            dbModel.userId = [set stringForColumn:@"userId"];
            dbModel.Mnemonics = [set stringForColumn:@"Mnemonics"];
            dbModel.wanaddress = [set stringForColumn:@"wanaddress"];
            dbModel.wanprivate = [set stringForColumn:@"wanprivate"];
            dbModel.ethaddress = [set stringForColumn:@"ethaddress"];
            dbModel.ethprivate = [set stringForColumn:@"ethprivate"];
            dbModel.btcaddress = [set stringForColumn:@"btcaddress"];
            dbModel.btcprivate = [set stringForColumn:@"btcprivate"];
            dbModel.PwdKey = [set stringForColumn:@"PwdKey"];
            //                dbModel.name = [set stringForColumn:@"name"];
            [self.dataBaseModels addObject:dbModel];
        }
        [set close];
    }
    [self.dataBase close];
    NSLog(@"%@",self.dataBaseModels);
    
    
}
- (void)creatPrivateMsg{
    
    FMDBMigrationManager * manager=[FMDBMigrationManager managerWithDatabaseAtPath:self.dataStr migrationsBundle:[NSBundle mainBundle]];
    
    Migration * migration_1=[[Migration alloc]initWithName:@"新增THAUser表" andVersion:1 andExecuteUpdateArray:@[@"create table if not exists THAUser(walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text)",@"create table if not exists THALocal(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"]];
    
//    Migration * migration_2=[[Migration alloc]initWithName:@"新增THALocal表" andVersion:1 andExecuteUpdateArray:@[]];
    
//    Migration * migration_3=[[Migration alloc]initWithName:@"THAUser表新增字段name" andVersion:1 andExecuteUpdateArray:@[@"alter table THAUser add name text"]];//给User表添加email字段
    
    
    
    [manager addMigration:migration_1];

//    [manager addMigration:migration_2];
//    [manager addMigration:migration_3];

    
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    
}

- (void)updatePrivateMsg{
    
    FMDBMigrationManager * manager=[FMDBMigrationManager managerWithDatabaseAtPath:self.dataStr migrationsBundle:[NSBundle mainBundle]];
    
    Migration * migration_1=[[Migration alloc]initWithName:@"新增THAUser表" andVersion:1 andExecuteUpdateArray:@[@"create table if not exists THAUser(walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text)",@"create table if not exists THALocal(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"]];
    
    
    [manager addMigration:migration_1];

    
    
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    
}


@end
