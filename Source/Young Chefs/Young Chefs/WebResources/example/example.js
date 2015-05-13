$(document).ready(function () {

	$("#jsReplace").html("JavaScript successfully replaced this box with new content.");
	
	$(".box").click(function() {
		var message = {"command":"boxtouch"};
		window.webkit.messageHandlers.javaSwift.postMessage(message);
	});
                  
    $(".next").click(function() {
		var message = {"command":"nextbutton"};
		window.webkit.messageHandlers.javaSwift.postMessage(message);
	});

});

function changeBackgroundColor(newColor) {
	$(".box").css("background-color",newColor);
}

$(function() {
	FastClick.attach(document.body);	//inits fast click on all web contents
});