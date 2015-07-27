//
//  DJJavaFunction_ThrowError.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 16/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction_ThrowError.h"

@implementation DJJavaFunction_ThrowError

+ (NSString *)functionName
{
    return @"throwError";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_ThrowError *func = [[DJJavaFunction_ThrowError alloc] init];
    func.delegate = delegate;
    
    if ([args count] != 2)
    {
        NSString *error = [self errorWithDescription:@"Invalid number of arguments" functionName:[self functionName] code:9991];
        [func returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[error]];
        
        return nil;
    }
    
    int code = [args[0] intValue];
    NSString *description = args[1];
    
    [func throwErrorWithCode:code description:description];
    
    return func;
}

- (void)throwErrorWithCode:(int)code description:(NSString *)description
{
    [self returnResult:0 reason:DJJavaInsertionCompleted_JSThrewError args:@[@(code), description]];
}

@end
