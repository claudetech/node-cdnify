cheerio  = require 'cheerio'
path     = require 'path'
_        = require 'lodash'
fs       = require 'fs'
defaults = require './defaults'


exports.process = (rawHtml, options, callback) ->
  _.defaults options, defaults
  options.incompatible = [options.incompatible] if _.isString(options.incompatible)
  selector = "[#{options.cdnAttr}]"
  $ = cheerio.load rawHtml
  err = null
  $(selector).each ->
    $this = $(this)
    if invalid = _.find(options.incompatible, (t) -> $this.attr(t)?)
      err = {message: "cdn attribute cannot be used with #{invalid}"}
    unless options.useLocal
      srcAttr = if this.name == 'script' then 'src' else 'href'
      $this.attr(srcAttr, $this.attr(options.cdnAttr))
      $(this).attr(options.cdnAttr, null)
    $(this).attr(options.cdnAttr, null)
  callback err, $.html(), $

exports.processFile = (filepath, options, callback) ->
  fs.readFile filepath, 'utf8', (err, rawHtml) ->
    return callback(err) if err
    exports.process rawHtml, options, (err, html, $) ->
      return callback(err) if err
      return callback(err, html, $) unless options.output
      fs.writeFile options.output, html, (err) ->
        callback err, html, $
