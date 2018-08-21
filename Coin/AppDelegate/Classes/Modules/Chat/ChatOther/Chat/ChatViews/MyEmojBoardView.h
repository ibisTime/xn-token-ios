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
//  表情键盘视图

#import <UIKit/UIKit.h>

@class EmojInfo;

@protocol MyEmojBoardDelegate <NSObject>

- (void)emojSelect:(EmojInfo*)info;
- (void)emojDelete;

@end


@interface MyEmojBoardView : UIView
{
@protected
    __weak id<MyEmojBoardDelegate> _delegate;
}

@property (nonatomic, weak)id<MyEmojBoardDelegate> delegate;

+ (MyEmojBoardView *)viewWithPage:(NSInteger)page frame:(CGRect)rect;
+ (NSInteger)viewTagWithPage:(NSInteger)page;

@end
