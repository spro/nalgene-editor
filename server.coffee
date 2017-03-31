polar = require 'somata-socketio'
app = polar port: 6195
app.get '/', (req, res) -> res.render 'index'
app.start()
