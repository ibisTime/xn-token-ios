//
//  TLQusertionVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLQusertionVC.h"
#import "FilterView.h"
#import "TLTextView.h"
#import "LPDQuoteImagesView.h"
#import "TLTextField.h"
#import "TLhistoryListVC.h"
#import "TLUploadManager.h"
#import "TLhistoryListVC.h"
#import "NSString+Check.h"
@interface TLQusertionVC ()<UITextViewDelegate,LPDQuoteImagesViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UIButton *showView;

@property (nonatomic, strong) UILabel *historyLable;
//筛选
@property (nonatomic, strong) FilterView *filterPicker;

@property (nonatomic, strong) UILabel *typeLab;

@property (nonatomic, strong) UIButton *typeButton;

@property (nonatomic, strong) UILabel *typechange;

@property (nonatomic, strong) UILabel *Qintroduce;

@property (nonatomic, strong) TLTextView *textView;
@property (nonatomic, strong) TLTextView *reproductionView;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) TLTextField *introduceTf;

@property (nonatomic ,strong) UIButton *nextButton;
@property (nonatomic ,strong) LPDQuoteImagesView *quoteImagesView;

@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong)  UIView *lineView1;
@property (nonatomic ,strong)  UILabel *imageLable;
@property (nonatomic ,copy)  NSString *type;
@property (nonatomic ,assign) NSInteger count;

@property (nonatomic ,copy)  NSString *tempText;

@property (nonatomic ,copy)  NSString *tempRe;

@property (nonatomic ,strong)  NSMutableArray *imageString;

@end

@implementation TLQusertionVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.title = [LangSwitcher switchLang:@"问题反馈" key:nil];

    [self initCustomUi];
    [self initBodyView];
    
    [self initPicker];
    self.typechange.text = @"iOS";
    self.type = @"iOS";
    // Do any additional setup after loading the view.
}

-(NSMutableArray *)imageString
{
    if (!_imageString) {
        _imageString = [NSMutableArray array];
    }
    return _imageString;
}

