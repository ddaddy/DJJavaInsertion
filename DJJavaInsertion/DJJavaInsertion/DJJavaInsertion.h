//
//  InsertionWebView.h
//  JavaInsertionTest
//
//  Created by Darren Jones on 06/07/2015.
//  Copyright (c) 2015 Testing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJJavaProcessFunction.h"

typedef void (^DJJavaInsertionBlock)(DJJavaInsertionCompletedReason completionReason, NSString *jsonresult);

@interface DJJavaInsertion : UIWebView

/**
 * Here you are inserting your full html page.
 * This should contain all your javascript in the header.
 * @param html Full web page
 * @param baseURL You can specify a base URL if your script imports other scripts that you ship with the bundle
 * @param startFunction If the webView is hidden to just perform operations, pass in the name of the initial java function to begin ie. @"start()"
 * @param completionBlock The completion bloack is called after EVERY JS function is complete. It is passed a completionReason and is only fully complete if you receive DJJavaInsertionCompleted_NoMoreFunctions or DJJavaInsertionCompleted_JSCompleteCall
 */
- (void)startWithHtml:(NSString *)html
              baseURL:(NSURL *)baseURL
        startFunction:(NSString *)startFunction
      completionBlock:(DJJavaInsertionBlock)completionBlock;

@end
