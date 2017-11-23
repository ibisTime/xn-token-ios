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
#import "MyPttRecordBtn.h"
#import "MyVolumeMeter.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioRecord : NSObject

@property (nonatomic, strong)NSData* audioData;
@property (nonatomic, assign)NSUInteger duration;
@property (nonatomic, strong)NSString* filePath;

@end


@protocol MyAudioInputDeletage <NSObject>

@optional
- (void)startRecord;
- (void)cancelRecord;
- (void)sendAudioRecord:(AudioRecord*) audio;

@end


@interface MyAudioInputView : UIView <MyPttTouchDelegate, VolumeMeterDelegate>

@property (nonatomic, weak)id<MyAudioInputDeletage>   delegate;
@property (nonatomic, assign)BOOL recordAuthority;

@end
