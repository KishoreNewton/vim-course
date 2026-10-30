// comet.nvim: the Node.js half. Neovim starts this file with
// jobstart({ 'node', 'comet.mjs' }, { rpc = true }) and talks to it over
// stdin/stdout in msgpack-RPC. Nothing here may print to stdout.
import { attach } from 'neovim';

const nvim = attach({ reader: process.stdin, writer: process.stdout });
process.stdin.on('end', () => process.exit(0));

const cfg = {
  color: 0x00ff00,  // the comet's colour at full brightness
  head: 0.02,       // seconds for the head to close 63% of the gap
  tail: 0.10,       // the tail is five times lazier: that difference is the comet
  glow: 0.09,       // seconds for a cell's glow to fall to 37%
};
const ASPECT = 2;       // a terminal cell is about twice as tall as it is wide
const LEVELS = 8;       // brightness steps, one highlight group each
const POOL = 96;        // 1x1 floating windows, made once and reused every frame
const FLOOR = 0.06;     // dimmer than this and a cell is not drawn
const FRAME_MS = 1000 / 60;

let head = null, tail = null, target = null;
let timer = null, last = 0, busy = false;
let wins = [];
const heat = new Map(); // "row,col" -> brightness 0..1, fading every frame
let shown = [];         // what each pooled window shows right now: "row,col,level" or ""
const stats = { frames: 0, calls: 0, ms: 0, moves: 0 };

// Exponential approach: each frame closes a fixed FRACTION of the gap, and the
// fraction comes from the real time that passed, so 30 fps and 144 fps trace
// the same curve.
function chase(p, goal, tau, dt) {
  const k = 1 - Math.exp(-dt / tau);
  p.x += (goal.x - p.x) * k;
  p.y += (goal.y - p.y) * k;
}

// Walk the tail-to-head segment one cell at a time (a DDA line) and heat every
// cell it crosses: brightest at the head. y is stored stretched by ASPECT so a
// diagonal looks diagonal; it is squashed back here. The cells either side of
// the line get a softer glow, which gives the comet some width.
function brush(a, b) {
  const dx = b.x - a.x, dy = (b.y - a.y) / ASPECT;
  const steps = Math.ceil(Math.max(Math.abs(dx), Math.abs(dy)));
  const across = Math.abs(dy) > Math.abs(dx) ? [0, 1] : [1, 0];  // the side of the line
  for (let i = 0; i <= steps; i++) {
    const s = steps ? i / steps : 1;                 // 0 at the tail, 1 at the head
    const row = Math.round((a.y + (b.y - a.y) * s) / ASPECT);
    const col = Math.round(a.x + (b.x - a.x) * s);
    const h = Math.pow(s, 0.6);
    warm(row, col, h);
    warm(row + across[1], col + across[0], h * 0.4);
    warm(row - across[1], col - across[0], h * 0.4);
  }
}

function warm(row, col, h) {
  const key = `${row},${col}`;
  if (h > (heat.get(key) ?? 0)) heat.set(key, h);
}

// Linear blend, channel by channel: c = bg + (fg - bg) * a.
function blend(fg, bg, a) {
  const ch = shift => Math.round(((fg >> shift) & 255) * a + ((bg >> shift) & 255) * (1 - a));
  return (ch(16) << 16) | (ch(8) << 8) | ch(0);
}

async function paintLevels() {
  const normal = await nvim.request('nvim_get_hl', [0, { name: 'Normal' }]);
  const bg = normal.bg ?? 0x000000;
  const calls = [];
  for (let k = 0; k < LEVELS; k++) {
    const a = ((k + 1) / LEVELS) ** 2;               // squared: the tail fades fast
    calls.push(['nvim_set_hl', [0, `Comet${k}`, { bg: blend(cfg.color, bg, a) }]]);
  }
  await nvim.request('nvim_call_atomic', [calls]);
}

