// Builds "Gruvbox Dark.terminal", a Terminal.app profile, from the hex colors below.
// Terminal.app stores colors as archived binary objects, so edit the hex values here
// and re-run instead of editing the .terminal file:
//   osascript -l JavaScript terminal/make-gruvbox-dark.js "terminal/Gruvbox Dark.terminal"
// Palette: https://github.com/morhetz/gruvbox (dark, medium contrast)

ObjC.import('AppKit');

const colors = {
  BackgroundColor:      '#282828',
  TextColor:            '#ebdbb2',
  TextBoldColor:        '#fbf1c7',
  CursorColor:          '#ebdbb2',
  SelectionColor:       '#504945',

  ANSIBlackColor:       '#282828',
  ANSIRedColor:         '#cc241d',
  ANSIGreenColor:       '#98971a',
  ANSIYellowColor:      '#d79921',
  ANSIBlueColor:        '#458588',
  ANSIMagentaColor:     '#b16286',
  ANSICyanColor:        '#689d6a',
  ANSIWhiteColor:       '#a89984',

  ANSIBrightBlackColor:   '#928374',
  ANSIBrightRedColor:     '#fb4934',
  ANSIBrightGreenColor:   '#b8bb26',
  ANSIBrightYellowColor:  '#fabd2f',
  ANSIBrightBlueColor:    '#83a598',
  ANSIBrightMagentaColor: '#d3869b',
  ANSIBrightCyanColor:    '#8ec07c',
  ANSIBrightWhiteColor:   '#ebdbb2',
};

function archivedColor(hex) {
  const n = parseInt(hex.slice(1), 16);
  const c = $.NSColor.colorWithSRGBRedGreenBlueAlpha(((n >> 16) & 255) / 255, ((n >> 8) & 255) / 255, (n & 255) / 255, 1);
  return $.NSKeyedArchiver.archivedDataWithRootObjectRequiringSecureCodingError(c, false, null);
}

function run(argv) {
  const out = argv[0] || 'Gruvbox Dark.terminal';
  const profile = $.NSMutableDictionary.alloc.init;
  profile.setObjectForKey('Gruvbox Dark', 'name');
  profile.setObjectForKey('Window Settings', 'type');
  profile.setObjectForKey($.NSNumber.numberWithDouble(2.07), 'ProfileCurrentVersion');
  // draw bold text in the bright colors, so the bold path and folders use the lighter blue
  profile.setObjectForKey($.NSNumber.numberWithBool(true), 'UseBrightBold');
  for (const key in colors) profile.setObjectForKey(archivedColor(colors[key]), key);
  if (!profile.writeToFileAtomically(out, true)) throw new Error('could not write ' + out);
  return 'wrote ' + out;
}
