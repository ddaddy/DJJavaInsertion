//
//  InsertionWebView.m
//  JavaInsertionTest
//
//  Created by Darren Jones on 06/07/2015.
//  Copyright (c) 2015 Testing. All rights reserved.
//

#import "DJJavaInsertion.h"

@interface DJJavaInsertion () <UIWebViewDelegate, DJJavaProcessFunctionDelegate>
@property (nonatomic, strong) DJJavaInsertionBlock completionBlock;
@property (nonatomic, strong) DJJavaProcessFunction *function;
@end

@implementation DJJavaInsertion
{
    NSString        *_startFunction;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Set delegate in order for "shouldStartLoadWithRequest" to be called
    self.delegate = self;
    
    // Set non-opaque in order to make "body{background-color:transparent}" working!
    self.opaque = NO;
}

-(void)startWithHtml:(NSString *)html
             baseURL:(NSURL *)baseURL
       startFunction:(NSString *)startFunction
     completionBlock:(DJJavaInsertionBlock)completionBlock
{
    if (html)
    {
        _startFunction = startFunction;
        _completionBlock = completionBlock;
        
        // Load our html/javascript.
        [self loadHTMLString:html baseURL:baseURL];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    /**
     * objc-funct: url's are objective-c functions to call
     * paramaters are seperated by : and must be in the correct order
     * @param function The function name you want to call
     * @param callbackId Javascript function that is to be called on completion of calling the objective-c function
     * @param argsAsString JSON array of arguments to pass to the objective-c function
     */
    // URL.scheme seems to always be lowercase, so compare both as lowercase to make sure.
    if ([[requestString lowercaseString] hasPrefix:[@"objc-funct:" lowercaseString]])
    {
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        
        NSString *function = (NSString *)[components objectAtIndex:1];
        int callbackId = [((NSString *)[components objectAtIndex:2]) intValue];
        NSString *argsAsString = [(NSString *)[components objectAtIndex:3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // Convert to an array
        NSError *error;
        NSData *objectData = [argsAsString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *args = [NSJSONSerialization JSONObjectWithData:objectData
                                                        options:kNilOptions
                                                          error:&error];
        if (error) NSLog(@"%@", error);
        
//        NSLog(@"shouldStartLoadWithRequest - function: %@ callbackId: %i args: %@", function, callbackId, args);
        
        [self handleCall:function callbackId:callbackId args:args];
        
        return NO;
    }
    
    // Ignore legit webview requests so they load normally.
    // This also loads the initial page completely.
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"%@", [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]);
    
    // Start the scripts now they are fully loaded.
    if (_startFunction)
    {
        [webView stringByEvaluatingJavaScriptFromString:_startFunction];
    }
}

- (void)handleCall:(NSString *)functionName callbackId:(int)callbackId args:(NSArray *)args
{
    self.function = [DJJavaProcessFunction javafunctionWithName:functionName
                                                     callbackId:callbackId
                                                           args:args
                                                       delegate:self];
    [self.function processFunction];
}

#pragma mark - Callback

- (void)returnResult:(NSString *)result reason:(DJJavaInsertionCompletedReason)reason
{
    self.function = nil;
    
    switch (reason)
    {
        case DJJavaInsertionCompleted_FunctionComplete:
        {
            // Now perform this selector with waitUntilDone:NO in order to get a huge speed boost! (about 3x faster on simulator!!!)
            [self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:result waitUntilDone:NO];
        }
            break;
            
        case DJJavaInsertionCompleted_NoMoreFunctions:
        case DJJavaInsertionCompleted_JSCompleteCall:
        case DJJavaInsertionCompleted_JSThrewError:
        default:
            break;
    }
    
    if (self.completionBlock)
    {
        self.completionBlock(reason, result);
    }
}


@end