async function makePool() {
  const buf = await nvim.request('nvim_create_buf', [false, true]);
  await nvim.request('nvim_buf_set_lines', [buf, 0, -1, false, [' ']]);
  const calls = [];
  for (let i = 0; i < POOL; i++) {
    calls.push(['nvim_open_win', [buf, false, {
      relative: 'editor', row: 0, col: 0, width: 1, height: 1, style: 'minimal',
      border: 'none', focusable: false, zindex: 250, hide: true, noautocmd: true,
    }]]);
  }
  const [ids] = await nvim.request('nvim_call_atomic', [calls]);
  wins = ids;
  shown = wins.map(() => '');
}

function stop() {
  clearInterval(timer);
  timer = null;           // head and tail stay where they settled: the next move starts there
}

async function frame() {
  if (busy) return;
  busy = true;
  const t0 = performance.now();
  const dt = Math.min(0.05, (t0 - last) / 1000);
  last = t0;
  chase(head, target, cfg.head, dt);
  chase(tail, target, cfg.tail, dt);

  // Every glowing cell loses the same fraction of its light per second.
  const fade = Math.exp(-dt / cfg.glow);
  for (const [key, h] of heat) {
    if (h * fade < FLOOR) heat.delete(key);
    else heat.set(key, h * fade);
  }
  const moving = Math.hypot(tail.x - target.x, (tail.y - target.y) / ASPECT) > 0.35;
  if (moving) brush(tail, head);

  const cursor = `${Math.round(target.y / ASPECT)},${Math.round(target.x)}`;
  const cells = [...heat]
    .filter(([key]) => key !== cursor)               // never cover the real cursor
    .sort((p, q) => q[1] - p[1])
    .slice(0, POOL)
    .map(([key, h]) => {
      const [row, col] = key.split(',').map(Number);
      return { row, col, level: Math.min(LEVELS - 1, Math.floor(h * LEVELS)) };
    })
    .filter(c => c.row >= 0 && c.col >= 0);

  // Only windows whose job changed get a call: a still comet costs nothing.
  const calls = [];
  wins.forEach((w, i) => {
    const c = cells[i];
    const want = c ? `${c.row},${c.col},${c.level}` : '';
    if (want === shown[i]) return;
    if (c) {
      calls.push(['nvim_win_set_config', [w, { relative: 'editor', row: c.row, col: c.col, hide: false }]]);
      calls.push(['nvim_set_option_value', ['winhighlight', `Normal:Comet${c.level}`, { win: w }]]);
    } else {
      calls.push(['nvim_win_set_config', [w, { hide: true }]]);
    }
    shown[i] = want;
  });
  stats.frames++;
  stats.ms += performance.now() - t0;               // Node's own work, not the editor's reply
  if (calls.length) {
    await nvim.request('nvim_call_atomic', [calls]);  // one round trip per frame
    stats.calls++;
  }
  busy = false;
  if (!moving && heat.size === 0) stop();
}

nvim.on('notification', (method, args) => {
  if (method === 'config') {
    Object.assign(cfg, args[0] || {});
    if (typeof cfg.color === 'string') cfg.color = parseInt(cfg.color.replace('#', ''), 16);
    paintLevels();
    return;
  }
  if (method !== 'move' || !wins.length) return;
  const [row, col] = args;
  stats.moves++;
  target = { x: col, y: row * ASPECT };
  if (!head) {
    head = { ...target };
    tail = { ...target };
  }
  if (!timer) {
    last = performance.now();
    timer = setInterval(frame, FRAME_MS);
  }
});

nvim.on('request', (method, args, res) => {
  if (method !== 'stats') return res.send('unknown method', true);
  const avg = stats.frames ? (stats.ms / stats.frames).toFixed(2) : '0';
  res.send(`comet: ${stats.moves} moves, ${stats.frames} frames, ${stats.calls} RPC calls, ` +
    `${avg} ms per frame, ${timer ? 'animating' : 'asleep'}`);
});

await paintLevels();
await makePool();
