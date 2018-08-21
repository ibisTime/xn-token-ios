//
//  HttpRequestService.h
//  AFNetworkingTool
//
//  Created by 蔡卓越 on 15/9/25.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestObject.h"


@interface HttpRequestService : NSObject


+ (void)asynRequest:(HttpRequestObject *)requestObj success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure;

+ (void)uploadRequest:(HttpRequestObject *)requestObj fileData:(NSData *)data success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure;

+ (void)cancleRequest:(HttpRequestObject *)requestObj;


@end
