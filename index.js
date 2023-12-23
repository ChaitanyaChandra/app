const express = require('express')
const path = require('path')
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
const User = require('./model/user')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
var child_process = require("child_process")
var mongoConnected = false;


const JWT_SECRET = 'ChaitanyaChandra<Chay@outlook.in>'

var mongoURL = process.env.MONGO_ENDPOINT || "mongodb://localhost:27017/login-app-db";

var app_version = process.env.APP_VERSION || "0.0"

var environment = process.env.ENV || "test"

mongoose.connect(mongoURL, {
	useUnifiedTopology: true,
	useNewUrlParser: true
//	useCreateIndex: true
  }).then(() => {
	mongoConnected = true;
	console.log('Connected to MongoDB');
  }).catch(err => {
	console.log('Error connecting to MongoDB:', err);
  });

const port = 8080
const app = express()
app.set('view engine', 'pug')
app.use(bodyParser.urlencoded({
    extended: false
}))

app.use('/', express.static(path.join(__dirname, 'public')))
app.use(express.static('views/public'))
app.use(bodyParser.json())

app.get('/health', (req, res) => {
    var stat = {
        app: 'OK',
        mongo: mongoConnected,
	version: app_version,
	environment: environment
    };
    res.json(stat);
});

app.get('/spec', function(req, res) {
    res.sendFile('public/index.html', {
        root: __dirname
    })
})

app.get('/signup', function(req, res) {
    res.sendFile('public/signup.html', {
        root: __dirname
    })
})

app.get('/cp', function(req, res) {
    res.sendFile('public/cp.html', {
        root: __dirname
    })
})

app.post('/api/change-password', async (req, res) => {
	const { token, newpassword: plainTextPassword } = req.body

	if (!plainTextPassword || typeof plainTextPassword !== 'string') {
		return res.json({ status: 'error', error: 'Invalid password' })
	}

	if (plainTextPassword.length < 5) {
		return res.json({
			status: 'error',
			error: 'Password too small. Should be atleast 6 characters'
		})
	}

	try {
		const user = jwt.verify(token, JWT_SECRET)

		const _id = user.id

		const password = await bcrypt.hash(plainTextPassword, 10)

		await User.updateOne(
			{ _id },
			{
				$set: { password }
			}
		)
		res.json({ status: 'ok' })
	} catch (error) {
		console.log(error)
		res.json({ status: 'error', error: 'you need to sign in first!' })
	}
})

app.post('/api/login', async (req, res) => {
	const { username, password } = req.body
	const user = await User.findOne({ username }).lean()

	if (!user) {
		return res.json({ status: 'error', error: 'Invalid username/password' })
	}

	if (await bcrypt.compare(password, user.password)) {
		// the username, password combination is successful
		console.log(`user: ${username} sussessfully logged in.`)
		const token = jwt.sign(
			{
				id: user._id,
				username: user.username
			},
			JWT_SECRET
		)
		return res.json({ status: 'ok', data: token })
	}
	console.log(`user: ${username} wrong password.`)
	res.json({ status: 'error', error: 'Invalid username/password' })
})

app.post('/api/register', async (req, res) => {
	const { username, password: plainTextPassword } = req.body
	if (!username || typeof username !== 'string') {
		return res.json({ status: 'error', error: 'Invalid username' })
	}

	if (!plainTextPassword || typeof plainTextPassword !== 'string') {
		return res.json({ status: 'error', error: 'Invalid password' })
	}

	if (plainTextPassword.length < 5) {
		return res.json({
			status: 'error',
			error: 'Password too small. Should be atleast 6 characters'
		})
	}

	const password = await bcrypt.hash(plainTextPassword, 10)

	try {
		const response = await User.create({
			username,
			password
		})
		console.log(`user: ${username} created.`)
		// console.log('User created successfully: ', response)
	} catch (error) {
		if (error.code === 11000) {
			// duplicate key
			console.log(`user: ${username} Username already in use.`)
			return res.json({ status: 'error', error: 'Username already in use' })
		}
		throw error
	}

	res.json({ status: 'ok' })
})

app.post('/spec', function(req, res) {
	const { username, password } = req.body
	console.log(`user: ${username} accessed spec.`)
	const command_data = {};
	command_data.items = [];
	let cmd_hostname = child_process.execSync("hostname");
	command_data.items[0] = {hostname : (cmd_hostname.toString())}
	let cmd_uptime = child_process.execSync("uptime");
	command_data.items[1] = {uptime : (cmd_uptime.toString())}
	let cmd_lscpu = child_process.execSync("cat /proc/cpuinfo");
	command_data.items[2] = {lscpu : cmd_lscpu.toString()}
	let cmd_memoryInfo = child_process.execSync("cat /proc/meminfo");
	command_data.items[3] = {meminfo : cmd_memoryInfo.toString()}
	// .replace(/\n?\r\n/g, '<br />' )
	console.log(JSON.stringify(command_data))
	res.render('spec', {
		hostname: command_data.items[0].hostname,
		uptime: command_data.items[1].uptime,
		lscpu: command_data.items[2].lscpu,
		meminfo: command_data.items[3].meminfo,
		dev: "chaitanya chandra (chay@outlook.in)",
		app_version: app_version,
		env: environment
	})
})


// error navigation
app.use((error, req, res, next) => {
    res.status(error.status || 500).send({
        error: {
            status: error.status || 500,
            message: error.message || 'Internal Server Error',
        },
    });
    res.sendFile('public/error.html', {
        root: __dirname
    })
});

app.use(function(req, res, next){
    res.status(404);
    res.sendFile('public/error.html', {
        root: __dirname
    })
})

app.listen(process.env.PORT || port, () => {
    console.log(`leads app listening at http://localhost:${port}`)
})
