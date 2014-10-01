# cdnify

Simple library to easily switch between
local and CDN libraries.

## Installation

Just run

```sh
$ npm install -g cdnify
```

## Usage

You just need to add the `cdn` attributes with the URL
pointing to the CDN you want to get started.

For example, let say the following file is called `index.html`.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Foobar</title>
  <script src="js/foo.js" cdn="//mycdn.com/bar.js"></script>
  <link href="css/foo.css" cdn="//mycdn.com/bar.css">
</head>
<body>

</body>
</html>
```

By running

```sh
$ cdnify index.html -o dist/index.html
```

You will get 

```html
  <script src="//mycdn.com/bar.js"></script>
  <link href="//mycdn.com/bar.css">
```

in `dist/index.html`.

If you want to keep the local source, pass the `--use-local`
flag.

## Options

* `--output` (aliased: `-o`): Set the output. Uses stdout if not set.
* `--use-local` (default: `false`): Uses local file (set by `src` or `href`) instead of `cdn`
* `--incompatible` (aliased: `-i`, default: `[]`): Set a list of attributes incompatible with `cdn`. If used together, an error will return.
* `--cdn-attr` (aliased: `t`, default: `cdn`): Set the attribute to be used for the CDN source.

Sample command:

```sh
$ cdnify -o foo.html --use-local -i glob -i other-attr --cdn-attr custom-attr
```

## Public API

This module exposes two functions:

* `cdnify.process(rawHtml, options, callback)`
  Arguments:

  * `rawHtml`: The raw HTML to process
  * `options`: The options as specified for the CLI. camelCase can be used instead of dash separated words.
  * `callback`: The callback to be called when done. The callback has the form:
   
    ```javascript
    function (err, html, $) {

    }
    ```

    where `html` is the processed HTML as a string and `$` is an instance
    of [cheerio](https://github.com/cheeriojs/cheerio), in case more processing
    is needed.

* `cdnify.processFile(filepath, options, callback)`
  Excatly the same function as above, except that the first
  argument is the path to the HTML file to proces, instead of the raw HTML.
