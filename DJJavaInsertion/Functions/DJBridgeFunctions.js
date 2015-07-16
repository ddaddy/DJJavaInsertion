/**
 * logToXcode
 * Log a string to the Xcode console using NSLog()
 * @param log The string to log to the console
 * callback - A callback function to perform when complete (optional)
 */
function logToXcode(log, callback) 
{
    NativeBridge.call('logToXcode', [log], callback);
}

/**
 * setUserDefaultsStringForKey
 * Store a string in NSUserDefaults
 * The string is retrieved and double checked that it matches
 * @param string The string you want to store
 * @param key The key used to store the string
 * @param callback A callback function to perform when complete (optional)
 * @return BOOL in callback - Whether the retrieved string matches the stored string
 */
function setUserDefaultsStringForKey(string, key, callback)
{
	NativeBridge.call('setUserDefaultsStringForKey', [string, key], callback);
}

/**
 * readUserDefaultsForKey
 * Read a string from NSUserDefaults
 * @param key The key for the store
 * @param callback A callback function to perform when complete (optional)
 * @return NSString in callback - The string retrieved from the key store
 */
function readUserDefaultsForKey(key, callback)
{
	NativeBridge.call('readUserDefaultsForKey', [key], callback);
}

/**
 * deleteUserDefaultsForKey
 * Delete an object from NSUserDefaults
 * @param key The key for the store to delete
 * @param callback A callback function to perform when complete (optional)
 * @return Nothing
 */
function deleteUserDefaultsForKey(key, callback)
{
    NativeBridge.call('deleteUserDefaultsStringForKey', [key], callback);
}

/**
 * showAlert
 * Display either a UIAlertView or UIAlertController (Depending on iOS version)
 * @param title The title to display
 * @param message The message to display
 * @param buttons An array of buttons for the alert. You must have at least 1 button or the alert cannot be dismissed.
 * @param inputField A dictionary containing keys 'placeholder' & 'text'. 'text' is optional.
 * @param callback A callback function to perform when complete (optional)
 * @return 2xNSString callback will contain the button title that was pressed and any text entered into textField.
 */
function showAlert(title, message, buttons, inputField, callback)
{
    NativeBridge.call('showAlert', [title||'', message||'', buttons||[], inputField], callback);
}

/**
 * complete
 * Signifies to Objective-C that you are finished which then fires the completionBlock in Objective-C
 @ param string A final string that you want to pass back to the completion block.
 */
function complete(string)
{
	NativeBridge.call('complete', [string]);
}