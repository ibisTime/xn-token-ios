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

#import "MyPttRecordBtn.h"



@interface MyPttRecordBtn ()
{
    __unsafe_unretained id<MyPttRecordBtnDelegate> _delegate;
    __unsafe_unretained id<MyPttTouchDelegate>  _touchDelegate;
    BOOL _insideBtn;
    BOOL _insideRect;
}
@end

@implementation MyPttRecordBtn
@synthesize touchDelegate = _touchDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
    }
    return self;
}

- (BOOL)judgeInside:(CGPoint)point
{
    if (((point.y >= - 46) && (point.y < 0)) || ((point.y >= 0) && ((point.x >= 0) && (point.x < self.bounds.size.width)) && point.y >= 0)) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _insideRect = YES;
    if ([_delegate respondsToSelector:@selector(onPttRecordBtnDown)])
        [_delegate onPttRecordBtnDown];
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(touchBegin:)]) {
        [_touchDelegate touchBegin:touches];
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch canceled.");
    [super touchesCancelled:touches withEvent:event];
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(touchEnd:)]) {
        [_touchDelegate touchEnd:touches];
    }
    if ([_delegate respondsToSelector:@selector(onPttrecordBtnUp)])
        [_delegate onPttrecordBtnUp];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(touchEnd:)]) {
        [_touchDelegate touchEnd:touches];
    }
    if ([_delegate respondsToSelector:@selector(onPttrecordBtnUp)])
    {
        [_delegate onPttrecordBtnUp];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    BOOL isInsideRect = [self judgeInside:pt];
    
    if(!isInsideRect && _insideRect)
    {
        if ([_delegate respondsToSelector:@selector(onPttRecordBtnmoveOut)])
            [_delegate onPttRecordBtnmoveOut];
    }
    else if(isInsideRect && !_insideRect)
    {
        if ([_delegate respondsToSelector:@selector(onPttRecordBtnMoveIn)]) {
            [_delegate onPttRecordBtnMoveIn];
        }
    }
    _insideRect = isInsideRect;
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(touchMove:)]) {
        [_touchDelegate touchMove:touches];
    }
    self.highlighted = YES;
}


-(void)setDelegate:(id<MyPttRecordBtnDelegate>)delegate
{
    _delegate = delegate;
}

@end


