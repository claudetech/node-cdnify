#!/usr/bin/env node

var minimist = require('minimist')
  , _        = require('lodash')
  , cdnify   = require('../lib')
  , defaults = require('../lib/defaults');


var minimistOptions = {
  string: ['output', 'exclude'],
  boolean: ['useLocal'],
  alias: {
    output: 'o',
    'use-local': 'useLocal',
    incompatible: 'i',
    cdnAttr: 'a',
    cdnAttr: 'cdn-attr',
  },
  default: defaults
};

var argv = minimist(process.argv.slice(2), minimistOptions);
_.each(argv._, function (file) {
  cdnify.processFile(file, argv, function (err, html) {
    if (err) {
      console.log("Error while processing " + file + ":");
      console.log(err);
    } else {
      if (argv.output) {
        console.log("Saved to " + argv.output + ".");
      } else {
        console.log(html);
      }
    }
  });
});
