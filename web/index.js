const app = require('express')();
const http = require('http').Server(app);
const io = require('socket.io')(http);
const amqp = require('amqplib/callback_api');

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

amqp.connect('amqp://localhost', function (err, conn) {
  conn.createChannel(function (err, ch) {
    const q = 'test';
    ch.assertQueue(q, { durable: false });

    io.on('connection', (socket) => {
      console.log('a user connected');

      socket.on('disconnect', () => {
        console.log('user disconnected');
      });

      socket.on('message', (data) => {
        console.log('pushing message to rabbit:', data);
        ch.sendToQueue(q, Buffer.from(data));
      });
    });
  });
});


http.listen(3000, () => {
  console.log('listening on *:3000');
});