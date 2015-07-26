package com.evili.utils
{
	/** uses the ExternalInterface to pass an alert message from flash to JavaScript
	 *  NOTE: user MUST insert a function named "showAlert" in the Javascript section of the
	 *  html page that contains the swf, eg:
	 *  function showAlert( str )
			{
   				alert(str);
			}
			 */
	import flash.external.ExternalInterface;
	
	
	public class JSAlert
	{
		public function JSAlert()
		{
			
		}
		public static function showAlert(msg:String=""):void{
			if (ExternalInterface.available) {
				try {
					var tempStr:String = ExternalInterface.call("alert", msg);
				} catch (error:SecurityError) {
					// ignore
				}
			}
		}

	}
}