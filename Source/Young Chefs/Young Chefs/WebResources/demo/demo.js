$(function() {
	FastClick.attach(document.body);	//inits fast click on all web contents
});

$(document).ready(function() {
	
	$(".next").click(function() {
		var message = {"command":"nextbutton"};
		window.webkit.messageHandlers.javaSwift.postMessage(message);
	});
	
});