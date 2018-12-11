//
//  ClassificationCollCell.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/3.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassificationDelegate <NSObject>

-(void)ClassificationDelegateSelectBtn:(NSInteger)tag;


@end
@interface ClassificationCollCell : UICollectionViewCell


@property (nonatomic, assign) id <ClassificationDelegate> delegate;

@end
