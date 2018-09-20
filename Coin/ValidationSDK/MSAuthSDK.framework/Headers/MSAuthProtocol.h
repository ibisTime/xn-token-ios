//
//  MSAuthProtocol.h
//  MSAuthSDK
//
//  Created by Jeff Wang on 16/4/6.
//  Copyright © 2016年 Jeff Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSAuthDefines.h"

@protocol MSAuthProtocol <NSObject>

/**
 *  校验结果的回调
 *
 *  @param error     错误信息
 *  @param sessionId sessionId
 */
- (void)verifyDidFinishedWithResult:(t_verify_reuslt)code Error:(NSError *)error SessionId:(NSString *)sessionId;

@end
