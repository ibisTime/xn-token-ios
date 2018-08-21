//
//  MsgSendingTip.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/10.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TIMElemBaseTableViewCell.h"

@interface MsgSendingTip : UIView<TIMElemSendingAbleView>
{
@protected
    UIActivityIndicatorView *_sendIng;
    UIImageView             *_sendFailed;
}

@end
