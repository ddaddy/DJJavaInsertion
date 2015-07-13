//
//  DJJaveFunction_UIAlert.h
//  DJJavaInsertion
//
//  Created by Darren Jones on 13/07/2015.
//  Copyright (c) 2015 Darren Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJJavaFunction.h"

static const NSString * DJ_UIAlert_Field_Placeholder    = @"placeholder";
static const NSString * DJ_UIAlert_Fiels_Text           = @"text";

@interface DJJavaFunction_UIAlert : DJJavaFunction <UIAlertViewDelegate>

/**
 * Display either a UIAlertView or UIAlertController (Depending on iOS version)
 * @param title The title to display
 * @param message The message to display
 * @param buttons An array of buttons for the alert. You must have at least 1 button or the alert cannot be dismissed.
 * @param inputField A dictionary containing keys DJ_UIAlert_Field_Placeholder & DJ_UIAlert_Fiels_Text. DJ_UIAlert_Fiels_Text is optional.
 * @param callbackId The callbackId to fire once completed
 * @return 2xNSStrings callback will contain the button title that was pressed and any text entered into textField.
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
                inputField:(NSDictionary *)inputField
                callbackId:(int)callbackId;

@end
