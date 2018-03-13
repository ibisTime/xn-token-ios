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

#import "MyEmojBoardView.h"
#import "EmojHelper.h"
#import "MyUIDefine.h"

@interface MyEmojBoardView(){
}
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray* emojBtns;
@property (nonatomic, strong)UIButton* delBtn;

- (void)emojBtnAction:(id)sender;
- (void)delBtnAction:(id)sender;

@end

@implementation MyEmojBoardView

+ (MyEmojBoardView *)viewWithPage:(NSInteger)page frame:(CGRect)rect
{
    MyEmojBoardView* view = [[MyEmojBoardView alloc] initWithFrame:rect];
    if (view)
    {
        view.page = page;
        view.tag = [self viewTagWithPage:page];
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

+ (NSInteger)viewTagWithPage:(NSInteger)page
{
    return 0x1000+page;
}

//初始化显示表情的buttons
- (NSArray *)emojBtns
{
    if (!_emojBtns)
    {
        _emojBtns = [[NSMutableArray alloc] initWithCapacity:CHAT_EMOJ_ROW*CHAT_EMOJ_COL];
        for (NSInteger i=self.page*(CHAT_EMOJ_ROW*CHAT_EMOJ_COL-1); i<(self.page+1)*(CHAT_EMOJ_ROW*CHAT_EMOJ_COL-1)&&i<[EmojHelper emojCount]; i++)
        {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_emojBtns addObject:btn];
            EmojInfo* emojInfo= [EmojHelper emojAtIndex:i];
            btn.titleLabel.font = EMOJI_FONT;
            [btn setTitle:emojInfo.emjStr forState:UIControlStateNormal];
            btn.tag = emojInfo.index;
            [btn addTarget:self action:@selector(emojBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return _emojBtns;
}

- (UIButton *)delBtn
{
    if (!_delBtn)
    {
        _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_delBtn setImage:[UIImage imageNamed:@"face_delete"] forState:UIControlStateNormal];
        [_delBtn setImage:[UIImage imageNamed:@"face_delete_pressed"] forState:UIControlStateHighlighted];
        [_delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delBtn];
    }
    return _delBtn;
}

- (void)drawEmojs:(CGRect)rect
{
    //安排每一个button的位置
    CGFloat cellHeight = (rect.size.height-2*CHAT_EMOJ_VECTICAL_PADDING)/CHAT_EMOJ_ROW;
    CGFloat inset = (rect.size.width - CHAT_EMOJ_COL * CHAT_EMOJ_SIZE) / ((CHAT_EMOJ_COL + 1) * 2);
    CGFloat cellWidth = (rect.size.width-2*inset)/CHAT_EMOJ_COL;
    NSInteger maxCount = CHAT_EMOJ_COL*CHAT_EMOJ_ROW-1;
    if ((self.page+1)*(CHAT_EMOJ_COL*CHAT_EMOJ_ROW-1)>[EmojHelper emojCount])
    {
        maxCount = [EmojHelper emojCount] - (self.page)*(CHAT_EMOJ_COL*CHAT_EMOJ_ROW-1);
    }
    NSInteger i = 0;
    if (self.page == 3)
        i++;
    for (i=0; i<maxCount; i++)
    {
        UIButton* btn = [self.emojBtns objectAtIndex:i];
        btn.frame = CGRectMake(inset+(i%CHAT_EMOJ_COL)*cellWidth, CHAT_EMOJ_VECTICAL_PADDING+(i/CHAT_EMOJ_COL)*cellHeight, cellWidth, cellHeight);
    }
    
    //添加删除按键
    self.delBtn.frame = CGRectMake(inset+(CHAT_EMOJ_COL-1)*cellWidth, CHAT_EMOJ_VECTICAL_PADDING+(CHAT_EMOJ_ROW-1)*cellHeight, cellWidth, cellHeight);
}

- (void)layoutSubviews
{
    [self drawEmojs:self.bounds];
}

- (void)setDelegate:(id<MyEmojBoardDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark- buttonAction
- (void)emojBtnAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    EmojInfo* info = [EmojHelper emojAtIndex:btn.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojSelect:)])
    {
        [self.delegate emojSelect:info];
    }
}

- (void)delBtnAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojDelete)])
    {
        [self.delegate emojDelete];
    }
}

@end
