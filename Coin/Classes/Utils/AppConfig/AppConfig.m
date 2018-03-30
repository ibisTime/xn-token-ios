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
        config.isUploadCheck = NO;
        
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
    self.companyCode = @"CD-TOKEN00018";
    self.systemCode = @"CD-TOKEN00018";
    
    switch (_runEnv) {
            
        case RunEnvRelease: {
            
            self.qiniuDomain = @"http://p5k7690z2.bkt.clouddn.com";
            self.addr = @"http://139.196.162.23:2101";

        }break;
            
        case RunEnvDev: {
            self.qiniuDomain = @"http://p5k7690z2.bkt.clouddn.com";
            self.addr = @"http://120.26.6.213:2101";

        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://p5k7690z2.bkt.clouddn.com";
            self.addr = @"http://47.96.161.183:2101";

        } break;
            
    }
    
}

- (NSString *)apiUrl {
    
    if ([self.addr hasSuffix:@"api"]) {
        
        return self.addr;
        
    }
    
    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

//- (NSString *)ipUrl {
//
//    return [self.addr stringByAppendingString:@"/forward-service/ip"];
//
//}

- (NSString *)getUrl {

    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

- (NSString *)wxKey {
    
    return @"wx8cb7c18fa507f630";
}

@end
