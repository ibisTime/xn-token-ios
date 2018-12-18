//
//  NSURLRequest+NSURLRequestSSLY.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/18.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "NSURLRequest+NSURLRequestSSLY.h"

@implementation NSURLRequest (NSURLRequestSSLY)


+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{
    
    
}

@end
