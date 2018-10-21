//
//  THTranstionCollectionView.m
//  Coin
//
//  Created by shaojianfei on 2018/9/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "THTranstionCollectionView.h"
#import "AppColorMacro.h"
#import "AddSearchCell.h"
#import "AddSearchBottomCell.h"
#import "TLUIHeader.h"
#import "TransformCell.h"

@interface THTranstionCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UICollectionViewFlowLayout *Layout;
@property (nonatomic, strong) AddSearchBottomCell *currentCell;

@end
@implementation THTranstionCollectionView

static NSString *identifierCell = @"TransformCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withImage:(NSArray *)image {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _imageArr = image;
        //        _Layout = (UICollectionViewFlowLayout *)layout;
        self.pagingEnabled = NO;
                
        self.allowsSelection = YES;
        self.allowsMultipleSelection = NO;
        //        self.bounces = NO;
        //        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[TransformCell class] forCellWithReuseIdentifier:identifierCell];
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
        return self.models.count;
  
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
 
        TransformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = kLineColor;
    }
        cell.isLocal = self.isLocal;
        cell.model = self.models[indexPath.row];
        
        return cell;
  
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    
     TransformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
//    cell.backgroundColor = kOrangeRedColor;
//    UIView *back = [UIView new];
//    back.backgroundColor = kTextBlack;
//    back.frame = cell.bounds;
//    [cell addSubview:back];
    cell.isClick = YES;
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshCollectionView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.isRead == YES) {
//        return CGSizeMake(kWidth(100), 45);
//    }else{
//        if (self.type == SearchTypeTop) {
//            CurrencyTitleModel *titleModel = self.titles[indexPath.row];
//            CGSize labSize = [titleModel.symbol boundingRectWithSize:CGSizeMake(kScreenWidth, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:18]} context:nil].size;
//            NSLog(@"%@",NSStringFromCGSize(labSize));
//            return CGSizeMake(labSize.width +15, 40);
//        }else{
//            //        if (self.IsNeedRefash == NO) {
//            //            return CGSizeMake(80, 40);
//            //        }
//            CurrencyTitleModel *titleModel = self.bottomtitles[indexPath.row];
//            CGSize labSize = [titleModel.symbol boundingRectWithSize:CGSizeMake(kScreenWidth, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:18]} context:nil].size;
//            NSLog(@"%@",NSStringFromCGSize(labSize));
//            return CGSizeMake(labSize.width +10, 40);
//        }
//    }
//
//
//}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return YES;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return YES;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return  YES;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return  YES;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return  YES;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return YES;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchTypeBottom) {
        NSLog(@"%s",__func__);
    }
    return  YES;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 0, -20, 10);//分别为上、左、下、右
}
-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.inde  == nil) {
        NSIndexPath *ind = [NSIndexPath indexPathForRow:0 inSection:0];
        
        TransformCell *cell1 = (TransformCell *)[collectionView cellForItemAtIndexPath:ind];
        cell1.backgroundColor = kWhiteColor;
    }
    TransformCell *cell1 = (TransformCell *)[collectionView cellForItemAtIndexPath:self.inde];
    cell1.backgroundColor = kWhiteColor;
    
    TransformCell *cell = (TransformCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.inde = indexPath;
    cell.backgroundColor = kLineColor;
}
//点击放开item,cell上图片复原
- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    TransformCell *cell = (TransformCell *)[collectionView cellForItemAtIndexPath:indexPath];

    

}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//
//    return 10;
//}

@end
