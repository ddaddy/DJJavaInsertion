[![GitHub issues](https://img.shields.io/github/issues/ddaddy/DJJavaInsertion.svg)](https://github.com/ddaddy/DJJavaInsertion/issues)
[![GitHub stars](https://img.shields.io/github/stars/ddaddy/DJJavaInsertion.svg)](https://github.com/ddaddy/DJJavaInsertion/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ddaddy/DJJavaInsertion.svg)](https://github.com/ddaddy/DJJavaInsertion/network)

# DJJavaInsertion
Use javascript to run native iOS code. Inspired by [NativeBridge](https://github.com/ochameau/NativeBridge).
`DJJavaInsertion` allows you to run parts of your application from JavaScript allowing you to dynamically change the JavaScript which can let you modify the behaviour of an app without having to wait for the Apple approval process.
 Eg. Say you have some network calls that could possibly change in the future. Pass them through `DJJavaInsertion` and implment a way to dynamically update your html that contains the JavaScript. Allowing you to change the network calls without needing to update your app.

## Installation
- Add the `DJInsertionFolder` to your project
- Create a `.html` file with your JavaScript in it's header (Or simply use an NSString). Be sure to add the DJNativeBridge.js & DJBridgeFunctions.js scripts in the header (See test.html for an example)
- `#import "DJJavaInsertion.h"` wherever you need to use it
- You must use a `strong` reference to a `DJJavaInsertion` instance
- Start your JavaScript code by passing in your html and starting JavaScript function.
```
// We MUST keep a strong reference to the web view, or it will be immediately deallocated.
self.webView = [[DJJavaInsertion alloc] init];
    
NSString *startFunction = [NSString stringWithFormat:@"start('%@')", @"Some text to pass to JS"];
    
// Pass in our HTML page. If we set baseURL as our app bundle, we can keep NativeBridge.js seperate in the bundle to reduce any server load if updating the scripts and use <script type="text/javascript" src="NativeBridge.js"></script> in our HTML to import it.
[self.webView startWithHtml:[self javaScript]
                    baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
              startFunction:startFunction
            completionBlock:^(DJJavaInsertionCompletedReason completionReason, NSString* jsonresult)
 {
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
```

## Currently supported iOS functions

- NSLog
- UIAlertView/UIAlertController
- NSUserDefaults Read/Write

## Expand functionality

- Subclass `DJJavaFunction` and override `+functionName` with the string that will be used in JS (See DJBridgeFunctions.js)
- Override `+(instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate`
- Call `[self returnResult:reason:args]` when function is complete
- Add your new function to `DJJavaProcessFunction -processFunction` method

## Please send pull requests for any changes, improvements, functions.