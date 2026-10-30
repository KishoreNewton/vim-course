import { attach } from 'neovim';

const nvim = attach({ reader: process.stdin, writer: process.stdout });

nvim.on('request', async (method, args, res) => {
  const buf = await nvim.buffer;
  await buf.insert(['// Node was here'], 0);
  res.send('hello ' + args[0] + ', this is Node ' + process.version);
});
