//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "EmojHelper.h"


#pragma mark- EmojInfo

@implementation EmojInfo

@end


#pragma mark- EmojHelper
@interface EmojHelper ()


@property (nonatomic, readonly) NSMutableArray* emojList;

- (void)createEmojiList;
+ (EmojHelper *)shareInstance;

@end



@implementation EmojHelper
static NSArray* emojStrs;
+ (EmojHelper *)shareInstance
{
    static EmojHelper *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[EmojHelper alloc] init];
    });
    return instance;
}

+ (EmojInfo *)emojAtIndex:(NSUInteger)index
{
    return [[EmojHelper shareInstance].emojList objectAtIndex:index];
}

+ (NSInteger)emojCount
{
    return [EmojHelper shareInstance].emojList.count;
}


+ (BOOL)isEmojStr:(NSString *)emojStr
{
//    for(NSInteger i=0; i<emojStrs.count; i++){
//        if ([emojStr isEqualToString:[emojStrs objectAtIndex:i]]) {
//            return YES;
//        }
//    }
    
    const unichar hs = [emojStr characterAtIndex:0];
    // surrogate pair
    BOOL returnValue = NO;
    if (0xd800 <= hs && hs <= 0xdbff)
    {
        if (emojStr.length > 1)
        {
            const unichar ls = [emojStr characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f)
            {
                returnValue = YES;
            }
        }
    }
    else if (emojStr.length > 1)
    {
        const unichar ls = [emojStr characterAtIndex:1];
        if (ls == 0x20e3)
        {
            returnValue = YES;
        }
        
    }
    else
    {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff)
        {
            returnValue = YES;
        }
        else if (0x2B05 <= hs && hs <= 0x2b07)
        {
            returnValue = YES;
        }
        else if (0x2934 <= hs && hs <= 0x2935)
        {
            returnValue = YES;
        }
        else if (0x3297 <= hs && hs <= 0x3299)
        {
            returnValue = YES;
        }
        else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
        {
            returnValue = YES;
        }
    }
    return returnValue;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _emojList = [NSMutableArray arrayWithCapacity:100];
        [self createEmojiList];
    }
    return self;
}

- (void)createEmojiList
{
    if (!emojStrs)
    {
        emojStrs = [NSArray arrayWithObjects:
              @"\U0001f625",
              @"\U0001f60f",
              @"\U0001f614",
              @"\U0001f601",
              @"\U0001f609",
              @"\U0001f631",
              @"\U0001f616",
              @"\U0001f61a",
              @"\U0001f61d",
              @"\U0001f60c",
              @"\U0001f628",
              @"\U0001f637",
              @"\U0001f633",
              @"\U0001f612",
              @"\U0001f630",
              @"\U0001f632",
              @"\U0001f62d",
              @"\U0001f61c",
              @"\U0001f618",
              @"\U0001f621",
              @"\U0001f4aa",
              @"\U0001f44a",
              @"\U0001f44d",
              @"\u261d",
              @"\U0001f44f",
              @"\u270c",
              @"\U0001f44e",
              @"\U0001f64f",
              @"\U0001f44c",
              @"\U0001f448",
              @"\U0001f449",
              @"\U0001f446",
              @"\U0001f447",
              @"\U0001f440",
              @"\U0001f443",
              @"\U0001f444",
              @"\U0001f442",
              @"\U0001f35a",
              @"\U0001f35d",
              @"\U0001f35c",
              @"\U0001f359",
              @"\U0001f367",
              @"\U0001f363",
              @"\U0001f382",
              @"\U0001f35e",
              @"\U0001f354",
              @"\U0001f373",
              @"\U0001f35f",
              @"\U0001f37a",
              @"\U0001f37b",
              @"\U0001f378",
              @"\u2615",
              @"\U0001f34e",
              @"\U0001f34a",
              @"\U0001f353",
              @"\U0001f349",
              @"\U0001f48a",
              @"\U0001f6ac",
              @"\U0001f384",
              @"\U0001f339",
              @"\U0001f389",
              @"\U0001f334",
              @"\U0001f49d",
              @"\U0001f380",
              @"\U0001f388",
              @"\U0001f41a",
              @"\U0001f48d",
              @"\U0001f4a3",
              @"\U0001f451",
              @"\U0001f514",
              @"\u2b50",
              @"\u2728",
              @"\U0001f4a8",
              @"\U0001f4a6",
              @"\U0001f525",
              @"\U0001f3c6",
              @"\U0001f4b0",
              @"\U0001f4a4",
              @"\u26a1",
              @"\U0001f463",
              @"\U0001f4a9",
              @"\U0001f489",
              @"\u2668",
              @"\U0001f4eb",
              @"\U0001f511",
              @"\U0001f512",
              @"\u2708",
              @"\U0001f684",
              @"\U0001f697",
              @"\U0001f6a4",
              @"\U0001f6b2",
              @"\U0001f40e",
              @"\U0001f680",
              @"\U0001f68c",
              @"\u26f5",
              @"\U0001f469",
              @"\U0001f468",
              @"\U0001f467",
              @"\U0001f466",
              @"\U0001f435",
              @"\U0001f419",
              @"\U0001f437",
              @"\U0001f480",
              @"\U0001f424",
              @"\U0001f428",
              @"\U0001f42e",
              @"\U0001f414",
              @"\U0001f438",
              @"\U0001f47b",
              //@"\U0001f480",
              @"\U0001f41b",
              @"\U0001f420",
              @"\U0001f436",
              @"\U0001f42f",
              @"\U0001f47c",
              @"\U0001f427",
              @"\U0001f433",
              @"\U0001f42d",
              @"\U0001f452",
              @"\U0001f457",
              @"\U0001f484",
              @"\U0001f460",
              @"\U0001f462",
              @"\U0001f302",
              @"\U0001f45c",
              @"\U0001f459",
              @"\U0001f455",
              @"\U0001f45f",
              @"\u2601",
              @"\u2600",
              @"\u2614",
              @"\U0001f319",
              @"\u26c4",
              @"\u2b55",
              @"\u274c",
              @"\u2754",
              @"\u2755",
              @"\u260e",
              @"\U0001f4f7",
              @"\U0001f4f1",
              @"\U0001f4e0",
              @"\U0001f4bb",
              @"\U0001f3a5",
              @"\U0001f3a4",
              @"\U0001f52b",
              @"\U0001f4bf",
              @"\U0001f493",
              @"\u2663",
              @"\U0001f004",
              @"\u303d",
              @"\U0001f3b0",
              @"\U0001f6a5",
              @"\U0001f6a7",
              @"\U0001f3b8",
              @"\U0001f488",
              @"\U0001f6c0",
              @"\U0001f6bd",
              @"\U0001f3e0",
              @"\u26ea",
              @"\U0001f3e6",
              @"\U0001f3e5",
              @"\U0001f3e8",
              @"\U0001f3e7",
              @"\U0001f3ea",
              @"\U0001f6b9",
              @"\U0001f6ba",
              nil];
        NSInteger index = 0;
        for(NSString* emjStr in emojStrs)
        {
            EmojInfo* info = [[EmojInfo alloc] init];
            info.index = index++;
            info.emjStr = emjStr;
            [_emojList addObject:info];
        }
    }
    return;
}

@end

    

