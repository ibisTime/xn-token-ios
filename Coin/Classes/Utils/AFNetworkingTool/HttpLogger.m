//
//  HttpLogger.m
//  AFNetworkingTool
//
//  Created by 蔡卓越 on 15/11/15.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "HttpLogger.h"

@implementation HttpLogger

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName requestParams:(id)requestParams httpMethod:(NSString *)httpMethod
{
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", apiName];
    [logString appendFormat:@"Method:\t\t\t%@\n", httpMethod];
    [logString appendFormat:@"Params:\n%@", requestParams];
    [logString appendString:[self appendURLRequest:request]];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
    
#endif
}

+ (void)logDebugInfoWithResponse:(NSURLResponse *)response apiName:(NSString *)apiName resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
#ifdef DEBUG
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       API Response                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", apiName];
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    [logString appendString:[self appendURLRequest:request]];
    [logString appendFormat:@"\n\n**************************************************************\n*                         Response End                        *\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
    
    
#endif
}

+ (void)logJSONStringWithResponseObject:(id)responseObject {

#ifdef DEBUG
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", responseString);
    
#endif
}

+ (NSString *)appendURLRequest:(NSURLRequest *)request
{
    NSMutableString *requestUrl = [NSMutableString string];
    [requestUrl appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    return requestUrl;
}



@end
