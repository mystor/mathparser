# MathParser

A basic library for parsing simple mathematical expressions, and evaluating them.

Made for maxbittker's [Mojulo](https://github.com/MaxBittker/Mojulo). 

## Usage
Include the `mathparser.js` file in your html (`<script src="mathparser.js"></script>`).

Set `mathparser.yy` to expose values to the parser.

```javascript
mathparser.yy = {
  fn: {
    sin: Math.sin,
    cos: Math.cos
    // Put your functions here
  },
  
  var: {
    time: +new Date(),
    pi: Math.PI
    // Put any vars exposed to the program here
  }
};
```

Evaluate a given expression:
```javascript
var resultValue = mathparser.parse(theString);
```
