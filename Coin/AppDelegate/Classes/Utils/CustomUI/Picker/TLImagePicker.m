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

//- (void)picker {
//
//    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
//    pickCtrl.delegate = self;
//    pickCtrl.allowsEditing = self.allowsEditing;
//
//    UIAlertController *chooseImageCtrl = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    if (self.imageType != ImageTypePhoto) {
//
//        UIAlertAction *action00 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self.vc presentViewController:pickCtrl animated:YES completion:nil];
//
//        }];
//
//        [chooseImageCtrl addAction:action00];
//    }
//
//    if (self.imageType != ImageTypeCamera) {
//
//        UIAlertAction *action01 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self.vc presentViewController:pickCtrl animated:YES completion:nil];
//
//
//        }];
//
//        [chooseImageCtrl addAction:action01];
//    }
//
//    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    [chooseImageCtrl addAction:action02];
//    [self.vc presentViewController:chooseImageCtrl animated:YES completion:nil];
//
//}

- (void)picker {
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
    pickCtrl.delegate = self;
    pickCtrl.allowsEditing = self.allowsEditing;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [action setValue:RGB(138, 138, 138) forKey:@"titleTextColor"];
    }];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        
        pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.vc presentViewController:pickCtrl animated:YES completion:nil];
        
    }];
    UIAlertAction* fromPhotoAction1 = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        
        pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.vc presentViewController:pickCtrl animated:YES completion:nil];
        
    }];
//    [cancelAction setValue:GaryTextColor forKey:@"_titleTextColor"];
//    [fromPhotoAction setValue:MainColor forKey:@"_titleTextColor"];
//    [fromPhotoAction1 setValue:MainColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:fromPhotoAction];
    [alertController addAction:fromPhotoAction1];
    [self.vc presentViewController:alertController animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.pickFinish) {
        _pickFinish(info);
    }
}


@end
