$(function() {
	FastClick.attach(document.body);	//inits fast click on all web contents
});

$(document).ready(function() {
	
	$(".next").click(function() {
		var message = {"command":"nextbutton"};
		window.webkit.messageHandlers.javaSwift.postMessage(message);
	});
	
	$(".input").bind("input propertychange", function() {
		var field = $(this);
		var key = field.attr("id");
		var value = field.val();
		var message = {"command":"bindResponseKey",
					  "key":key,
					  "value":value};
		window.webkit.messageHandlers.javaSwift.postMessage(message);
		console.log("hyey");

	});
	
});

function fillKeyedHTMLWithValue(key, value) {
	var idkey = "#"+key;
	console.log(idkey);
	$(idkey).val(value);
}