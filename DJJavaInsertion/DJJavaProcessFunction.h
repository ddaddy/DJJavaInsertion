//
//  DJJavaProcessFunction.h
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJJavaFunction.h"

@protocol DJJavaProcessFunctionDelegate <NSObject>
- (void)returnResult:(NSString *)result reason:(DJJavaInsertionCompletedReason)reason;
@end

@interface DJJavaProcessFunction : NSObject

/**
 * Initiate a DJJavaFunction using this method. Be sure to keep a strong reference to it and set to nil in the returnResult delegate callback
 * @param functionName The corresponding name of the function to be called
 * @param callbackId The callbackId to call once completed
 * @param args Arguments to pass to the function
 * @param delegate DJJavaFunctionDelegate that will receive the returnResult callback
 * @return DJJavaFunction You must keep a string pointer to this until returnResult is called, where you must then set to nil
 */
+ (instancetype)javafunctionWithName:(NSString *)functionName
                          callbackId:(int)callbackId
                                args:(NSArray *)args
                            delegate:(id<DJJavaProcessFunctionDelegate>)delegate;

/**
 * You must run processFunction on your DJJavaFunction object to kick start the function
 * and wait for the returnResult call back.
 */
- (void)processFunction;


@end
