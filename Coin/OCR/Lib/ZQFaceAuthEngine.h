//
//  ZQFaceAuthEngine.h
//  LLianFaceu
//
//  Created by jwtong on 2018/10/18.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQFaceDataDefine.h"



@protocol ZQFaceAuthDelegate <NSObject>


@optional

/*************For OC****************
 *
 *  返回结果回调 For OC
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 *
 ***********************************/

- (void)faceAuthFinishedWithResult:(ZQFaceAuthResult)result UserInfo:(id)userInfo;


/*************For Swift**************
 *
 *  返回结果回调 For Swift
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 *
 ***********************************/
- (void)faceAuthFinishedWithResult:(NSInteger)result userInfo:(id)userInfo;

@end

@interface ZQFaceAuthEngine : NSObject

@property (weak, nonatomic) id <ZQFaceAuthDelegate> delegate;

/**
 * 商户认证appKey，必传
 **/
@property (strong, nonatomic) NSString * appKey;
/**
 * 商户认证secretKey，必传
 **/
@property (strong, nonatomic) NSString * secretKey;

/**
 * 安全模式，共3个等级，即活体检测的动作要求难度, 默认最高等级
 */
@property (assign, nonatomic) ZQFaceAuthMode safeMode;

/**
 * 活体的语音提示是否关闭，默认为打开，即closeRemindVoice = NO
 **/
@property (nonatomic, assign) BOOL closeRemindVoice;


/**
 *  活体检测初始化接口
 *
 *  @param aViewController 当前viewcontroller
 */
- (void)startFaceAuthInViewController:(UIViewController*)aViewController;



/**
 *  人脸身份认证（无网格照版本）初始化接口
 *
 *  @param aUserName       非必传，用户姓名，必须是中文。若为少数名族姓名，中间需要有间隔圆点
 *  @param aIdentityNumber 非必传，身份证号码
 *  @param aViewController 当前viewcontroller
 */
//- (void)startSingleAuthWithUserName:(NSString*)aUserName IdentityNumber:(NSString *) aIdentityNumber InViewController:(UIViewController*)aViewController;

@end

