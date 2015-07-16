//
//  DJJavaFunction_NSUserDefaults.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction_NSUserDefaults.h"

@implementation DJJavaFunction_NSUserDefaultsRead

+ (NSString *)functionName
{
    return @"readUserDefaultsForKey";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_NSUserDefaultsRead *func = [[DJJavaFunction_NSUserDefaultsRead alloc] init];
    func.delegate = delegate;
    
    if ([args count] != 1)
    {
        NSString *errorStr = [NSString stringWithFormat:@"ERROR:%@-Invalid number of arguments", [self functionName]];
        
        [func returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[errorStr]];
        
        return nil;
    }
    
    NSString *key = args[0];
    
    [func readUserDefaultsForKey:key callbackId:callbackId];
    
    return func;
}

- (void)readUserDefaultsForKey:(NSString *)key
                    callbackId:(int)callbackId
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // Callback
    [self returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:object?@[object]:nil];
}

@end

@implementation DJJavaFunction_NSUserDefaultsWrite

+ (NSString *)functionName
{
    return @"setUserDefaultsStringForKey";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_NSUserDefaultsWrite *func = [[DJJavaFunction_NSUserDefaultsWrite alloc] init];
    func.delegate = delegate;
    
    if ([args count] != 2)
    {
        NSString *errorStr = [NSString stringWithFormat:@"ERROR:%@-Invalid number of arguments", [self functionName]];
        
        [func returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[errorStr]];
        
        return nil;
    }
    
    NSString *string = args[0];
    NSString *key = args[1];
    
    [func setUserDefaultsString:string forKey:key callbackId:callbackId];
    
    return func;
}

- (void)setUserDefaultsString:(NSString *)string
                       forKey:(NSString *)key
                   callbackId:(int)callbackId
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Check if it stored ok
    BOOL success = NO;
    id testString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([testString isEqualToString:string])
    {
        success = YES;
    }
    
    // Callback
    [self returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[@(success)]];
}

@end

@implementation DJJavaFunction_NSUserDefaultsDelete

+ (NSString *)functionName
{
    return @"deleteUserDefaultsStringForKey";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_NSUserDefaultsDelete *func = [[DJJavaFunction_NSUserDefaultsDelete alloc] init];
    func.delegate = delegate;
    
    if ([args count] != 1)
    {
        NSString *errorStr = [NSString stringWithFormat:@"ERROR:%@-Invalid number of arguments", [self functionName]];
        
        [func returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[errorStr]];
        
        return nil;
    }
    
    NSString *key = args[0];
    
    [func deleteUserDefaultsForKey:key callbackId:callbackId];
    
    return func;
}

- (void)deleteUserDefaultsForKey:(NSString *)key
                      callbackId:(int)callbackId
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Callback
    [self returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[]];
}

@end
