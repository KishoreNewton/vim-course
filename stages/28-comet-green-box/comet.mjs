import { attach } from 'neovim';

const nvim = attach({ reader: process.stdin, writer: process.stdout });

const buf = await nvim.request('nvim_create_buf', [false, true]);
const win = await nvim.request('nvim_open_win', [buf, false, {
  relative: 'editor', row: 0, col: 0, width: 1, height: 1,
  style: 'minimal', border: 'none',
}]);
await nvim.request('nvim_set_hl', [0, 'Comet', { bg: 0x00ff00 }]);
await nvim.request('nvim_set_option_value', ['winhighlight', 'Normal:Comet', { win }]);

nvim.on('notification', (method, [row, col]) => {
  nvim.request('nvim_win_set_config', [win, { relative: 'editor', row, col: col + 1 }]);
});
