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

#import "MyMoreView.h"

#import "MyUIDefine.h"

@interface MyMoreView(){
    TIMConversationType _chatType;
}
@end

@implementation MyMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(TIMConversationType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _chatType = type;
    }
    return self;
}


- (UIView *)borderView{
    if (!_borderView) {
        _borderView = [[UIView alloc] initWithFrame:CGRectZero];
        _borderView.backgroundColor = CHAR_BAR_LINE_COLOR;
        _borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_borderView];
    }
    return _borderView;
}

- (UIButton*)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [self createBtn:@"camera" andTag:MyTagChatToolbarMoreCamera];
    }
    return _cameraBtn;
}

- (UIButton*)photoBtn{
    if (!_photoBtn) {
        _photoBtn = [self createBtn:@"photo" andTag:MyTagChatToolbarMorePhoto];
    }
    return _photoBtn;
}

- (UIButton*)fileBtn{
    if (!_fileBtn) {
        _fileBtn = [self createBtn:@"file" andTag:MyTagChatToolbarMoreFile];
    }
    return _fileBtn;
}

- (UIButton*)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [self createBtn:@"video" andTag:MyTagChatToolbarMoreVideo];
    }
    return _videoBtn;
}

- (UILabel*)cameraLable{
    if (!_cameraLable) {
        _cameraLable = [self createLable:@"相机"];
    }
    return _cameraLable;
}

- (UILabel*)photoLable{
    if (!_photoLable) {
        _photoLable = [self createLable:@"照片"];
    }
    return _photoLable;
}

- (UILabel*)fileLable{
    if (!_fileLable) {
        _fileLable = [self createLable:@"文件"];
    }
    return _fileLable;
}

- (UILabel*)videoLable{
    if (!_videoLable) {
        _videoLable = [self createLable:@"视频"];
    }
    return _videoLable;
}

- (UILabel *)createLable:(NSString*)name{
    UILabel* label = [[UILabel alloc] init];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    [self addSubview:label];
    return label;
}

- (UIButton *)createBtn:(NSString*)btnNick andTag:(NSInteger)tag{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    NSString* imageNorName = [NSString stringWithFormat:@"chat_more_icons_%@", btnNick];
//    NSString* imageSelectedName = [NSString stringWithFormat:@"chat_more_icons_%@Selected", btnNick];
    [btn setImage:[UIImage imageNamed:imageNorName] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:imageSelectedName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
    
}


//创建分隔线
- (void) setupBorder{
    UIView* borderView = [[UIView alloc] initWithFrame:CGRectMake(CHAT_BAR_HORIZONTAL_PADDING, CHAT_BAR_VECTICAL_PADDING/2.0, self.frame.size.width-2*CHAT_BAR_HORIZONTAL_PADDING, 0.5)];
    borderView.backgroundColor = CHAR_BAR_LINE_COLOR;
    
    [self addSubview:borderView];
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
//    self.borderView.frame = CGRectMake(CHAT_MORE_BTN_VECTICAL_PADDING, CHAT_BAR_VECTICAL_PADDING/2.0, self.frame.size.width-2*CHAT_BAR_HORIZONTAL_PADDING, 0.5);
    self.borderView.frame = CGRectMake(CHAT_MORE_BTN_VECTICAL_PADDING, 1, self.frame.size.width-2*CHAT_BAR_HORIZONTAL_PADDING, 0.5);
    
    CGFloat inset = (self.frame.size.width - 4 * CHAT_MORE_BTN_SIZE) / 5;
    self.photoBtn.frame = CGRectMake(inset, CHAT_BAR_VECTICAL_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_BTN_SIZE);
    self.photoLable.frame = CGRectMake(inset, CHAT_BAR_VECTICAL_PADDING+CHAT_MORE_BTN_SIZE+CHAT_MORE_LABLE_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_LABLE_HEIGHT);
    self.cameraBtn.frame = CGRectMake(1*(CHAT_MORE_BTN_SIZE+inset)+inset, CHAT_BAR_VECTICAL_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_BTN_SIZE);
    self.cameraLable.frame = CGRectMake(1*(CHAT_MORE_BTN_SIZE+inset)+inset, CHAT_BAR_VECTICAL_PADDING+CHAT_MORE_BTN_SIZE+CHAT_MORE_LABLE_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_LABLE_HEIGHT);
    self.fileBtn.frame = CGRectMake(2*(CHAT_MORE_BTN_SIZE+inset)+inset, CHAT_BAR_VECTICAL_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_BTN_SIZE);
    self.fileLable.frame = CGRectMake(2*(CHAT_MORE_BTN_SIZE+inset)+inset, CHAT_BAR_VECTICAL_PADDING+CHAT_MORE_BTN_SIZE+CHAT_MORE_LABLE_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_LABLE_HEIGHT);
    self.videoBtn.frame = CGRectMake(3*(CHAT_MORE_BTN_SIZE+inset)+inset, CHAT_BAR_VECTICAL_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_BTN_SIZE);
    self.videoLable.frame = CGRectMake(3*(CHAT_MORE_BTN_SIZE+inset)+inset, CHAT_BAR_VECTICAL_PADDING+CHAT_MORE_BTN_SIZE+CHAT_MORE_LABLE_PADDING, CHAT_MORE_BTN_SIZE, CHAT_MORE_LABLE_HEIGHT);
}

#pragma mark - action

- (void)btnAction:(id)sender{
    UIButton* btn = (UIButton *)sender;
    switch (btn.tag) {
        case MyTagChatToolbarMorePhoto:
            if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewPhotoAction)]) {
                [self.delegate moreViewPhotoAction];
            }
            break;
        case MyTagChatToolbarMoreCamera:
            if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewCameraAction)]) {
                [self.delegate moreViewCameraAction];
            }
            break;
        case MyTagChatToolbarMoreFile:
            if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewFileAction)]) {
                [self.delegate moreViewFileAction];
            }
            break;
        case MyTagChatToolbarMoreVideo:
            if (self.delegate && [self.delegate respondsToSelector:@selector(moreVideVideoAction)]) {
                [self.delegate moreVideVideoAction];
            }
            break;
        default:
            break;
    }
    return;
}

@end
