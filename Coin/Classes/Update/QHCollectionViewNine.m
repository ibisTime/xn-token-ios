//
//  QHCollectionViewNine.m
//  Collection
//
//  Created by qh on 16/5/24.
//  Copyright © 2016年 qh. All rights reserved.
//

#import "QHCollectionViewNine.h"
#import "AppColorMacro.h"
#import "AddSearchCell.h"
#import "AddSearchBottomCell.h"
#import "TLUIHeader.h"
@interface QHCollectionViewNine ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UICollectionViewFlowLayout *Layout;
@property (nonatomic, strong) AddSearchBottomCell *currentCell;

@end
@implementation QHCollectionViewNine
static NSString *identifierCell = @"AddSearchCell";
static NSString *bottomIdentifierCell = @"AddSearchBottomCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withImage:(NSArray *)image {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _imageArr = image;
//        _Layout = (UICollectionViewFlowLayout *)layout;
        self.pagingEnabled = NO;
//        _Layout.minimumLineSpacing      = 15.f;
      
        self.allowsSelection = YES;
        self.allowsMultipleSelection = YES;
//        self.bounces = NO;
//        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[AddSearchCell class] forCellWithReuseIdentifier:identifierCell];
        [self registerClass:[AddSearchBottomCell class] forCellWithReuseIdentifier:bottomIdentifierCell];

    }
    return self;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == SearchTypeTop) {
        return self.titles.count;

    }else{
        
        return self.bottomtitles.count;

    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.type == SearchTypeTop) {
        AddSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
        cell.title = self.titles[indexPath.row];
        
        return cell;
    }else{
        AddSearchBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomIdentifierCell forIndexPath:indexPath];
        cell.title = self.bottomtitles[indexPath.row];
        cell.selectedBtn.tag = 20180608 + indexPath.row;
        
        return cell;
        
    }
    
 
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshCollectionView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchTypeTop) {
        CurrencyTitleModel *titleModel = self.titles[indexPath.row];
        CGSize labSize = [titleModel.symbol boundingRectWithSize:CGSizeMake(kScreenWidth, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:18]} context:nil].size;
        NSLog(@"%@",NSStringFromCGSize(labSize));
        return CGSizeMake(labSize.width +15, 40);
    }else{
//        if (self.IsNeedRefash == NO) {
//            return CGSizeMake(80, 40);
//        }
    CurrencyTitleModel *titleModel = self.bottomtitles[indexPath.row];
    CGSize labSize = [titleModel.symbol boundingRectWithSize:CGSizeMake(kScreenWidth, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,NSFontAttributeName :[UIFont systemFontOfSize:18]} context:nil].size;
    NSLog(@"%@",NSStringFromCGSize(labSize));
    return CGSizeMake(labSize.width +10, 40);
    }
    
}

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
@end
