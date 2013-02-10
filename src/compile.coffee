dust = require 'dustjs-linkedin'
jade = require 'jade'
fs = require 'fs'
path = require 'path'

module.exports = ->
  templates = fs.readdirSync 'src/views/template'
  result = ""
  for t in templates
    filePath = path.join 'src/views/template', t
    name = path.basename t, '.jade'
    jadedust = fs.readFileSync filePath, 'utf8'
    result += dust.compile (jade.compile jadedust)({}), name
  fs.writeFileSync 'src/public/javascripts/templates.js', result