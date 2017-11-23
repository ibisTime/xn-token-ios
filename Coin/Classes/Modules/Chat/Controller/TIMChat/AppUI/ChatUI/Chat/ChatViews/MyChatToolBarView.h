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

#import <UIKit/UIKit.h>
#import "MyEmojView.h"
#import "MyAudioInputView.h"

@class MyMoreView;
@class MyEmojView;
@class MyAudioInputView;

@protocol MyChatToolBarViewDelegate <NSObject>

- (void)sendText:(NSString *)text;
- (void)didChangeToolBarHight:(CGFloat)toHeight;
- (void)sendAudioRecord:(AudioRecord *)audio;

@end

@interface MyChatToolBarView : UIView<UITextViewDelegate, MyEmojBoardDelegate, MyAudioInputDeletage>

@property (nonatomic, weak) id<MyChatToolBarViewDelegate> delegate;
@property (nonatomic, strong)UIButton* audioBtn;
@property (nonatomic, strong)UIButton* emojBtn;
@property (nonatomic, strong)UIButton* moreBtn;
//@property (nonatomic, strong)UIButton* sendBtn;
@property (nonatomic, strong)UITextView* textInputView;
@property (nonatomic, strong) UIView* toolBarView;
@property (nonatomic, strong) UIView* buttomView;
@property (nonatomic, strong) MyEmojView* emojView;
@property (nonatomic, strong) MyMoreView* moreView;
@property (nonatomic, strong) MyAudioInputView* recordView;


- (void)updateEmoj;
- (instancetype)initWithFrame:(CGRect)frame chatType:(TIMConversationType)type;

@end
