expect    = require 'expect.js'
path      = require 'path'
cheerio   = require 'cheerio'
_         = require 'lodash'

cdnify = require '../src/index'

describe 'processor', ->
  describe '#process', ->
    scriptTag = '<script src="foo.js" cdn="bar.js"></script>'
    linkTag = '<link ref="stylesheet" href="foo.css" cdn="bar.css">'

    it 'should remove cdn attribute when using local', (done) ->
      cdnify.process scriptTag, {useLocal: true}, (err, html, $) ->
        expect(err).to.be null
        expect($('[cdn]').length).to.be 0
        expect($('script').attr('src')).to.be 'foo.js'
        done()

    it 'should use cdn in otherwise', (done) ->
      cdnify.process scriptTag, {}, (err, html, $) ->
        expect(err).to.be null
        expect($('[cdn]').length).to.be 0
        expect($('script').attr('src')).to.be 'bar.js'
        done()

    it 'should use href for links', (done) ->
      cdnify.process linkTag, {}, (err, html, $) ->
        expect(err).to.be null
        expect($('[cdn]').length).to.be 0
        expect($('link').attr('href')).to.be 'bar.css'
        done()

    it 'should work with multiple tags', (done) ->
      rawHtml = scriptTag + linkTag
      cdnify.process rawHtml, {}, (err, html, $) ->
        expect(err).to.be null
        expect($('[cdn]').length).to.be 0
        expect($('script').attr('src')).to.be 'bar.js'
        expect($('link').attr('href')).to.be 'bar.css'
        done()

    it 'should fail with incompatibl attrs', (done) ->
      rawHtml = '<script src="foo.js" cdn="bar.js" glob></script>'
      cdnify.process rawHtml, {incompatible: ['glob']}, (err, html, $) ->
        expect(err).to.not.be null
        done()

    it 'should work with other attr', (done) ->
      rawHtml = '<script src="foo.js" custom-cdn="bar.js"></script>'
      cdnify.process rawHtml, {cdnAttr: 'custom-cdn'}, (err, html, $) ->
        expect(err).to.be null
        expect($('[custom-cdn]').length).to.be 0
        expect($('script').attr('src')).to.be 'bar.js'
        done()

  describe '#processFile', ->
    it 'should read and process file', (done) ->
      cdnify.processFile path.join(__dirname, 'data', 'index.html'), {}, (err, html, $) ->
        expect(err).to.be null
        expect($('[cdn]').length).to.be 0
        expect($('script').attr('src')).to.be 'bar.js'
        expect($('link').attr('href')).to.be 'bar.css'
        done()
