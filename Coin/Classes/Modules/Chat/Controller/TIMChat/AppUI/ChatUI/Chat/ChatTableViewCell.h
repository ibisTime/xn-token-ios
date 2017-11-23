//
//  ChatTextTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/10.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatBaseTableViewCell.h"

#import "MicroVideoPlayView.h"

//==============================================================
@interface ChatTextTableViewCell : ChatBaseTableViewCell
{
@protected
    UILabel     *_chatText;
}

@end
//==============================================================
@interface ChatImageTableViewCell : ChatBaseTableViewCell
{
@protected
    UIImageView     *_chatImage;
}

@end

//==============================================================
@interface ChatSoundTableViewCell : ChatBaseTableViewCell
{
@protected
    ImageTitleButton *_soundButton;
}

@end
//==============================================================
@interface ChatFileTableViewCell : ChatBaseTableViewCell
{
@protected
    UIView          *_filePanel;
    UIImageView     *_fileIcon;
    UILabel         *_fileName;
    UILabel         *_fileSize;
}

@end
//==============================================================
@interface ChatVideoTableViewCell : ChatBaseTableViewCell
{
    MicroVideoPlayView  *_videoPanel;
}

@end
//==============================================================

