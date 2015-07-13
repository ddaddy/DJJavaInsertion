//
//  ViewController.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "ViewController.h"
#import "DJJavaInsertion.h"

@interface ViewController ()
// You must keep a strong reference to DJJavaInsertion as they can easily dealloc before completion.
@property (nonatomic, strong) DJJavaInsertion *webView;
@end

@implementation ViewController

/**
 * The idea here is to create a web page that will be loaded initially.
 * Then subsequently call different javascript methods on it.
 * This is simply an NSString that you can replace with a new version from an external server on app launch which is what makes your app dynamic.
 */
- (NSString *)javaScript
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Uncomment for an example how we can override the html with new scripts, whilst still using the pre-defined scripts shipped with the app.
    //    html = @"<html><head><script type='text/javascript' src='NativeBridge.js'></script><script type='text/javascript' src='webview-script.js'></script><script>// Attempt at overriding start()\nfunction start() {alert('start override');logToXcode('Hello World!');}</script></head><body style='background-color:transparent; color:white;'><h4>Hello World!</h4></body></html>";
    
    return html;
}

/**
 * Start the test. This will initially load the page defined by -javaScript, then run the start() function.
 */
- (IBAction)startJavaInsertion:(id)sender
{
    // We MUST keep a strong reference to the web view, or it will be immediately deallocated.
    self.webView = [[DJJavaInsertion alloc] init];
    
    NSString *startFunction = [NSString stringWithFormat:@"start('%@')", @"Some text to pass to JS"];
    NSLog(@"Start function: %@", startFunction);
    
    // Pass in our HTML page. If we set baseURL as our app bundle, we can keep NativeBridge.js seperate in the bundle to reduce any server load if updating the scripts and use <script type="text/javascript" src="NativeBridge.js"></script> in our HTML to import it.
    [self.webView startWithHtml:[self javaScript]
                        baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
                  startFunction:startFunction
                completionBlock:^(DJJavaInsertionCompletedReason completionReason, NSString* jsonresult)
     {
         NSLog(@"COMPLETION BLOCK. Reason: %li : Result: %@", completionReason, jsonresult);
         
         switch (completionReason)
         {
             case DJJavaInsertionCompleted_NoMoreFunctions:
             case DJJavaInsertionCompleted_JSCompleteCall:
             {
                 _webView = nil;
                 NSLog(@"JavaScript has completed running with string: %@", jsonresult);
             }
                 break;
                 
             case DJJavaInsertionCompleted_FunctionComplete:
             default:
                 break;
         }
     }];
}

@end
