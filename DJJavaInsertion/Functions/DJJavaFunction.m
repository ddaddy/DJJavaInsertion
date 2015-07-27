//
//  DJJavaFunction.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction.h"

@implementation DJJavaFunction

+ (NSString *)functionName
{
    return nil;
}

+ (BOOL)isFunction:(NSString *)functionName
{
    return [[[self functionName] lowercaseString] isEqualToString:[functionName lowercaseString]];
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    return nil;
}

+ (NSString *)errorWithDescription:(NSString *)errorDescription functionName:(NSString *)functionName code:(NSInteger)code
{
    return [NSString stringWithFormat:@"ERROR:%@-%@ CODE:%li", functionName, errorDescription, (long)code];
}

- (void)returnResult:(int)callbackId
              reason:(DJJavaInsertionCompletedReason)reason
                args:(NSArray *)args
{
    if ([self.delegate respondsToSelector:@selector(returnResult:reason:args:)])
    {
        [self.delegate returnResult:callbackId reason:reason args:args];
    }
}

@end