- (void)initPicker
{
//    self.imageLable
    UILabel *imageLable = [[UILabel alloc] initWithFrame:CGRectMake(15, self.reproductionView.yy+10, kScreenWidth - 30, 22)];
    imageLable.text = [LangSwitcher switchLang:@"问题截图(选填)" key:nil];
    imageLable.textColor = kTextColor3;
    imageLable.font = [UIFont systemFontOfSize:14];
    [self.bgImage addSubview:imageLable];
    
    LPDQuoteImagesView *quoteImagesView =[[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(15, imageLable.yy + 10, kScreenWidth -30, 90) withCountPerRowInView:4 cellMargin:11];
    //初始化view的frame, view里每行cell个数， cell间距（上方的图片1 即为quoteImagesView）
//    注：设置frame时，我们可以根据设计人员给的cell的宽度和最大个数、排列，间距去大致计算下quoteview的size.
    quoteImagesView.maxSelectedCount = 9;
    self.quoteImagesView = quoteImagesView;
    //最大可选照片数
    
    quoteImagesView.collectionView.scrollEnabled = YES;
    //view可否滑动
    CoinWeakSelf;
    quoteImagesView.HeightChange = ^(CGFloat height) {
        
        [self.quoteImagesView removeFromSuperview];
        
        [self.bgImage addSubview:self.quoteImagesView];
//        self.quoteImagesView.collectionView.collectionViewLayout.collectionViewContentSize = CGSizeMake(0, height+100);
//        self.quoteImagesView.frame = CGRectMake(15, self.reproductionView.yy + 10, kScreenWidth -30, height);
//        self.lineView.frame =  CGRectMake(15, self.introduceTf.yy+5, kScreenWidth - 30, 0.5);
//        self.introduceTf.frame = CGRectMake(15, self.quoteImagesView.yy + 10, kScreenWidth-30, 50);
//        self.lineView1.frame = CGRectMake(15, self.introduceTf.yy+5, kScreenWidth - 30, 0.5);
//        
//        self.nextButton.frame =  CGRectMake(15, self.introduceTf.yy+30, kScreenWidth - 30, 45);


//        [self.view setNeedsLayout];
        [self.bgImage setNeedsDisplay];
    };
    quoteImagesView.navcDelegate = self;    //self 至少是一个控制器。
    //委托（委托controller弹出picker，且不用实现委托方法）
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kHexColor(@"#E3E3E3");
    self.lineView = lineView;
    lineView.frame = CGRectMake(15, quoteImagesView.yy+10, kScreenWidth - 30, 0.5);
    [self.bgImage addSubview:lineView];
    [self.bgImage addSubview:quoteImagesView];
    TLTextField *introduceTf = [[TLTextField alloc] initWithFrame:CGRectMake(15, quoteImagesView.yy + 10, kScreenWidth-30, 50) leftTitle:[LangSwitcher switchLang:@"备注(选填)" key:nil] titleWidth:120 placeholder:[LangSwitcher switchLang:@"" key:nil]];
    //    introduceTf.secureTextEntry = YES;
    [self.bgImage addSubview:introduceTf];
    introduceTf.leftLbl.font = [UIFont systemFontOfSize:14];
    self.introduceTf = introduceTf;
   
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = kHexColor(@"#E3E3E3");
    lineView1.frame = CGRectMake(15, introduceTf.yy+5, kScreenWidth - 30, 0.5);
    [self.bgImage addSubview:lineView1];
    self.lineView1 = lineView1;
    self.nextButton = [UIButton buttonWithImageName:nil cornerRadius:4];
    NSString *text = [LangSwitcher switchLang:@"提交" key:nil];
    [self.nextButton setTitle:text forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.nextButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.frame =  CGRectMake(15, introduceTf.yy+30, kScreenWidth - 30, 45);
    [self.nextButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.bgImage addSubview:self.nextButton];
    self.bgImage.contentSize = CGSizeMake(0,  self.nextButton.yy+100);

//    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(introduceTf.mas_bottom).offset(10);
//        make.right.equalTo(self.bgImage.mas_right).offset(-15);
//        make.left.equalTo(self.bgImage.mas_left).offset(15);
//        make.height.equalTo(@48);
//
//    }];
    
//    self.bgImage.contentSize = CGSizeMake(0, 0);
    
}

- (void)submit
{
    //提交
    if (!self.type || self.type == nil) {
        [TLAlert alertWithMsg:[LangSwitcher switchLang:@"请选择客户端" key:nil]];
        return;
    }
    if ([self.textView.text isBlank]) {
        [TLAlert alertWithMsg:[LangSwitcher switchLang:@"请详细描述一下问题" key:nil]];
        return;
    }
    if ([self.reproductionView.text isBlank]) {
        [TLAlert alertWithMsg:[LangSwitcher switchLang:@"请填写复现步骤" key:nil]];
        return;
    }
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.isUploadToken = NO;
    http.code = @"805100";
    http.parameters[@"deviceSystem"] = self.type;
    http.parameters[@"description"] = self.textView.text;
    http.parameters[@"reappear"] = self.reproductionView.text;
    http.parameters[@"commitUser"] = [TLUser user].userId;

    if (self.quoteImagesView.selectedPhotos.count > 0) {
        ///需要上传照片
        self.count = self.quoteImagesView.selectedPhotos.count;
        [self postImageRequset];
        return;
    }
    if (self.introduceTf.text) {
        http.parameters[@"commitNote"] = self.introduceTf.text;

    }

    [http postWithSuccess:^(id responseObject) {
        
        NSString *H5code = responseObject[@"data"];
        
        if (H5code) {
            [self gohistory];

            [TLAlert alertWithMsg:[LangSwitcher switchLang:@"问题反馈提交成功" key:nil]];

        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        //        [TLProgressHUD dismiss];
        
    }];
    
    
    
}


- (void)postImageRequset
{
    
    NSMutableData *imgData;
    NSInteger count = self.quoteImagesView.selectedPhotos.count;
//    for (int i = 0; i < self.quoteImagesView.selectedPhotos.count; i++) {
        UIImage *im =self.quoteImagesView.selectedPhotos[count-self.count];
        
       imgData = (NSMutableData*)UIImageJPEGRepresentation(im, 0.1);
        
        TLUploadManager *manager = [TLUploadManager manager];
        
        manager.imgData = imgData;
            manager.image = im;
        self.count --;
        [manager getQuestionTokenShowView:self.view succes:^(NSString *key) {
            
            
            //        [self changeHeadIconWithKey:key imgData:imgData];
//            [TLAlert alertWithSucces:@"上传成功"]
            
            if (key) {
                
                [self.imageString addObject:key];
                if (self.count == 0) {
                  
                    // 上传图片名称 到后台
                    [self postImageStringWithArray:self.imageString];
                    return ;
                }
                
                [self postImageRequset];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
//    }
    
    //进行上传
   
}

- (void)postImageStringWithArray: (NSMutableArray *)arr
{
    
    TLNetworking *http = [TLNetworking new];
    
    http.isUploadToken = NO;
    http.code = @"805100";
    http.parameters[@"deviceSystem"] = self.type;
    http.parameters[@"description"] = self.textView.text;
    http.parameters[@"reappear"] = self.reproductionView.text;
    http.parameters[@"commitUser"] = [TLUser user].userId;
    
    if (self.imageString.count > 0) {
//        ///需要上传照片
//        self.count = self.quoteImagesView.selectedPhotos.count;
//        [self postImageRequset];
//        return;
        
       
        NSString *str = [self.imageString componentsJoinedByString:@"||"];
//        str = [str substringToIndex:str.length-2];
        http.parameters[@"pic"] = str;
        

    }
    if (self.introduceTf.text) {
        http.parameters[@"commitNote"] = self.introduceTf.text;
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *H5code = responseObject[@"data"];
        
        if (H5code) {
            [self gohistory];

            [TLAlert alertWithMsg:[LangSwitcher switchLang:@"问题反馈提交成功" key:nil]];
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        //        [TLProgressHUD dismiss];
        
    }];
    
}

- (void)back
{
    TLhistoryListVC *h = [TLhistoryListVC new];
    [self.navigationController pushViewController:h animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[[LangSwitcher switchLang:@"iOS" key:nil],
                             [LangSwitcher switchLang:@"Android" key:nil],
                             [LangSwitcher switchLang:@"H5" key:nil]

                             ];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _filterPicker.title =  [LangSwitcher switchLang: @"请选择客户端" key:nil];
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            NSString *text = textArr[index];
            weakSelf.typechange.text = text;
            if (index == 0) {
                weakSelf.type = @"iOS";

            }else if (index == 1){
                  weakSelf.type = @"Android";

            }else{
                
                weakSelf.type = @"H5";

            }
//            weakSelf.helper.parameters[@"bizType"] = typeArr[index];
            
//            [weakSelf.tableView beginRefreshing];
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}


- (void)initCustomUi
{
//    self.contentView = [[UIScrollView alloc] init];
//    [self.view addSubview:self.contentView];
//
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
//    self.contentView.scrollEnabled = YES;
    self.bgImage = [[UIScrollView alloc] init];
//    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
    self.bgImage.delegate = self;
    self.bgImage.backgroundColor = kWhiteColor;
//    self.bgImage.image = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(kWhiteColor.convertToImage)];
//    self.bgImage.image = kImage(@"我的 背景");
    [self.view  addSubview:self.bgImage];
    self.bgImage.scrollEnabled = YES;
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backButton.frame = CGRectMake(15, kStatusBarHeight, 40, 40);
    [self.backButton setImage:kImage(@"返回1-1") forState:(UIControlStateNormal)];
    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgImage addSubview:self.backButton];
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight, kScreenWidth - 108, 44)];
    self.nameLable.text = [LangSwitcher switchLang:@"问题反馈" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    [self.bgImage addSubview:self.nameLable];
    
    
    
    self.historyLable = [[UILabel alloc] init];
//    WithFrame:CGRectMake(kScreenWidth -54 -108-20, kStatusBarHeight+5, kScreenWidth - 108, 44)
    self.historyLable.text = [LangSwitcher switchLang:@"历史反馈" key:nil];
    self.historyLable.textAlignment = NSTextAlignmentRight;
    self.historyLable.userInteractionEnabled = YES;
    self.historyLable.font = Font(13);
    self.historyLable.textColor = kTextBlack;
    [self.bgImage addSubview:self.historyLable];
    [self.historyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLable.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        
        
    }];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gohistory)];
    [self.historyLable addGestureRecognizer:ta];
    
    
    
}

- (void)gohistory
{
    TLhistoryListVC *vc = [TLhistoryListVC new];
    vc.title = [LangSwitcher switchLang:@"历史反馈" key:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initBodyView
{
    self.typeLab = [[UILabel alloc] init];
    
    self.typeLab.text = [LangSwitcher switchLang:@"所在端" key:nil];
    self.typeLab.textAlignment = NSTextAlignmentLeft;
//    self.historyLable.userInteractionEnabled = YES;
    self.typeLab.font = Font(14);
    self.typeLab.textColor = kTextColor3;
    [self.bgImage addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(90)));
        make.left.equalTo(self.bgImage.mas_left).offset(15);
    }];
    
    self.typeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.typeButton setBackgroundImage:kImage(@"下啦") forState:(UIControlStateNormal)];
    [self.typeButton setBackgroundImage:kImage(@"上啦") forState:(UIControlStateSelected)];
    [self.typeButton setTitle:@"iOS" forState:UIControlStateNormal];
    self.typeButton.titleLabel.textColor = kTextColor;
    self.typeButton.titleLabel.font = FONT(12);
    [self.typeButton addTarget:self action:@selector(history) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgImage addSubview:self.typeButton];
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(90)));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.equalTo(@(kWidth(14)));
        make.height.equalTo(@(kWidth(7)));

    }];
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = kHexColor(@"#E3E3E3");
    [self.bgImage addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.typeLab.mas_bottom).offset(18);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    self.typechange = [[UILabel alloc] init];
    
    self.typechange.text = [LangSwitcher switchLang:@"客户端" key:nil];
    self.typechange.textAlignment = NSTextAlignmentLeft;
    //    self.historyLable.userInteractionEnabled = YES;
    self.typechange.font = Font(14);
    self.typechange.userInteractionEnabled = YES;
    self.typechange.textColor = kTextColor;
    [self.bgImage addSubview:self.typechange];
    [self.typechange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeButton.mas_centerY);
        make.right.equalTo(self.typeButton.mas_left).offset(-15);
    }];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(history)];
        [self.typechange addGestureRecognizer:ta];
