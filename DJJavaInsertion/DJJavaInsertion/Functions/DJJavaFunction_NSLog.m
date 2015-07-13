//
//  DJJavaFunction_NSLog.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction_NSLog.h"

@implementation DJJavaFunction_NSLog

+ (NSString *)functionName
{
    return @"logToXcode";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_NSLog *func = [[DJJavaFunction_NSLog alloc] init];
    func.delegate = delegate;
    
    if ([args count] != 1)
    {
        NSString *errorStr = [NSString stringWithFormat:@"ERROR:%@-Invalid number of arguments", [self functionName]];
        
        [func returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[errorStr]];
        
        return nil;
    }
    
    NSString *log = args[0];
    
    [func logToXcode:log callbackId:callbackId];
    
    return func;
}

- (void)logToXcode:(NSString *)string
        callbackId:(int)callbackId
{
    // We dump the string to the console
    NSLog(@"%@", string);
    
    // Callback
    [self returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:nil];
}

@end
