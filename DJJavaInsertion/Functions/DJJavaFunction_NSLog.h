//
//  DJJavaFunction_NSLog.h
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction.h"

@interface DJJavaFunction_NSLog : DJJavaFunction

/**
 * Log a string to the Xcode console
 * @param string The string to log to the console
 * @param callbackId The callbackId to fire once completed
 */
- (void)logToXcode:(NSString *)string
        callbackId:(int)callbackId;

@end