//    return;

    self.Qintroduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.Qintroduce.text = [LangSwitcher switchLang:@"问题描述(必填)" key:nil];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.bgImage addSubview:self.Qintroduce];
    
    [self.Qintroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab.mas_bottom).offset(30);
        make.left.equalTo(self.bgImage.mas_left).offset(15);
    }];
 
    TLTextView *textView = [[TLTextView alloc] initWithFrame:CGRectMake(15, kHeight(159), kScreenWidth - 30, 100)];
    textView.userInteractionEnabled = YES;
    textView.returnKeyType = UIReturnKeyDone;
    
//    textView.delegate = self;
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
//    [textView addGestureRecognizer:tap1];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
//    [textView addGestureRecognizer:tap];
    self.textView = textView;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kHexColor(@"#E3E3E3");
    lineView.frame = CGRectMake(15, textView.yy+5, kScreenWidth - 30, 0.5);
    [self.bgImage addSubview:lineView];
    textView.backgroundColor = kHexColor(@"#FFFFFF");
    textView.textColor = kTextColor;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placholder = [LangSwitcher switchLang:@"请详细描述一下问题" key:nil];
    [self.bgImage addSubview:self.textView];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.Qintroduce.mas_bottom).offset(10);
//        make.left.equalTo(self.bgImage.mas_left).offset(15);
//        make.right.equalTo(self.bgImage.mas_right).offset(-15);
//        make.height.equalTo(@(kHeight(100)));
//
//
//    }];
    
    UILabel *refLab = [[UILabel alloc] initWithFrame:CGRectMake(15, textView.yy+10, kScreenWidth - 30, 22)];
    refLab.text = [LangSwitcher switchLang:@"复现步骤（必填)" key:nil];
    refLab.textColor = kTextColor3;
    refLab.font = [UIFont systemFontOfSize:14];
    [self.bgImage addSubview:refLab];
    
    TLTextView *reproductionView = [[TLTextView alloc] initWithFrame:CGRectMake(15, refLab.yy+10, kScreenWidth - 30, 100)];
   
    reproductionView.userInteractionEnabled = YES;
    reproductionView.returnKeyType = UIReturnKeyDone;
