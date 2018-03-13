//
//  MsgSendingTip.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/10.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MsgSendingTip.h"

@implementation MsgSendingTip

- (void)addOwnViews
{
    _sendFailed = [[UIImageView alloc] init];
    _sendFailed.image = [UIImage imageNamed:@"sending_failed"];
    _sendFailed.hidden = YES;
    [self addSubview:_sendFailed];
    
    _sendIng = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_sendIng];
    _sendIng.hidden = YES;
}

- (void)setMsgStatus:(NSInteger)status
{
    switch (status)
    {
        case EIMAMsg_Init:
        {
            // TODO:
        }
            break;
        case EIMAMsg_WillSending:
        {
            // TODO:
        }
            break;
        case EIMAMsg_Sending:
        {
            _sendIng.hidden = NO;
            _sendFailed.hidden = YES;
            [_sendIng startAnimating];
        }
            break;
        case EIMAMsg_SendSucc:
        {
            [_sendIng stopAnimating];
            _sendIng.hidden = YES;
            _sendFailed.hidden = YES;
        }
            break;
        case EIMAMsg_SendFail:
        {
            [_sendIng stopAnimating];
            _sendIng.hidden = YES;
            _sendFailed.hidden = NO;
        }
            break;
//        case EIMAMsg_Deleted:
//        {
//            _sendFailed.hidden = YES;
//            _sendFailed.hidden = YES;
//        }
//            
//            break;
        default:
            break;
    }
}

- (void)relayoutFrameOfSubViews
{
    [_sendFailed sizeWith:CGSizeMake(20, 20)];
    [_sendFailed alignParentCenter];
    
    [_sendIng sameWith:_sendFailed];
}

@end
