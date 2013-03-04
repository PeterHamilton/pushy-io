krb5 = require 'node-krb5'
crypto = require 'crypto'

users = {}

newUser = (username) ->
  loop
    hash = crypto.randomBytes 16
    if !users[hash]?
      sessionHash = hash.toString('hex')
      users[sessionHash] = username
      break
  return sessionHash

exports.authenticate = (credentials, callback) ->
  {username, password} = credentials
  krb5.authenticate "#{username}@IC.AC.UK", password, (err) ->
    console.log "Authentication error: " + err if err?
    callback
      success: !err?
      sessionHash: newUser username

exports.verify = (sessionHash) -> users[sessionHash]