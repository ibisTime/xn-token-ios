//
//  ConversationListTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ConversationListTableViewCell.h"

#import "NSString+Extension.h"
#import "TLUser.h"

@implementation ConversationListTableViewCell


- (void)dealloc
{
    [self.KVOController unobserveAll];
//    self.KVOController = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addOwnViews];
        [self configOwnViews];
        
        self.KVOController = [FBKVOController controllerWithObserver:self];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)addOwnViews
{
    _conversationIcon = [[UIButton alloc] init];
    _conversationIcon.backgroundColor = kGrayColor;
    _conversationIcon.layer.cornerRadius = 25;
    _conversationIcon.layer.masksToBounds = YES;
    [self.contentView addSubview:_conversationIcon];
    
    _conversationName = [[UILabel alloc] init];
    _conversationName.font = Font(17.0);
    _conversationName.textColor = kTextColor;
    [self.contentView addSubview:_conversationName];
    
    _lastMsgTime = [[UILabel alloc] init];
    _lastMsgTime.font = kAppSmallTextFont;
    _lastMsgTime.textAlignment = NSTextAlignmentRight;
    _lastMsgTime.textColor = kTextColor2;
    _lastMsgTime.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_lastMsgTime];
    
    _lastMsg = [[UILabel alloc] init];
    _lastMsg.font = Font(14.0);
    _lastMsg.textColor = kTextColor2;
    [self.contentView addSubview:_lastMsg];
    
    ImageTitleButton *btn = [[ImageTitleButton alloc] init];
    btn.imageSize = CGSizeZero;
    btn.margin = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.padding = CGSizeZero;
    _unReadBadge = btn;
    _unReadBadge.backgroundColor = kRedColor;
    _unReadBadge.layer.cornerRadius = 10;
    _unReadBadge.layer.masksToBounds = YES;
    _unReadBadge.titleLabel.font = kAppSmallTextFont;
    _unReadBadge.titleLabel.textAlignment = NSTextAlignmentCenter;
    _unReadBadge.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_unReadBadge setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_unReadBadge addTarget:self action:@selector(onClickUnRead:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_unReadBadge];
}

- (void)onClickUnRead:(UIButton *)button
{
    IMAConversation *conv = (IMAConversation *)_showItem;
    [conv setReadAllMsg];
    
    NSInteger unReadCount = 0;
    [_unReadBadge setTitle:[NSString stringWithFormat:@"%ld", (long)unReadCount] forState:UIControlStateNormal];
    [_unReadBadge fadeOut:0.25 delegate:nil];
}

- (void)configOwnViews
{
    [_conversationIcon sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:kRandomFlatColor]];
    
//    _conversationName.text = @"测试";
//
//    _lastMsgTime.text = @"测试19:10";
//
//    _lastMsg.text = @"这是一个测试消息";
//
    
    NSInteger unReadCount = 99;
    _unReadBadge.hidden = unReadCount == 0;
    
    [_unReadBadge setTitle:unReadCount > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", (long)unReadCount] forState:UIControlStateNormal];
}

- (void)configCellWith:(id<IMAConversationShowAble>)item
{
    _showItem = item;
    
    [self.KVOController unobserveAll];
    
    __weak ConversationListTableViewCell *ws = self;
    [self.KVOController observe:item keyPath:@"lastMessage" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws updateCellOnNewMessage];
    }];
    [self.KVOController observe:item keyPath:@"lastMessage.status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws updateCellOnNewMessage];
    }];
    
    [self.KVOController observe:item keyPath:@"draft" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change){
        [ws updateCellOnNewMessage];
    }];
    
    [self updateCellOnNewMessage];
}

- (void)refreshCell
{
    [self updateCellOnNewMessage];
}

- (void)updateCellOnNewMessage
{
    
    //获取好友资料
    [[TIMFriendshipManager sharedInstance] getUsersProfile:@[[_showItem showTitle]] succ:^(NSArray *friends) {
        
        if (friends.count > 0) {
            
            TIMUserProfile *user = friends[0];

            self.iconUrl = user.faceURL;
            
            self.nickName = user.nickname;
            
            [_conversationIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:[user.faceURL convertImageUrl]] forState:UIControlStateNormal placeholderImage:[_showItem defaultShowImage]];

            _conversationName.text = user.nickname;

        }
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
    _lastMsgTime.text = [_showItem lastMsgTime];
    
#if kTestChatAttachment

    NSAttributedString *attributeDraft = [_showItem attributedDraft];
    _lastMsg.attributedText = attributeDraft.length ? attributeDraft : [_showItem lastAttributedMsg];

#else
    NSString *draft = [_showItem attributedDraft];
    _lastMsg.text = draft.length ? draft : [_showItem lastMsg];
#endif
    
    NSInteger unReadCount = [_showItem unReadCount];
    _unReadBadge.hidden = unReadCount == 0;
    [_unReadBadge setTitle:unReadCount > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", (long)unReadCount] forState:UIControlStateNormal];
    
    //消息栏消息数
    NSInteger unReadNum = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];

    [TLUser user].unReadMsgCount = unReadNum;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    [_conversationIcon sizeWith:CGSizeMake(50, 50)];
    [_conversationIcon layoutParentVerticalCenter];
    [_conversationIcon alignParentLeftWithMargin:kLeftMargin];
    
    [_lastMsgTime sizeWith:CGSizeMake(60, 28)];
    [_lastMsgTime alignParentRightWithMargin:kLeftMargin];
    [_lastMsgTime alignTop:_conversationIcon];
    
    [_conversationName sameWith:_lastMsgTime];
    [_conversationName layoutToRightOf:_conversationIcon margin:10];
    [_conversationName scaleToLeftOf:_lastMsgTime margin:kDefaultMargin];
    
    [_lastMsg sameWith:_conversationName];
    [_lastMsg layoutBelow:_conversationName];
    [_lastMsg scaleToBelowOf:_conversationIcon];
    
//    CGSize size = [_unReadBadge.titleLabel textSizeIn:_lastMsgTime.bounds.size];
//    if (size.width <= 16)
//    {
//        size.width = 16;
//    }

    [_unReadBadge sizeWith:CGSizeMake(20, 20)];
    
    [_unReadBadge alignRight:_lastMsgTime];
    [_unReadBadge alignVerticalCenterOf:_lastMsg];
}


@end
