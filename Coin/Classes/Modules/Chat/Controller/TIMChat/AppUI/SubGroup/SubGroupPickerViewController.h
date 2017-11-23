//
//  SubGroupPickerViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SubGroupMgrViewController.h"

@interface SubGroupPickerViewController : SubGroupMgrViewController
{
@protected
    IMASubGroup *_selectedSubGroup;
}

@property (nonatomic, strong) IMASubGroup *selectedSubGroup;
@property (nonatomic, copy)  CommonCompletionBlock pickCompletion;

- (instancetype)initWithCompletion:(CommonCompletionBlock)completion;
@end
