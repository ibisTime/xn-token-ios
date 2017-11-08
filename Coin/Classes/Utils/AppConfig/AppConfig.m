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
        //配置参数
        [config configKey];
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
    self.companyCode = @"CD-WTW000016";
    self.systemCode = @"CD-WTW000016";
    
    switch (_runEnv) {
            
        case RunEnvRelease: {
            
            self.qiniuDomain = @"http://ounm8iw2d.bkt.clouddn.com";
            self.addr = @"http://121.40.113.128:5301";
            self.shareBaseUrl = @"http://cm.tour.hichengdai.com/?#/home/recommend?userReferee=";

        }break;
            
        case RunEnvDev: {
            
            self.qiniuDomain = @"http://ounm8iw2d.bkt.clouddn.com";
            self.addr = @"http://121.43.101.148:3901";
            self.shareBaseUrl = @"http://cm.tour.hichengdai.com/?#/home/recommend?userReferee=";

        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://ounm8iw2d.bkt.clouddn.com";
            self.addr = @"http://118.178.124.16:3901";
            self.shareBaseUrl = @"http://cm.tour.hichengdai.com/?#/home/recommend?userReferee=";

        }break;
            
    }
    
}

- (void)configKey {
    
    self.chatAppId = @"1400001533";
    self.chatAccountType = @"792";
//    self.pushKey = @"99ffbfdafbd8e791f3daa28a";
//    self.aliMapKey = @"2c7fa174818670dd2eca0861d453a727";
//    self.wxKey = @"wx9324d86fb16e8af0";
}

- (NSString *)getUrl {

    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

@end
