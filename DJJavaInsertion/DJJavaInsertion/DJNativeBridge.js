/*
 * NativeBridge is the go between javascript and objective-c.
 * Don't modify NativeBridge
 */
var NativeBridge = {
  callbacksCount : 1,
  callbacks : {},
  
  // Automatically called by native layer when a result is available
  resultForCallback : function resultForCallback(callbackId, resultArray) {
    try {
      var callback = NativeBridge.callbacks[callbackId];
      if (!callback) return;

      callback.apply(null, resultArray);
    } catch(e) {alert(e)}
  },
  
  // Use this in javascript to request native objective-c code
  // functionName : string (I think the name is explicit :p)
  // args : array of arguments
  // callback : function with n-arguments that is going to be called when the native code returned
  call : function call(functionName, args, callback) {
    
    var hasCallback = callback && typeof callback == "function";
    var callbackId = hasCallback ? NativeBridge.callbacksCount++ : 0;
    
    if (hasCallback)
      NativeBridge.callbacks[callbackId] = callback;
    
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", "objc-funct:" + functionName + ":" + callbackId+ ":" + encodeURIComponent(JSON.stringify(args)));
      
    iframe.setAttribute("height", "1px");
    iframe.setAttribute("width", "1px");
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  }
};

function isError(result)
{
  if (result == null) return null;

  if (typeof(result) == 'string')
  {
    if (result.substring(0, 6) == 'ERROR:')
    {
      errorMsg = result.substring(6, result.length);
      return errorMsg;
    }
    else
    {
      return null;
    }
  }
}