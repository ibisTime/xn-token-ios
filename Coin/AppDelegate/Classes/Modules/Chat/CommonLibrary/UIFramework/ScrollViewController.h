//
//  ScrollViewController.h
//  CommonLibrary
//
//  Created by Alexi on 4/2/14.
//  Copyright (c) 2014 Alexi. All rights reserved.
//

#import "IMBaseViewController.h"

@interface ScrollViewController : IMBaseViewController
{
@protected
    UIScrollView *_scrollView;
}

- (void)configContentSize;

@end
