//
//  TLImagePicker.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinHeader.h"

//
typedef NS_ENUM(NSInteger, ImageType) {

    ImageTypeAll = 0,   //拍照和相册
    ImageTypePhoto,     //相册
    ImageTypeCamera,    //拍照
};

@interface TLImagePicker : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,copy)  void(^pickFinish)(NSDictionary *info);

@property (nonatomic, assign) ImageType imageType;

- (instancetype)initWithVC:(UIViewController *)ctrl;

@property (nonatomic,assign) BOOL allowsEditing;

- (void)picker;

@end
