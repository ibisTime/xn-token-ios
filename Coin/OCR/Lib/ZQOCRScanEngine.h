//
//  ZQOCRScanEngine.h
//  LLianFaceu
//
//  Created by jwtong on 2018/10/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQFaceDataDefine.h"

@protocol ZQOcrScanDelegate <NSObject>

/*************For OC****************
 
 *  返回结果回调 For OC
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 
 ***********************************/

- (void)idCardOcrScanFinishedWithResult:(ZQFaceAuthResult)result userInfo:(id)userInfo;

/*************For Swift****************
 
 *  返回结果回调 For Swift
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 
 ***********************************/

- (void)idCardOcrScanFinishedWithResult:(NSInteger)result UserInfo:(id)userInfo;
@end

@interface ZQOCRScanEngine : NSObject

@property (nonatomic, weak) id<ZQOcrScanDelegate> delegate;

/**
 * 商户认证appKey，必传
 **/
@property (strong, nonatomic) NSString * appKey;
/**
 * 商户认证secretKey，必传
 **/
@property (strong, nonatomic) NSString * secretKey;


/**
 *  身份证检测初始化接口
 *
 *  @param aViewController 当前viewcontroller
 */
- (void)startOcrScanIdCardInViewController:(UIViewController*)aViewController;


@end
