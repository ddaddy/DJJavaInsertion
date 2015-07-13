//
//  DJJavaFunction_Complete.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction_Complete.h"

@implementation DJJavaFunction_Complete

+ (NSString *)functionName
{
    return @"complete";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_Complete *func = [[DJJavaFunction_Complete alloc] init];
    func.delegate = delegate;
    
    NSString *string = nil;
    if (args.count > 0)
    {
        string = args[0];
    }
    
    [func returnResult:0 reason:DJJavaInsertionCompleted_JSCompleteCall args:@[string]];
    
    return func;
}

@end
