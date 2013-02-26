module.exports = (mongoose) ->
	mongoURL = 'mongodb://mongodb://localhost:27017/hands'

	Schema = mongoose.Schema

	mongoose.connection.on 'open', ->
		console.log 'connected to mongo'

	mongoose.connection.on 'error', (err) ->
	 	if err?
	 		throw err
	 		console.log 'connection error'

	mongoose.connect mongoURL

	handSchema = new Schema
		type: String
		author: String
		payload: Schema.Types.Mixed
		till: Date

	handSchema.pre 'set', (next, key, value) ->
		next key, if key is "till" then (new Date value) else value

	mongoose.model 'Hand', handSchema

	return mongoose
