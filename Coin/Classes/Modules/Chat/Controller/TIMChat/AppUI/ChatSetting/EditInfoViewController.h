//
//  EditInfoViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMBaseViewController.h"

@interface EditInfoViewController : IMBaseViewController
{
@protected
    UIView  *_editBack;
    UIView  *_edit;
    
@protected
    NSString *_rawText;
}

@property (nonatomic, copy) CommonCompletionBlock completion;

- (instancetype)initWith:(NSString *)title completion:(CommonCompletionBlock)com;
- (instancetype)initWith:(NSString *)title text:(NSString *)text completion:(CommonCompletionBlock)com;

- (void)addEdit;
- (NSString *)editText;
//- (void)setEditText:(NSString *)text;
//- (void)setEditPlaceHolder:(NSString *)text;

@end



@interface EditTextViewController : EditInfoViewController


- (void)setLimitLength:(NSInteger)length;

@end
