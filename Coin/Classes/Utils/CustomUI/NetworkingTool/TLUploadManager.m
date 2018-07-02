//
//  TLUploadManager.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/16.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLUploadManager.h"
#import "TLNetworking.h"
#import "TLUser.h"
#import "TLAlert.h"
#import "APICodeMacro.h"
@interface TLUploadManager()


@property (nonatomic,strong) QNUploadManager *qnUploadManager;


@end

@implementation TLUploadManager

- (QNUploadManager *)qnUploadManager {

    if (!_qnUploadManager) {
        
        _qnUploadManager = [[QNUploadManager alloc] init];
    }
    
    return _qnUploadManager;

}

+ (instancetype)manager {

    static TLUploadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TLUploadManager alloc] init];
    });

    return manager;
}

- (void)images:(NSArray *)images {

    

}

- (void)uploadImage:(UIImage *)image success:(void(^)(void))success failure:(void(^)())failure{

    TLNetworking *getUploadToken = [TLNetworking new];
    getUploadToken.code = IMG_UPLOAD_CODE;
    getUploadToken.parameters[@"token"] = [TLUser user].token;
    [getUploadToken postWithSuccess:^(id responseObject) {
     //获取token
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSString *imageName = [[self class] imageNameByImage:image];
        [self.qnUploadManager putData:data key:imageName token:@"" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (1) {
                
                
                
            } else {
            
                if (failure) {
                    failure();
                }
            
            }
            
        } option:nil];
        
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
}

- (void)getTokenShowView:(UIView *)showView succes:(void(^)(NSString * token))success
                 failure:(void(^)(NSError *error))failure
{

    TLNetworking *getUploadToken = [TLNetworking new];
    
    getUploadToken.showView = showView;
    getUploadToken.code = IMG_UPLOAD_CODE;
    getUploadToken.parameters[@"token"] = [TLUser user].token;
    [getUploadToken postWithSuccess:^(id responseObject) {
        
        NSString *token = responseObject[@"data"][@"uploadToken"];
        
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.zone = [QNZone zone0];
        }];
        
        QNUploadManager *manager = [[QNUploadManager alloc] initWithConfiguration:config];
        
        [manager putData:self.imgData key:[TLUploadManager imageNameByImage:self.image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (info.error) {
                
                [TLAlert alertWithError:@"修改头像失败"];
                NSLog(@"info.error = %@", info.error);
                
                return ;
            }
            
            if (success) {
                
                success(key);
            }
            
        } option:nil];
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];


}


+ (NSString *)imageNameByImage:(UIImage *)img{
    CGSize imgSize = img.size;//
    
    NSDate *now = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%f",now.timeIntervalSince1970];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
 
    NSString *imageName = [NSString stringWithFormat:@"IOS_%@_%.0f_%.0f.jpg",timestamp,imgSize.width,imgSize.height];
    
    return imageName;
    
}


@end
