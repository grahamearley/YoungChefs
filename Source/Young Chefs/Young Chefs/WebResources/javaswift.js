$(function() {
	FastClick.attach(document.body);	//inits fast click on all web contents
});

$(document).ready(function() {
	
	//Notify JavaSwift that content is ready
	var notifyMessage = {"command":"contentIsReady"};
	window.webkit.messageHandlers.javaSwift.postMessage(notifyMessage);
	
	$(".next").click(function() {
		var commandMessage = {"command":"nextButton"};
		window.webkit.messageHandlers.javaSwift.postMessage(commandMessage);
	});
	
	$(".back").click(function() {
		var commandMessage = {"command":"backButton"};
		window.webkit.messageHandlers.javaSwift.postMessage(commandMessage);
	});
	
	$(".input").bind("input propertychange", function() {
		var field = $(this);
		
		//clean input of double quotes
		var uncleanValue = field.val();
		var warningElements = new RegExp("\"");	//matches double quotes
		var cleanValue = uncleanValue.replace(warningElements,"");
		field.val(cleanValue);
		
		//pull contents and post them to JavaSwift
		var key = field.attr("id");
		var value = field.val();
		var commandMessage = {"command":"bindResponseKey",
					  "key":key,
					  "value":value};
		window.webkit.messageHandlers.javaSwift.postMessage(commandMessage);
	});
	
});

//Only functional after document's ready callback
function fillKeyedHTMLWithValue(key, value) {
	var idKey = "#"+key;
	$(idKey).val(value);
}