//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef MyDemo_MyUIDefine_h
#define MyDemo_MyUIDefine_h


#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, MyUITag){
    MyTagSwitchNotice = 1001,     //设置-通知开关
    MyTagSwitchSound,
    MyTagSwitchShake,
    MyTagSwitchEnvironment,
    MyTagSwitchConsoleLog,
    MyTagChatToolbarKeyboard,
    MyTagChatToolbarVoice,
    MyTagChatToolbarEmoj,
    MyTagChatToolbarMore,
    MyTagChatToolbarSend,
    MyTagChatToolbarMorePhoto,
    MyTagChatToolbarMoreCamera,
    MyTagChatToolbarMoreFile,
    MyTagChatToolbarMoreVideo,
};

#define CONTACT_CELL_H 51
#define CELL_IMG_SIZE_W 40
#define CELL_IMG_SIZE_H 40


#ifdef __cplusplus
extern "C" {
#endif
    CGFloat getScreenWidth();
    
    CGFloat getScreenHeight();
    
    // 获取状态栏竖边高度
    CGFloat getStatusBarHeight();
    
    void setStatusBarHeight(CGFloat newH);
#ifdef __cplusplus
}
#endif

#define SCREEN_WIDTH            getScreenWidth()
#define SCREEN_HEIGHT           getScreenHeight()
#define SCREEN_WIDTH_2          (SCREEN_WIDTH / 2)
#define SCREEN_HEIGHT_2         (SCREEN_HEIGHT / 2)

// 这是竖屏的
//#define APPLICATION_WIDTH       ([UIScreen mainScreen].applicationFrame.size.width)
//#define APPLICATION_HEIGHT      ([UIScreen mainScreen].applicationFrame.size.height)

#define STATUSBAR_HEIGHT        getStatusBarHeight()
#define APPLICATION_WIDTH       (SCREEN_WIDTH)
#define APPLICATION_HEIGHT      (SCREEN_HEIGHT - STATUSBAR_HEIGHT)

#define IS_IPHONE5   (SCREEN_HEIGHT > 480 ? TRUE:FALSE)


// 判断是否高清屏
#define isRetina ([UIScreen instancesRespondToSelector:@selector(scale)] ? (2 == [[UIScreen mainScreen] scale]) : NO)

//view排版Y起始值
#define VIEWLAYOUT_START_Y (20)

//大按钮左右留空值
#define BIGBUTTON_START_X (16)

//昵称最大长度
#define NICK_MAX_WIDTH (200)

// APP 主色调
//#define APP_MAIN_COLOR RGBACOLOR(0x8D, 0xEE, 0xEE, 0)
#define APP_MAIN_COLOR RGBACOLOR(0x0, 0xEE, 0xEE, 0)

// 搜索框激活时背景色
#define SEARCH_ACTIVE_BG_COLOR RGBACOLOR(201, 201, 206, 1)
#define TABLEVIEW_GROUP_BG_COLOR RGBACOLOR(240, 239, 246, 1)

// CHAT TOOLBAR的线条颜色
#define CHAR_BAR_LINE_COLOR RGBACOLOR(201, 201, 206, 1)


#define ADDRESS_BOOK_ROW_HEIGHT 48

#define CONTACT_CELL_H 51
#define CELL_IMG_SIZE_W 40
#define CELL_IMG_SIZE_H 40


#define CELL_LABEL_MAX_W  180           //聊天内容labble的大宽度

//
//#define CELL_CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:17.f]
#define CELL_CONTENT_FONT_SIZE [UIFont systemFontOfSize:16.f]

//bubble想关间距
#define CELL_BUBBLE_ARROW_W    11       //bubble箭头的宽度
#define CELL_BUBBLE_TOP_MARGIN 10       //bubble内部内容与bubble边界的上边距
#define CELL_BUBBLE_BOTTOM_MARGIN 20    //bubble内部内容与bubble边界的下边距
#define CELL_BUBBLE_SIDE_MARGIN 11      //bubble内部内容与bubble左右两侧的间距
#define CELL_BUBBLE_HEAD_PADDING 10     //bubble与头像的间距
#define CELL_BUBBLE_SIDE_PADDING_FIX 2  //bubble内部label位置有偏移(视觉上离bubble的尾部更近)，人工修正的像素
#define CELL_BUBBLE_INDICAGOR_PADDING 5     //bubble与失败标识之间的间距
#define CELL_INDICAGOR_IMAG_H 20     //bubble与失败标识之间的间距


