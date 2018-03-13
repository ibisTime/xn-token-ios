//
//  TLImagePicker.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLImagePicker.h"

@interface TLImagePicker ()

@property (nonatomic,strong) UIViewController *vc;

@end

@implementation TLImagePicker

- (instancetype)initWithVC:(UIViewController *)ctrl{

    if (self = [super init]) {
        
        self.vc = ctrl;
        
    }
    return self;

}

- (void)picker {
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
    pickCtrl.delegate = self;
    pickCtrl.allowsEditing = self.allowsEditing;
    
    UIAlertController *chooseImageCtrl = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.imageType != ImageTypePhoto) {
        
        UIAlertAction *action00 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.vc presentViewController:pickCtrl animated:YES completion:nil];
            
        }];
        
        [chooseImageCtrl addAction:action00];
    }
    
    if (self.imageType != ImageTypeCamera) {
        
        UIAlertAction *action01 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.vc presentViewController:pickCtrl animated:YES completion:nil];
            
            
        }];
        
        [chooseImageCtrl addAction:action01];
    }
    
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [chooseImageCtrl addAction:action02];
    [self.vc presentViewController:chooseImageCtrl animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.pickFinish) {
        _pickFinish(info);
    }
}


@end
