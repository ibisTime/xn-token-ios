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

@protocol MyPttRecordBtnDelegate <NSObject>

-(void)onPttRecordBtnDown;
-(void)onPttrecordBtnUp;
-(void)onPttRecordBtnMoveIn;
-(void)onPttRecordBtnmoveOut;

@end

@protocol MyPttTouchDelegate <NSObject>

@optional
- (void)touchBegin:(NSSet*)touches;

- (void)touchMove:(NSSet*)touches;

- (void)touchCancel:(NSSet*)touches;

- (void)touchEnd:(NSSet*)touches;

@end


@interface MyPttRecordBtn : UIButton

@property (nonatomic, unsafe_unretained) id<MyPttTouchDelegate>  touchDelegate;
-(void)setDelegate:(id<MyPttRecordBtnDelegate>)delegate;

@end
