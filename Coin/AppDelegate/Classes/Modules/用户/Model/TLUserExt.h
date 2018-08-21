//
//  TLUserExt.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/15.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLUserExt : TLBaseModel

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *photo;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;


//--//
@property (nonatomic, copy) NSString *birthday;//生日
@property (nonatomic, copy) NSString *email; //email
@property (nonatomic, copy) NSString *gender; //性别
@property (nonatomic, copy) NSString *introduce; //介绍


//birthday = "2017-05-8";
//email = "200951328@qq.com";
//gender = 1;
//introduce = "\U7b80\U4ecb";
//latitude = "-1";
//loginName = CSW18984955240;
//longitude = "-1";
//mobile = 18984955240;
//photo = "ANDROID_1494244199669_580_580.jpg";
//systemCode = "CD-CCSW000008";
//userId = U2017050514265703135;



@end
