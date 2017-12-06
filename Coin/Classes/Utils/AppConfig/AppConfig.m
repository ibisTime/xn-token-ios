//
//  AppConfig.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppConfig.h"

void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {
    
    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
    self.companyCode = @"CD-COIN000017";
    self.systemCode = @"CD-COIN000017";
    
    switch (_runEnv) {
            
        case RunEnvRelease: {
            
            self.qiniuDomain = @"http://ozfszueqz.bkt.clouddn.com";
            self.addr = @"http://47.52.77.214:4001";

        }break;
            
        case RunEnvDev: {
            //apidev.bcoin.im:4001
            self.qiniuDomain = @"http://ozfszueqz.bkt.clouddn.com";
            self.addr = @"http://121.43.101.148:4001";
            
        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://ozfszueqz.bkt.clouddn.com";
            self.addr = @"http://47.96.161.183:4001";

        }break;
            
    }
    
}

- (NSString *)getUrl {

    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

- (NSString *)wxKey {
    
    return @"wx8cb7c18fa507f630";
}

@end
