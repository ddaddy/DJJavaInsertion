//
//  DJJavaFunction.h
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DJJavaInsertionCompletedReason : NSUInteger
{
    DJJavaInsertionCompleted_FunctionComplete       = 0,
    DJJavaInsertionCompleted_NoMoreFunctions        = 1,
    DJJavaInsertionCompleted_JSCompleteCall         = 2,
    DJJavaInsertionCompleted_JSThrewError           = 3
} DJJavaInsertionCompletedReason;

@protocol DJJavaFunctionDelegate <NSObject>
- (void)returnResult:(int)callbackId
              reason:(DJJavaInsertionCompletedReason)reason
                args:(NSArray *)args;
@end

@interface DJJavaFunction : NSObject

@property (nonatomic, weak)     id<DJJavaFunctionDelegate>   delegate;

+ (BOOL)isFunction:(NSString *)functionName;

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate;

+ (NSString *)errorWithDescription:(NSString *)errorDescription functionName:(NSString *)functionName code:(NSInteger)code;

#pragma mark - Private

/**
 * This function is only called by category extensions of this class to pass back any results.
 * @param callbackId int comes from handleCall function
 * @param args list of objects to send to the javascript callback with a nil terminator.
 */
- (void)returnResult:(int)callbackId
              reason:(DJJavaInsertionCompletedReason)reason
                args:(NSArray *)args;

@end
