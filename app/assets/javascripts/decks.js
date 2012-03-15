$(document).ready(function(){
var downloadButton = document.getElementById("countdown");
var counter = 10;
var newElement = document.createElement("p");
newElement.innerHTML = "You can get 10 points.";
var id;

downloadButton.parentNode.replaceChild(newElement, downloadButton);

id = setInterval(function() {
    counter--;
    if(counter < 0) {
        newElement.parentNode.replaceChild(downloadButton, newElement);
        clearInterval(id);
    } else {
        newElement.innerHTML = "You can get " + counter.toString() + " points.";
    }
}, 1000);
$("li.choice a").click(function(){
	// if (@question.correct_answer_id == @answer.to_i) {
	var score = counter;
	var totalScore = parseInt($.cookie('totalScore')) + score;
	$.cookie('totalScore', totalScore, { path: '/' });
	// alert("Score = " + score.toString() + "Total Score = " + totalScore.toString());
	alert($.cookie('totalScore'));
	
// }
});
});