//    reproductionView.delegate = self;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdits)];
//    [reproductionView addGestureRecognizer:tap];
//    [reproductionView addTarget:self action:@selector(done) forControlEvents:UIControlEventEditingDidEndOnExit];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(end)];
//        [textView addGestureRecognizer:tap];
    self.reproductionView = reproductionView;
    reproductionView.backgroundColor = kHexColor(@"#FFFFFF");
    reproductionView.textColor = kTextColor;
    reproductionView.font = [UIFont systemFontOfSize:14];
    reproductionView.placholder = [LangSwitcher switchLang:@"请填写复现步骤" key:nil];
    [self.bgImage addSubview:self.reproductionView];
//    [self.reproductionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.Qintroduce.mas_bottom).offset(10);
//        make.left.equalTo(self.bgImage.mas_left).offset(15);
//        make.right.equalTo(self.bgImage.mas_right).offset(-15);
//        make.height.equalTo(@(kHeight(100)));
//
//
//    }];
    
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = kHexColor(@"#E3E3E3");
    lineView1.frame = CGRectMake(15, reproductionView.yy+2, kScreenWidth - 30, 0.5);
    [self.bgImage addSubview:lineView1];
}

- (void)beginEdit
{
    
    self.textView.placholder = nil;
    [self.view endEditing:YES];
    [self.textView becomeFirstResponder];
}

- (void)beginEdits
{
    
    self.reproductionView.placholder = nil;
        [self.view endEditing:YES];
    
    [self.reproductionView becomeFirstResponder];
}

- (void)done
{
    
    [self.view endEditing:YES];
    
}

- (void)history
{
    NSLog(@"点击历史");
    [self.filterPicker show];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self done];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
//- (void)beginEdit
//{
////    [self.textView becomeFirstResponder];
//    [self.view endEditing:YES];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    [self.reproductionView resignFirstResponder];
    [self.view endEditing:YES];
    
}

- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)historyClick
{
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
