module.exports = (mongoose) ->
	mongoURL = 'mongodb://Fist:cebVeryof8@ec2-54-228-51-119.eu-west-1.compute.amazonaws.com:27017/hands'

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