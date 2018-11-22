//
//  ZQFaceDataDefine.h
//  LLianFaceu
//
//  Created by jwtong on 2018/10/18.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZQFaceAuthResult) {
    ZQFaceAuthResult_Done,                //认证完成，商户可根据返回码进行自己的业务逻辑操作
    ZQFaceAuthResult_Error,               //认证异常，如网络异常、鉴权失败等
    ZQFaceAuthResult_Cancel,              //用户取消认证操作
    ZQFaceAuthResult_UserNameError,       //商户传入的姓名不合法
    ZQFaceAuthResult_UserIdNumberError,   //商户传入的身份证号码不合法
    ZQFaceAuthResult_BillNil              //订单为空
};

typedef NS_ENUM(NSUInteger, ZQFaceAuthMode) {
    ZQFaceAuthMode_High,
    ZQFaceAuthMode_Medium,
    ZQFaceAuthMode_Low
};
