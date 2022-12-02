//
//  ANSVisualRegular.m
//  AnalysysVisual
//
//  Created by xiao xu on 2020/3/30.
//  Copyright © 2020 shaochong du. All rights reserved.
//

#import "ANSVisualRegular.h"

@implementation ANSVisualRegular

+ (NSArray<NSString *> *)regularExtract:(NSString *)regex checkString:(NSString *)checkString {
    if (!checkString) {
        return nil;
    }
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&error];
    NSTextCheckingResult *result =
    [regularExpression firstMatchInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0; i < [result numberOfRanges]; i++) {
        NSString *matchString;
        
        NSRange range = [result rangeAtIndex:i];
        
        if (range.location != NSNotFound) {
            matchString = [checkString substringWithRange:[result rangeAtIndex:i]];
        } else {
            matchString = @"";
        }
        [arr addObject:matchString];
    }
    
    return [arr copy];
}
@end
