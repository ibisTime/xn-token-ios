//
//  TLCoinWithdrawModel.h
//  Coin
//
//  Created by  tianlei on 2018/1/17.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLCoinWithdrawModel : TLBaseModel

@property (nonatomic, copy) NSString *amountString;
@property (nonatomic, copy) NSString *currency; //币种
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *feeString;//手续费
@property (nonatomic, copy) NSString *applyDatetime; //申请时间
@property (nonatomic, copy) NSString *payCardNo; //提币到哪个账户

- (NSString *)statusName;

@end


//channelType = ETH;
//code = QX201802031008541015603;
//companyCode = "CD-COIN000017";
//feeString = 10000000000000000;
//payCardInfo = ETH;
//payCardNo = 0xed73FeF7246F408617aC7b0f4Db0188352Df7818;

//accountName
//:
//"15700092384"
//accountNumber
//:
//"A201801220432517624658"
//amountString
//:
//"1000000000000000000"
//applyDatetime
//:
//"Jan 25, 2018 1:40:36 AM"
//applyNote
//:
//""
//applyUser
//:
//"U201801220432517597250"
//approveDatetime
//:
//"Jan 25, 2018 1:41:08 AM"
//approveNote
//:
//"2"
//approveUser
//:
//"cs001"
//channelType
//:
//"ETH"
//code
//:
//"QX201801250140368335312"
//companyCode
//:
//"CD-COIN000017"
//feeString
//:
//"10000000000000000"
//payCardInfo
//:
//"ETH"
//payCardNo
//:
//"0x39f881b9f6c53369c84ac9954918275c7a873c5f"
//status
//:
//"2"
//systemCode
//:
//"CD-COIN000017"
//type
//:
//"C"

