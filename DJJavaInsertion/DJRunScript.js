/*
 * start() function is run automatically when this script is loaded.
 * use NativeBridge.call(methodName, paramsArray, callBackFunction) to run objective-c methods whithin app.
 *
 * methodName must be pre-defined in your objective-c code.
 * paramsArray is an array of parameters to pass into your pre-defined objective-c method.
 * callBackFunction is whatever function you want to perform next. Your obj-c method can pass back params.
 *
 */

 var userDefaultsKey = 'testKey';

function start(inputText)
{
    alert('Starting JS with inputText: ' + inputText);
    showiOSAlert();

    // alert('About to nslog to Xcode');
    // logToXcode('Wahoo, we are logging this to xcode using Objective-C from Javascript', function(returnValue)
    // {
    //   error = isError(returnValue);
    //   if (error)
    //   {
    //     alert('We have an error: ' + error);
    //   }
    //   else
    //   {
    //     testDefaultWrite();
    //   }
    // });
}

function showiOSAlert()
{
  var buttons = ['OK', 'Cancel', 'Another button'];
  var textField = {placeholder:'hello placeholder', text:'hello world'};
  // var textField = {};
  showAlert('I am a native iOS UIAlert', 'Enter some text and JS will save it to NSUserDefaults', buttons, textField, function(buttonPressed, enteredText)
  {
    error = isError(buttonPressed);
    if (error)
    {
      alert('JS: We have an error: ' + error);
    }
    else
    {
      alert('JS: You pressed: ' + buttonPressed + ' and typed: ' + enteredText);
    }
    writeToNSUserDefaults(enteredText, userDefaultsKey);
  });
}

function writeToNSUserDefaults(textToStore, key) 
{
  setUserDefaultsStringForKey(textToStore, key, function(success)
  {
    error = isError(success);
    if (error)
    {
      alert('JS: We have an error: ' + error);
    }
    else
    {
      alert('JS: Stored string success: ' + success + '\n\nNow we\'ll read it back');
    }
    readFromNSUserDefaults(userDefaultsKey);
  });
}

function readFromNSUserDefaults(key)
{
   readUserDefaultsForKey('testKey', function(returnedObject)
   {
     error = isError(returnedObject);
     if (error)
     {
       alert('JS: We have an error: ' + error);
     }
     else
     {
       alert('JS: We just read \'' + returnedObject + '\' from NSUserDefaults\n\nWe\'ll now log it to the xcode console from JS');
     }
     logToXcode('This is being logged from JS with the passed string: ' + returnedObject, function()
      {
        alert('JS: We will now tell iOS that we have completed our script');
        complete(returnedObject);
      });
   });
}
