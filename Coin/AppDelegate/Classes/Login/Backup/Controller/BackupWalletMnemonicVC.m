//
//  BackupWalletMnemonicVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/19.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "BackupWalletMnemonicVC.h"
#import "BackupCollectionViewCell.h"
@interface BackupWalletMnemonicVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger selectNum;
    UIView *topView;
}

@property (nonatomic , strong)UICollectionView *SelectCollectionView;
@property (nonatomic , strong)NSMutableArray *SelectArray;
@property (nonatomic , strong)UICollectionView *BackupCollectionView;
@property (nonatomic , strong)NSMutableArray *BackupArray;

@end

@implementation BackupWalletMnemonicVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
//    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _SelectArray = [NSMutableArray array];
    _BackupArray = [NSMutableArray array];
    [_BackupArray addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]];
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    selectNum = 0;
//    [self initView];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(25, 60, SCREEN_WIDTH - 50, 160)];
    topView.backgroundColor = RGB(133, 202, 207);
    topView.layer.cornerRadius=5;
    topView.layer.shadowOpacity = 0.22;// 阴影透明度
    topView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    topView.layer.shadowRadius=3;// 阴影扩散的范围控制
    topView.layer.shadowOffset = CGSizeMake(1, 1);// 阴
    [self.view addSubview:topView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _SelectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(25, 60, SCREEN_WIDTH - 50, 160) collectionViewLayout:layout];
    _SelectCollectionView.delegate = self;
    _SelectCollectionView.dataSource = self;
    _SelectCollectionView.backgroundColor = kClearColor;
    _SelectCollectionView.showsVerticalScrollIndicator = NO;
    _SelectCollectionView.showsHorizontalScrollIndicator = NO;
    [_SelectCollectionView registerClass:[BackupCollectionViewCell class] forCellWithReuseIdentifier:@"backupCell"];
    _SelectCollectionView.tag = 1000;
    [self.view addSubview:_SelectCollectionView];
    
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    _BackupCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, _SelectCollectionView.yy + 22, SCREEN_WIDTH - 30, 200) collectionViewLayout:layout1];
    _BackupCollectionView.delegate = self;
    _BackupCollectionView.dataSource = self;
    _BackupCollectionView.backgroundColor = kClearColor;
    _BackupCollectionView.showsVerticalScrollIndicator = NO;
    _BackupCollectionView.showsHorizontalScrollIndicator = NO;
    [_BackupCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _BackupCollectionView.tag = 1001;
    [self.view addSubview:_BackupCollectionView];
    
}

#pragma mark -- Collection delegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1000) {
        return _SelectArray.count;
    }else
    {
        return _BackupArray.count;
    }
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView.tag == 1000) {
        BackupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"backupCell" forIndexPath:indexPath];
        cell.label.text = _SelectArray[indexPath.row];
        cell.label.tag = 10 + indexPath.row;
        return cell;
    }else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath:indexPath];
        
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, (SCREEN_WIDTH - 70)/3, 40)];
        backImage.image = kImage(@"圆角矩形2拷贝2");
        backImage.tag = 100 + indexPath.row;
        [cell addSubview:backImage];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0 , 0, (SCREEN_WIDTH - 70)/3, 40)textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
//        kViewBorderRadius(label, 5, 1, kWhiteColor);
        label.text = _BackupArray[indexPath.row];
        [backImage addSubview:label];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1000) {
        return CGSizeMake((SCREEN_WIDTH - 70)/3 , 135/4);
    }else
    {
        return CGSizeMake((SCREEN_WIDTH - 70)/3 , 40);
    }
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 1000) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    else
    {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 1000) {
        return 5;
    }else
    {
        return 10;
    }
    
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 1000) {
        return 5;
    }else
    {
        return 10;
    }
}



#pragma mark -- Collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了 %ld ", indexPath.row);
    if (collectionView.tag == 1000) {
        [_BackupArray addObject:_SelectArray[indexPath.row]];
        [_SelectArray removeObjectAtIndex:indexPath.row];
        [_SelectCollectionView reloadData];
        [_BackupCollectionView reloadData];
        
    }else
    {
        [_SelectArray addObject:_BackupArray[indexPath.row]];
        [_BackupArray removeObjectAtIndex:indexPath.row];
        
//        [CATransaction setDisableActions:YES];
        [_BackupCollectionView reloadData];
        
//        [_SelectCollectionView performBatchUpdates:^{
//
//
//
//        } completion:^(BOOL finished) {
//
//
//
//        }];
//        [_SelectCollectionView reloadData];
//        [CATransaction commit];
//        [_BackupCollectionView reloadData];
//        [_SelectCollectionView reloadData];
//        [UIView animateWithDuration:0.5 animations:^{
//
//            UIImageView *image = [self.view viewWithTag:indexPath.row + 100];
//            image.frame = CGRectMake(-5 + _SelectArray.count%3*((SCREEN_WIDTH - 70)/3 + 5) ,  60 + 5 + _SelectArray.count/3*(135/4 + 5) - 160 - 22, (SCREEN_WIDTH - 70)/3, 135/4);
//
//        } completion:^(BOOL finished) {
//            [_SelectCollectionView reloadData];
//        }];
        
        
        
        
        
        
        
        
        
    }
}


-(void)initView
{
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(25, 60, SCREEN_WIDTH - 50, 160)];
    topView.backgroundColor = RGB(133, 202, 207);
    topView.layer.cornerRadius=5;
    topView.layer.shadowOpacity = 0.22;// 阴影透明度
    topView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    topView.layer.shadowRadius=3;// 阴影扩散的范围控制
    topView.layer.shadowOffset = CGSizeMake(1, 1);// 阴
    [self.view addSubview:topView];
    
    
    
    
    for (int i = 0; i < 12; i ++) {
        
        
        UIView *backupView = [[UIView alloc]initWithFrame:CGRectMake(30 + i%3*((SCREEN_WIDTH - 70)/3 + 5),  60 + 5 + i/3*(135/4 + 5), (SCREEN_WIDTH - 70)/3, 135/4)];
//        backupView.backgroundColor = kWhiteColor;
        backupView.tag = i + 10;
        [self.view addSubview:backupView];
        
        UIButton *backupBtn = [UIButton buttonWithTitle:@"buy" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
        backupBtn.frame = CGRectMake(25 + i%3*((SCREEN_WIDTH - 70)/3 + 10), topView.yy + 27 + i/3*50, (SCREEN_WIDTH - 70)/3, 40);
        
        [backupBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
        [backupBtn setBackgroundImage:kImage(@"") forState:(UIControlStateSelected)];
        
        
        [backupBtn addTarget:self action:@selector(backupBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        backupBtn.tag = 100 + i;
        [self.view addSubview:backupBtn];
    }
}

-(void)backupBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (sender.selected == YES) {
        UIView *selectView = [self.view viewWithTag:selectNum + 10];
        [UIView animateWithDuration:0.5 animations:^{
            sender.frame = selectView.frame;
            kViewBorderRadius(sender, 5, 1, kWhiteColor);
            [sender setBackgroundImage:kImage(@"") forState:(UIControlStateNormal)];
        }];
        selectNum ++;
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            sender.frame = CGRectMake(25 + (sender.tag - 100)%3*((SCREEN_WIDTH - 70)/3 + 10), topView.yy + 27 + (sender.tag - 100)/3*50, (SCREEN_WIDTH - 70)/3, 40);
            kViewBorderRadius(sender, 5, 0, kClearColor);
            [sender setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
            
        }];
        selectNum --;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
