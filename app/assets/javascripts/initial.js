$(document).ready(function(){
	// var totalScore = 0;
	// alert("Hello");
	// $.cookie('totalScore', null);
	$.cookie('totalScore', 0, { path: '/' });
	alert($.cookie('totalScore'));
});