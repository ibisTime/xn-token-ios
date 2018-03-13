//
//  RichChatEmoji.h
//  TIMChat
//
//  Created by AlexiChen on 16/4/5.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatSystemFaceItem : NSObject

@property (nonatomic, strong) NSString      *emojiTag;      // 缩写含义
@property (nonatomic, assign) NSInteger     emojiIndex;     // 系统表情的资源Id


- (UIImage *)inputPng;

- (UIImage *)inputGif;
- (NSString *)gifName;

- (TIMFaceElem *)systemFace;

@end


@interface ChatSystemFaceHelper : NSObject
{
@protected
    NSArray *_systemFaces;
}

@property (nonatomic, readonly) NSArray *systemFaces;

+ (instancetype)sharedHelper;

- (ChatSystemFaceItem *)emojiItemOf:(NSInteger)index;
- (UIImage *)emojiOf:(NSInteger)index;

@end


