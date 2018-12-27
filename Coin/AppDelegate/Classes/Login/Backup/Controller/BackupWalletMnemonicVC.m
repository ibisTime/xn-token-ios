//
//  BackupWalletMnemonicVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/19.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "BackupWalletMnemonicVC.h"
#import "BackupCollectionViewCell.h"
#import "ConfirmBackupVC.h"
#import "TLTabBarController.h"
@interface BackupWalletMnemonicVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UIView *topView;
    
    UIButton *animBtn;
    NSArray *arr;
}

@property (nonatomic , strong)UICollectionView *SelectCollectionView;
@property (nonatomic , strong)NSMutableArray *SelectArray;
@property (nonatomic , strong)UICollectionView *BackupCollectionView;
@property (nonatomic , strong)NSMutableArray *BackupArray;
@property (nonatomic , strong)UILabel *promptLbl;
@end

@implementation BackupWalletMnemonicVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
//    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _SelectArray = [NSMutableArray array];
    _BackupArray = [NSMutableArray array];
//    [_BackupArray addObjectsFromArray:];
    ;
    arr = [[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC] componentsSeparatedByString:@" "];
//    NSMutableArray *newArr = [NSMutableArray new];
    while (_BackupArray.count != arr.count) {
        //生成随机数
        int x = arc4random() % arr.count;
        id obj = arr[x];
        if (![_BackupArray containsObject:obj]) {
            [_BackupArray addObject:obj];
        }
    }
    
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
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
    
    
    UILabel *promptLbl = [UILabel labelWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 90, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#ffffff")];
    promptLbl.text = [LangSwitcher switchLang:@"请将您抄下的12个助记词按照正确的顺序输入" key:nil];
    [promptLbl sizeToFit];
    self.promptLbl = promptLbl;
    [topView addSubview:promptLbl];
    
    
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
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 65, _BackupCollectionView.yy + 35, 130, 50);
    kViewRadius(confirmBtn, 10);
    confirmBtn.backgroundColor = RGB(94, 164, 226);
    [confirmBtn addTarget:self action:@selector(confirmBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:confirmBtn];
    
    
    
    animBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    [animBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    animBtn.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, (SCREEN_WIDTH - 70)/3, 40);
    [animBtn addTarget:self action:@selector(animBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:animBtn];
    
}

-(void)animBtnClick
{
    
    
//    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证成功" key:nil]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

-(void)confirmBtn
{
    if (_SelectArray.count != 12) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"选择全部助记词" key:nil]];
        return;
    }
    for (int i = 0; i < _SelectArray.count; i ++) {
        if (![_SelectArray[i] isEqualToString:arr[i]]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"顺序有误" key:nil]];
            return;
        }
    }
    ConfirmBackupVC *vc = [ConfirmBackupVC new];
    [self.navigationController pushViewController:vc animated:YES];
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
        
        
        
        animBtn.hidden = NO;
        animBtn.frame = CGRectMake(_SelectCollectionView.x + 5 + indexPath.row %3* ((SCREEN_WIDTH - 70)/3 + 5), _SelectCollectionView.y + 5 + indexPath.row / 3* (135/4 + 5), (SCREEN_WIDTH - 70)/3, 135/4);
        [animBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
        kViewBorderRadius(animBtn, 5, 0, kClearColor);
        [animBtn setTitle:_SelectArray[indexPath.row] forState:(UIControlStateNormal)];
        
        [_BackupArray addObject:_SelectArray[indexPath.row]];
        
        [self.SelectCollectionView  performBatchUpdates:^{
            [_SelectArray removeObjectAtIndex:indexPath.row];
            [self.SelectCollectionView  deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self.SelectCollectionView  reloadData];
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            animBtn.frame = CGRectMake(25 + (_BackupArray.count - 1) % 3 * ((SCREEN_WIDTH - 70)/3 + 10), _BackupCollectionView.y + 10 + (_BackupArray.count - 1) / 3 * (40 + 10), (SCREEN_WIDTH - 70)/3, 40);
            
        } completion:^(BOOL finished) {
            animBtn.hidden = YES;
            [_BackupCollectionView reloadData];
        }];
        
        

    }else
    {
        animBtn.hidden = NO;
        animBtn.frame = CGRectMake(25 + indexPath.row % 3 * ((SCREEN_WIDTH - 70)/3 + 10), _BackupCollectionView.y + 10 + indexPath.row / 3 * (40 + 10), (SCREEN_WIDTH - 70)/3, 40);
        [animBtn setBackgroundImage:kImage(@"") forState:(UIControlStateNormal)];
        [animBtn setTitle:_BackupArray[indexPath.row] forState:(UIControlStateNormal)];
        kViewBorderRadius(animBtn, 5, 1, kWhiteColor);
        
        [_SelectArray addObject:_BackupArray[indexPath.row]];
        [self.BackupCollectionView performBatchUpdates:^{
            [_BackupArray removeObjectAtIndex:indexPath.row];
            [self.BackupCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self.BackupCollectionView reloadData];
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            animBtn.frame = CGRectMake(_SelectCollectionView.x + 5 + (_SelectArray.count - 1) %3* ((SCREEN_WIDTH - 70)/3 + 5), _SelectCollectionView.y + 5 + (_SelectArray.count - 1) / 3* (135/4 + 5), (SCREEN_WIDTH - 70)/3, 135/4);
            
        } completion:^(BOOL finished) {
            animBtn.hidden = YES;
            [_SelectCollectionView reloadData];
        }];
    }
    
    if (_SelectArray.count != 0) {
        _promptLbl.hidden=  YES;
    }else
    {
        _promptLbl.hidden=  NO;
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
