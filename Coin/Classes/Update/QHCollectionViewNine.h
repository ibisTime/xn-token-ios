//
//  QHCollectionViewNine.h
//  Collection
//
//  Created by qh on 16/5/24.
//  Copyright © 2016年 qh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyTitleModel.h"
typedef  NS_ENUM(NSInteger,SearchType) {
    
    SearchTypeTop = 0,
    SearchTypeBottom
    
};

@class QHCollectionViewNine;
@protocol addCollectionViewDelegate <NSObject>

@optional

- (void)refreshCollectionView:(QHCollectionViewNine*)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
/* 选中cell上的button时可使用 */
- (void)refreshCollectionViewButtonClick:(QHCollectionViewNine *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface QHCollectionViewNine : UICollectionView
@property (nonatomic, weak)   id<addCollectionViewDelegate> refreshDelegate;  //代理

@property (nonatomic ,assign) SearchType type;
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*titles;
//@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*resultTitleList;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*bottomtitles;

@property (nonatomic ,assign) BOOL IsNeedRefash;

@property (nonatomic ,assign) BOOL isRead;



/**
 *  @frame: collectionView的frame
 *
 *  @layout: UICollectionViewFlowLayout的属性 这次放在外界设置了，比较方便
 *
 *  @image: 本地图片数组(NSArray<UIImage *> *) 或者网络url的字符串(NSArray<NSString *> *)
 *
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withImage:(NSArray *)image;
@end
