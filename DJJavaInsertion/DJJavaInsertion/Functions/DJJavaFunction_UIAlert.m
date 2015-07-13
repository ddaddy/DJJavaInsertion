//
//  DJJaveFunction_UIAlert.m
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import "DJJavaFunction_UIAlert.h"

static int _alertCallbackId;

@implementation DJJavaFunction_UIAlert

+ (NSString *)functionName
{
    return @"showAlert";
}

+ (instancetype)processFunctionWithArgs:(NSArray *)args callbackId:(int)callbackId delegate:(id<DJJavaFunctionDelegate>)delegate
{
    DJJavaFunction_UIAlert *func = [[DJJavaFunction_UIAlert alloc] init];
    func.delegate = delegate;
    
    if ([args count]!=4)
    {
        NSString *errorStr = [NSString stringWithFormat:@"ERROR:%@-Invalid number of arguments", [self functionName]];
        
        [func returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[errorStr]];
        
        return nil;
    }
    
    NSString *title = args[0];
    NSString *message = args[1];
    id buttons = args[2];
    id inputField = args[3];
    
    // If we just have 1 string for buttons, change it to an array.
    if ([buttons isKindOfClass:[NSString class]])
    {
        buttons = @[buttons];
    }
    
    if (inputField == (id)[NSNull null])
    {
        inputField = nil;
    }
    else if ([inputField isKindOfClass:[NSString class]])
    {
        // inputField is just a string
        inputField = @{DJ_UIAlert_Field_Placeholder : inputField,
                       DJ_UIAlert_Fiels_Text : @""};
    }
    else if ([inputField isKindOfClass:[NSDictionary class]])
    {
        // Input field is already a dictionary
    }
    
//    DJJavaFunction_UIAlert *func = [[DJJavaFunction_UIAlert alloc] init];
    [func showAlertWithTitle:title message:message buttons:buttons inputField:inputField callbackId:callbackId];
    
    return func;
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
                inputField:(NSDictionary *)inputField
                callbackId:(int)callbackId
{
    if (buttons.count == 0)
    {
        [self returnResult:callbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[@"ERROR:No buttons to display on alert"]];
        return;
    }
    
    _alertCallbackId = callbackId;
    
    if (NSClassFromString(@"UIAlertController"))
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        __weak UIAlertController *weakAlertRef = alertController;
        
        // Add the buttons
        for (NSString *btn in buttons)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:btn
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action)
                                        {
                                            // Button pressed
                                            if (_alertCallbackId != -1)
                                            {
                                                // iOS 9 beta1 crash if index beyond bounds of array. Worked fine in iOS 8 without initial count.
                                                NSString *text = nil;
                                                if ([weakAlertRef.textFields count] > 0)
                                                {
                                                    text = ((UITextField *)[weakAlertRef.textFields objectAtIndex:0]).text;
                                                }
                                                
                                                [self returnResult:_alertCallbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[btn, text ? : @""]];
                                            }
                                        }]];
        }
        
        if (inputField)
        {
            // Add user input field
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
             {
                 textField.placeholder = inputField[DJ_UIAlert_Field_Placeholder];
                 textField.text = inputField[DJ_UIAlert_Fiels_Text];
             }];
        }
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        // Add the buttons
        for (NSString *btn in buttons)
        {
            [alert addButtonWithTitle:btn];
        }
        
        // Add text field
        if (!inputField)
        {
            alert.alertViewStyle = UIAlertViewStyleDefault;
        }
        else
        {
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            UITextField *textField = [alert textFieldAtIndex:0];
            textField.placeholder = inputField[DJ_UIAlert_Field_Placeholder];
            textField.text = inputField[DJ_UIAlert_Fiels_Text];
        }
        
        alert.delegate = self;
        alert.tag = 44;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_alertCallbackId == -1) return;
    
    if (alertView.tag == 44)
    {
        NSString *btnPressed = [alertView buttonTitleAtIndex:buttonIndex];
        
        NSString *enteredText = @"";
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            enteredText = textField.text;
        }
        
        [self returnResult:_alertCallbackId reason:DJJavaInsertionCompleted_FunctionComplete args:@[btnPressed, enteredText]];
        
        _alertCallbackId = -1;
    }
}

@end
