# NonogramSolver
A solver of nonograms for https://www.nonograms.org

This is a work in progress. Some nonogram will be solved but not all of them.


## Installation

To install the project on your Pharo image, execute the following script: 

```Smalltalk
Metacello new
	githubUser: 'jecisc' project: 'NonogramSolver' commitish: 'main' path: 'src';
	baseline: 'NonogramSolver';
	load
```

## How to use

NonogramSolver uses websockets to connect the web page and fill the nonogram. 
The WebSocket on the server side should be initialized during the load part of the project by the method `NSResolver class>>#launchWebSocket`.

Then you can select your nonogram on https://www.nonograms.org.
In order to use NonogramSolver to resolve your nonogram, you need to open the javascript console of your browser (F12 on Firefox).
You can copy paste this snippet and execute it:

```javascript
const socket = new WebSocket("ws://localhost:1802");

socket.addEventListener("open", function (event) {
    socket.send(document.getElementsByClassName("nonogram_table")[0].innerHTML);
});

socket.addEventListener("message", function (event) {
	const data = JSON.parse(event.data);
   data.filled.forEach(check);
   data.empty.forEach(empty);
});

function check(value, index, array) {
	var clickEvent = new MouseEvent("mousedown", { view: window, button: 0});
	document.getElementById(value).dispatchEvent (clickEvent);
}

function empty(value, index, array) {
	var clickEvent = new MouseEvent("mousedown", { view: window, button: 2});
	document.getElementById(value).dispatchEvent (clickEvent);
}
```

## Contact

If you have any questions or problems do not hesitate to open an issue or contact cyril (a) ferlicot.me 
