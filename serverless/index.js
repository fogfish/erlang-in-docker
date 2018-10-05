const { spawn } = require('child_process');

const env = process.env
const erl = spawn('./serverless/bin/escript', ['APP'], {env: { ...env, HOME: "/var/task" }});
erl.stdin.setEncoding = 'utf-8';

exports.handler = async function(event) {
   return new Promise(
      (accept, reject) => {
         erl.stdin.write(JSON.stringify(event) + '\n');
         erl.stdout.on('data', (data) => {
            accept(data.toString());
         });
         erl.stderr.on('data', (data) => {
            console.log(`${data.toString()}`);
         });
      }
   )
};
