//
//  TextFieldTableViewCell.h
//  CommonLibrary
//
//  Created by James on 15-1-7.
//  Copyright (c) 2015年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldTableViewCell;
typedef  BOOL (^TextFieldBeginEditAction)(TextFieldTableViewCell *cell);

@interface TextFieldTableViewCell : UITableViewCell<UITextFieldDelegate>
{
@protected
    UITextField *_edit;
}

@property (nonatomic, readonly) UITextField *edit;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) TextFieldBeginEditAction editAction;

- (instancetype)initWith:(NSString *)tip reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder editAction:(TextFieldBeginEditAction)act reuseIdentifier:(NSString *)reuseIdentifier;

//- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder locateIcon:(UIImage *)icon reuseIdentifier:(NSString *)reuseIdentifier;
//- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder locateIcon:(UIImage *)icon action:(CommonBlock)act reuseIdentifier:(NSString *)reuseIdentifier;

@end

