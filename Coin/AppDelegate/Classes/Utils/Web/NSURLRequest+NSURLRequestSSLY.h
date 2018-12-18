//
//  NSURLRequest+NSURLRequestSSLY.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/18.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NSURLRequestSSLY)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end