//
#define CELL_CONTENT_MIN_H (CELL_IMG_SIZE_H-CELL_BUBBLE_TOP_MARGIN-CELL_BUBBLE_TOP_MARGIN)  //bubble包含的内容的最小高度
#define CELL_NICK_H 14                  //昵称label的高度
#define CELL_FONT_SIZE 13                  //昵称label的高度
#define CELL_NICK_PADDING 5             //昵称与bubble的间距

//cell内容与cell边缘的间距
#define CELL_TOP_PADDING 12
#define CELL_BUTTOM_PADDING 10
#define CELL_SIDE_PADDING 10

#define CELL_IN_BUBBLE_LEFT (CELL_TOP_PADDING+CELL_IMG_SIZE_W+CELL_BUBBLE_HEAD_PADDING)     //接收消息的bubble在contentView中的左侧间距
#define CELL_OUT_BUBBLE_RIGHT (CELL_TOP_PADDING+CELL_IMG_SIZE_W+CELL_BUBBLE_HEAD_PADDING)   //接收消息的bubble在contentView中的离右侧的间距


#define CELL_TIME_CONTENT_H     12             //展示时间的cell的高度
#define CELL_TIME_CONTENT_W     125             //展示时间的cell的宽度
#define CELL_TIME_BOTTOM_PADDING 5             //展示时间的cell的上边距
#define CELL_TIME_TOP_PADDING 5                 //展示时间的cell的下边距


#define CELL_TIPS_CONTENT_W      200             //展示tips的cell的宽度
#define CELL_TIPS_BOTTOM_PADDING 5             //展示tips的cell的上边距
#define CELL_TIPS_TOP_PADDING    5                 //展示tips的cell的下边距


#define CELL_AUDIO_IMG_H     20              //展示声音的cell的图片高度
#define CELL_AUDIO_IMG_BUBBLE_PADDING     15              //展示声音的cell的图片与bubble间距
#define CELL_AUDIO_MAX_W     120             //展示声音的cell的最大宽度
#define CELL_AUDIO_MIN_W     40             //展示声音的cell的最小宽度
#define CELL_AUDIO_LABLE_PADDING   6        //audio cell与label之间的距离
#define CELL_AUDIO_LABLE_W   20        //audio cell与label之间的距离

#define CELL_PIC_THUMB_MAX_H 190.f            //聊天图片缩约图最大高度
#define CELL_PIC_THUMB_MAX_W 66.f            //聊天图片缩约图最大宽度


#define CELL_FILE_IMAGE_H 60.f                  //文件名的label的高度
#define CELL_FILE_LABEL_H 14.f                  //文件名的label的高度
#define CELL_FILE_BUNBLE_LABLE_PADDING 5.f      //文件名label与bunble的间距
#define CELL_FILE_BUNBLE_IMAG_PADDING 5.f      //文件图标与bunble的间距
#define CELL_FILE_LABLE_MAX_W  100.f       //文件名label的最大宽度 


//chat toolbar
#define CHAT_BAR_MIN_H 36
#define CHAT_BAR_MAX_H 72
#define CHAT_BAR_HORIZONTAL_PADDING 8
#define CHAT_BAR_VECTICAL_PADDING 5
#define CHAT_MORE_BTN_SIZE 50
#define CHAT_MORE_LABLE_PADDING 3
#define CHAT_MORE_LABLE_HEIGHT 14
#define CHAT_MORE_BTN_VECTICAL_PADDING 10

#define CHAT_EMOJ_COL 7     //emoj键盘的列数
#define CHAT_EMOJ_ROW 4
#define CHAT_EMOJ_SIZE 28   //emoj图像的大小
#define CHAT_EMOJ_VECTICAL_PADDING 9  //btn距离上下缘的距离
#define CHAT_MORE_VIEW_H    80
#define CHAT_EMOJ_VIEW_H    216
#define CHAT_RECORD_VIEW_H    216
#define CHAT_EMOJ_VIEW_PAGE_CNTL_H   18

/**Group*/
#define GROUP_INFO_MEMBER_IMG_H 60.f
#define GROUP_INFO_MEMBER_ROLE_H 45.f
#define GROUP_INFO_MEMBER_NAME_H 12.f
#define GROUP_INFO_MEMBER_NAME_IMAG_PADDING 1.f
#define GROUP_INFO_ITEM_PADDING 10.f
#define GROUP_INFO_ITEM_COUNT_PER_LINE 4


#define EMOJI_FONT [UIFont fontWithName:@"AppleColorEmoji" size:CHAT_EMOJ_SIZE]


#endif
