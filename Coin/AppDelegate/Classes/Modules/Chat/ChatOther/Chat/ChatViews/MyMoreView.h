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

@protocol MyMoreViewDelegate <NSObject>

- (void)moreViewPhotoAction;
- (void)moreViewCameraAction;
- (void)moreViewFileAction;
- (void)moreVideVideoAction;

@end

@interface MyMoreView : UIView{
}

@property (nonatomic, weak)id<MyMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UILabel  *cameraLable;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UILabel  *photoLable;
@property (nonatomic, strong) UIButton *fileBtn;
@property (nonatomic, strong) UILabel  *fileLable;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UILabel  *videoLable;
@property (nonatomic, strong) UIView *borderView;

- (instancetype)initWithFrame:(CGRect)frame type:(TIMConversationType)type;

@end

