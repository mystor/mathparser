# MathParser

A basic library for parsing simple mathematical expressions, and evaluating them.

Made for maxbittker's [Mojulo](https://github.com/MaxBittker/Mojulo). 

## Usage
Include the `mathparser.js` file in your html (`<script src="mathparser.js"></script>`).

If you are using commonjs, you can also use `var mathparser = require('./mathparser');` to require the math parser, but `mathparser` isn't on npm (and probably never will be).

Parsing an expression will produce a function:
```javascript
var fun = mathparser.parse('x * y^2 + 5 / sin(x)');
```

You can then use that function
```javascript
var exposedFunctions = {
  sin: Math.sin,
  cos: Math.cos,
  rand: Math.random
};

var exposedVars = {
  x: 10,
  y: 20,
  pi: Math.PI
};

var result = fun(exposedFunctions, exposedVars); // 3990.8091802
```

## Building
MathParser is implemented as a single `jison` file. You compile it using (unsurprisingly) [jison](http://zaach.github.io/jison/).

```bash
$ jison mathparser.jison
```
