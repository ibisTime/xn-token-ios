//
//  TheInitialVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TheInitialVC.h"
#import "TheInitialView.h"
#import "RegisterVC.h"
@interface TheInitialVC ()<TheInitialViewBtnDelegate>



@end

@implementation TheInitialVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TheInitialView * initialView = [[TheInitialView alloc]initWithFrame:CGRectMake(0, -kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT +  kStatusBarHeight)];
    initialView.delegate = self;
    [self.view addSubview:initialView];
}


-(void)TheInitialViewBtnClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            RegisterVC *vc = [[RegisterVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
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
