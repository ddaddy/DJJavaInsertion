//
//  DJJavaProcessFunction.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaProcessFunction.h"
#import "DJJavaFunction_Complete.h"
#import "DJJavaFunction_NSLog.h"
#import "DJJavaFunction_UIAlert.h"
#import "DJJavaFunction_NSUserDefaults.h"
#import "DJJavaFunction_ThrowError.h"

@interface DJJavaProcessFunction () <DJJavaFunctionDelegate>
@property (nonatomic, strong)   NSString*                           functionName;
@property (nonatomic)           int                                 callbackId;
@property (nonatomic, strong)   NSArray*                            args;
@property (nonatomic, weak)     id<DJJavaProcessFunctionDelegate>   delegate;
@property (nonatomic, strong)   DJJavaFunction*                     function;
@end

@implementation DJJavaProcessFunction

+(instancetype)javafunctionWithName:(NSString *)functionName
                         callbackId:(int)callbackId
                               args:(NSArray *)args
                           delegate:(id<DJJavaProcessFunctionDelegate>)delegate
{
    DJJavaProcessFunction *newJavaFunction = [[DJJavaProcessFunction alloc] init];
    newJavaFunction.functionName = functionName;
    newJavaFunction.callbackId = callbackId;
    newJavaFunction.args = args;
    newJavaFunction.delegate = delegate;
    
    return newJavaFunction;
}

/**
 * Implement all your native functions in this one, by matching 'functionName and parsing 'args'
 * @param functionName Name of objective-c function to call
 * @param callbackId int to use with -returnResult when you get some results to send back to javascript
 * @param args Arguments to pass into objective-c function
 */
- (void)processFunction
{
    if (_functionName == nil || [_functionName isEqualToString:@""])
    {
        // Invalid, but might have a callbackId
        NSLog(@"Error - No function to call. Trying callbackId: %i", _callbackId);
        [self returnResult:_callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[@"ERROR:Invalid function"]];
    }
    else if ([DJJavaFunction_NSLog isFunction:_functionName])
    {
        self.function = [DJJavaFunction_NSLog processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else if ([DJJavaFunction_NSUserDefaultsWrite isFunction:_functionName])
    {
        self.function = [DJJavaFunction_NSUserDefaultsWrite processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else if ([DJJavaFunction_NSUserDefaultsRead isFunction:_functionName])
    {
        self.function = [DJJavaFunction_NSUserDefaultsRead processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else if ([DJJavaFunction_NSUserDefaultsDelete isFunction:_functionName])
    {
        self.function = [DJJavaFunction_NSUserDefaultsDelete processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else if ([DJJavaFunction_UIAlert isFunction:_functionName])
    {
        self.function = [DJJavaFunction_UIAlert processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else if ([DJJavaFunction_Complete isFunction:_functionName])
    {
        self.function = [DJJavaFunction_Complete processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else if ([DJJavaFunction_ThrowError isFunction:_functionName])
    {
        self.function = [DJJavaFunction_ThrowError processFunctionWithArgs:_args callbackId:_callbackId delegate:self];
    }
    else
    {
        NSLog(@"Unimplemented method '%@'", _functionName);
        // Invalid, but might have a callbackId
        [self returnResult:_callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[[NSString stringWithFormat:@"ERROR:Unimplemented method: %@", _functionName]]];
    }
    
    // Call the given selector
    // TODO: Add a function to handle this
    //        [self performSelector:NSSelectorFromString(functionName)];
}

#pragma mark - Callback

- (void)returnResult:(int)callbackId
              reason:(DJJavaInsertionCompletedReason)reason
                args:(NSArray *)args
{
    if ((!callbackId || callbackId == 0) && reason != DJJavaInsertionCompleted_JSCompleteCall && reason != DJJavaInsertionCompleted_JSThrewError)
    {
        // No callbackId or no more callbacks, so end here.
        [self returnResultAfterDelay:@[@(DJJavaInsertionCompleted_NoMoreFunctions)]];
        
        return;
    }
    
    if (!args)
    {
        args = @[];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:nil];
    NSString *resultArrayString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"Return callbackId: %i args: %@", callbackId, resultArrayString);
    
    // We need to perform selector with afterDelay 0 in order to avoid weird recursion stop
    // when calling NativeBridge in a recursion more then 200 times :s (fails ont 201th calls!!!)
    if (callbackId != 0)
    {
        resultArrayString = [NSString stringWithFormat:@"NativeBridge.resultForCallback(%d,%@);",callbackId,resultArrayString];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self returnResultAfterDelay:@[@(reason),
                                       resultArrayString]];
    });
}

-(void)returnResultAfterDelay:(NSArray*)results
{
    if ([self.delegate respondsToSelector:@selector(returnResult:reason:)])
    {
        [self.delegate returnResult:(results.count>1?results[1]:nil) reason:[results[0] integerValue]];
    }
}


@end
