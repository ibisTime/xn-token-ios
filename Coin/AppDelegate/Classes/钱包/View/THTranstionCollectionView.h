//
//  THTranstionCollectionView.h
//  Coin
//
//  Created by shaojianfei on 2018/9/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyTitleModel.h"
#import "CurrencyModel.h"
typedef  NS_ENUM(NSInteger,SearchType) {
    
    SearchTypeTop = 0,
    SearchTypeBottom
    
};

@class THTranstionCollectionView;
@protocol THTranstionCollectionViewDelegate <NSObject>

@optional

- (void)refreshCollectionView:(THTranstionCollectionView*)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
/* 选中cell上的button时可使用 */
- (void)refreshCollectionViewButtonClick:(THTranstionCollectionView *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end
@interface THTranstionCollectionView : UICollectionView
@property (nonatomic, weak)   id<THTranstionCollectionViewDelegate> refreshDelegate;  //代理

@property (nonatomic ,assign) SearchType type;
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*titles;
//@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*resultTitleList;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*bottomtitles;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*models;

@property (nonatomic ,assign) BOOL IsNeedRefash;

@property (nonatomic ,strong) NSIndexPath *inde;

@property (nonatomic ,assign) BOOL isRead;
@property (nonatomic ,assign) BOOL isLocal;



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
