//
//  NoticeTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "CLSafeMutableArray.h"

@interface NoticeTableView : TLTableView

@property (nonatomic, weak) CLSafeMutableArray *conversationList;

@end
