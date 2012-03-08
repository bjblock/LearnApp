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
});