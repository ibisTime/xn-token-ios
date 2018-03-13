//
//  ChatSystemEmojiItem.m
//  TIMChat
//
//  Created by AlexiChen on 16/4/5.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatSystemFaceItem.h"

@implementation ChatSystemFaceItem

- (NSString *)pngPath
{
    return nil;
}
- (NSString *)gifPath
{
    return nil;
}

- (UIImage *)inputPng
{
    NSString *name = [NSString stringWithFormat:@"%d.png", (int)self.emojiIndex];
    NSString *cfgPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:cfgPath];
    return img;
}

- (UIImage *)inputGif
{
    NSString *name = [NSString stringWithFormat:@"%d.gif", (int)self.emojiIndex];
    NSLog(@"faceName = %@", name);
    
    NSString *cfgPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:cfgPath];
    return img;
}

- (NSString *)gifName
{
    return [NSString stringWithFormat:@"%d", (int)self.emojiIndex];
}

- (TIMFaceElem *)systemFace
{
    TIMFaceElem *face = [[TIMFaceElem alloc] init];
    face.index = (int)self.emojiIndex;
    return face;
}

@end


@implementation ChatSystemFaceHelper

static ChatSystemFaceHelper *kSharedHelper = nil;

+ (instancetype)sharedHelper
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        kSharedHelper = [[ChatSystemFaceHelper alloc] init];
    });
    return kSharedHelper;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *cfgPath = [[NSBundle mainBundle] pathForResource:@"ChatSystemFaceConfig" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:cfgPath];
        _systemFaces = [NSObject loadItem:[ChatSystemFaceItem class] fromArrayDictionary:array];
    }
    return self;
}

- (ChatSystemFaceItem *)emojiItemOf:(NSInteger)index
{
    // TODO：index是从1开始的，需要
//    index -= 1;
    if (index >= 0 && index < _systemFaces.count)
    {
        ChatSystemFaceItem *item = _systemFaces[index];
        return item;
    }
    return nil;
}

- (UIImage *)emojiOf:(NSInteger)index
{
    if (index >= 0 && index < _systemFaces.count)
    {
        ChatSystemFaceItem *item = _systemFaces[index];
//        return [item inputPng];
        return [item inputGif];
    }
    return nil;
}


@end

