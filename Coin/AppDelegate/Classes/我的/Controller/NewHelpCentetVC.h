//
//  NewHelpCentetVC.h
//  Coin
//
//  Created by shaojianfei on 2018/9/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import <ZendeskProviderSDK/ZendeskProviderSDK.h>
@interface NewHelpCentetVC : TLBaseVC<UINavigationControllerDelegate,ZDKHelpCenterArticleRatingStateProtocol,ZDKHelpCenterConversationsUIDelegate,ZDKHelpCenterDelegate>

@end
