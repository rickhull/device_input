module DeviceInput
  EVENTS = {}

  # type = Sync
  EVENTS[0] = {
  }

  # type = Key
  EVENTS[1] = {
    0 => 'Reserved',
    1 => 'Esc',
    2 => '1',
    3 => '2',
    4 => '3',
    5 => '4',
    6 => '5',
    7 => '6',
    8 => '7',
    9 => '8',
    10 => '9',
    11 => '0',
    12 => 'Minus',
    13 => 'Equal',
    14 => 'Backspace',
    15 => 'Tab',
    16 => 'Q',
    17 => 'W',
    18 => 'E',
    19 => 'R',
    20 => 'T',
    21 => 'Y',
    22 => 'U',
    23 => 'I',
    24 => 'O',
    25 => 'P',
    26 => 'LeftBrace',
    27 => 'RightBrace',
    28 => 'Enter',
    29 => 'LeftControl',
    30 => 'A',
    31 => 'S',
    32 => 'D',
    33 => 'F',
    34 => 'G',
    35 => 'H',
    36 => 'J',
    37 => 'K',
    38 => 'L',
    39 => 'Semicolon',
    40 => 'Apostrophe',
    41 => 'Grave',
    42 => 'LeftShift',
    43 => 'BackSlash',
    44 => 'Z',
    45 => 'X',
    46 => 'C',
    47 => 'V',
    48 => 'B',
    49 => 'N',
    50 => 'M',
    51 => 'Comma',
    52 => 'Dot',
    53 => 'Slash',
    54 => 'RightShift',
    55 => 'KPAsterisk',
    56 => 'LeftAlt',
    57 => 'Space',
    58 => 'CapsLock',
    59 => 'F1',
    60 => 'F2',
    61 => 'F3',
    62 => 'F4',
    63 => 'F5',
    64 => 'F6',
    65 => 'F7',
    66 => 'F8',
    67 => 'F9',
    68 => 'F10',
    69 => 'NumLock',
    70 => 'ScrollLock',
    71 => 'KP7',
    72 => 'KP8',
    73 => 'KP9',
    74 => 'KPMinus',
    75 => 'KP4',
    76 => 'KP5',
    77 => 'KP6',
    78 => 'KPPlus',
    79 => 'KP1',
    80 => 'KP2',
    81 => 'KP3',
    82 => 'KP0',
    83 => 'KPDot',
    85 => 'Zenkaku/Hankaku',
    86 => '102nd',
    87 => 'F11',
    88 => 'F12',
    89 => 'RO',
    90 => 'Katakana',
    91 => 'HIRAGANA',
    92 => 'Henkan',
    93 => 'Katakana/Hiragana',
    94 => 'Muhenkan',
    95 => 'KPJpComma',
    96 => 'KPEnter',
    97 => 'RightCtrl',
    98 => 'KPSlash',
    99 => 'SysRq',
    100 => 'RightAlt',
    101 => 'LineFeed',
    102 => 'Home',
    103 => 'Up',
    104 => 'PageUp',
    105 => 'Left',
    106 => 'Right',
    107 => 'End',
    108 => 'Down',
    109 => 'PageDown',
    110 => 'Insert',
    111 => 'Delete',
    112 => 'Macro',
    113 => 'Mute',
    114 => 'VolumeDown',
    115 => 'VolumeUp',
    116 => 'Power',
    117 => 'KPEqual',
    118 => 'KPPlusMinus',
    119 => 'Pause',
    121 => 'KPComma',
    122 => 'Hanguel',
    123 => 'Hanja',
    124 => 'Yen',
    125 => 'LeftMeta',
    126 => 'RightMeta',
    127 => 'Compose',
    128 => 'Stop',
    129 => 'Again',
    130 => 'Props',
    131 => 'Undo',
    132 => 'Front',
    133 => 'Copy',
    134 => 'Open',
    135 => 'Paste',
    136 => 'Find',
    137 => 'Cut',
    138 => 'Help',
    139 => 'Menu',
    140 => 'Calc',
    141 => 'Setup',
    142 => 'Sleep',
    143 => 'WakeUp',
    144 => 'File',
    145 => 'SendFile',
    146 => 'DeleteFile',
    147 => 'X-fer',
    148 => 'Prog1',
    149 => 'Prog2',
    150 => 'WWW',
    151 => 'MSDOS',
    152 => 'Coffee',
    153 => 'Direction',
    154 => 'CycleWindows',
    155 => 'Mail',
    156 => 'Bookmarks',
    157 => 'Computer',
    158 => 'Back',
    159 => 'Forward',
    160 => 'CloseCD',
    161 => 'EjectCD',
    162 => 'EjectCloseCD',
    163 => 'NextSong',
    164 => 'PlayPause',
    165 => 'PreviousSong',
    166 => 'StopCD',
    167 => 'Record',
    168 => 'Rewind',
    169 => 'Phone',
    170 => 'ISOKey',
    171 => 'Config',
    172 => 'HomePage',
    173 => 'Refresh',
    174 => 'Exit',
    175 => 'Move',
    176 => 'Edit',
    177 => 'ScrollUp',
    178 => 'ScrollDown',
    179 => 'KPLeftParenthesis',
    180 => 'KPRightParenthesis',
    183 => 'F13',
    184 => 'F14',
    185 => 'F15',
    186 => 'F16',
    187 => 'F17',
    188 => 'F18',
    189 => 'F19',
    190 => 'F20',
    191 => 'F21',
    192 => 'F22',
    193 => 'F23',
    194 => 'F24',
    200 => 'PlayCD',
    201 => 'PauseCD',
    202 => 'Prog3',
    203 => 'Prog4',
    205 => 'Suspend',
    206 => 'Close',
    207 => 'Play',
    208 => 'Fast Forward',
    209 => 'Bass Boost',
    210 => 'Print',
    211 => 'HP',
    212 => 'Camera',
    213 => 'Sound',
    214 => 'Question',
    215 => 'Email',
    216 => 'Chat',
    217 => 'Search',
    218 => 'Connect',
    219 => 'Finance',
    220 => 'Sport',
    221 => 'Shop',
    222 => 'Alternate Erase',
    223 => 'Cancel',
    224 => 'Brightness down',
    225 => 'Brightness up',
    226 => 'Media',
    240 => 'Unknown',
    256 => 'Btn0',
    257 => 'Btn1',
    258 => 'Btn2',
    259 => 'Btn3',
    260 => 'Btn4',
    261 => 'Btn5',
    262 => 'Btn6',
    263 => 'Btn7',
    264 => 'Btn8',
    265 => 'Btn9',
    272 => 'LeftBtn',
    273 => 'RightBtn',
    274 => 'MiddleBtn',
    275 => 'SideBtn',
    276 => 'ExtraBtn',
    277 => 'ForwardBtn',
    278 => 'BackBtn',
    279 => 'TaskBtn',
    288 => 'Trigger',
    289 => 'ThumbBtn',
    290 => 'ThumbBtn2',
    291 => 'TopBtn',
    292 => 'TopBtn2',
    293 => 'PinkieBtn',
    294 => 'BaseBtn',
    295 => 'BaseBtn2',
    296 => 'BaseBtn3',
    297 => 'BaseBtn4',
    298 => 'BaseBtn5',
    299 => 'BaseBtn6',
    303 => 'BtnDead',
    304 => 'BtnA',
    305 => 'BtnB',
    306 => 'BtnC',
    307 => 'BtnX',
    308 => 'BtnY',
    309 => 'BtnZ',
    310 => 'BtnTL',
    311 => 'BtnTR',
    312 => 'BtnTL2',
    313 => 'BtnTR2',
    314 => 'BtnSelect',
    315 => 'BtnStart',
    316 => 'BtnMode',
    317 => 'BtnThumbL',
    318 => 'BtnThumbR',
    320 => 'ToolPen',
    321 => 'ToolRubber',
    322 => 'ToolBrush',
    323 => 'ToolPencil',
    324 => 'ToolAirbrush',
    325 => 'ToolFinger',
    326 => 'ToolMouse',
    327 => 'ToolLens',
    330 => 'Touch',
    331 => 'Stylus',
    332 => 'Stylus2',
    333 => 'Tool Doubletap',
    334 => 'Tool Tripletap',
    336 => 'WheelBtn',
    337 => 'Gear up',
    352 => 'Ok',
    353 => 'Select',
    354 => 'Goto',
    355 => 'Clear',
    356 => 'Power2',
    357 => 'Option',
    358 => 'Info',
    359 => 'Time',
    360 => 'Vendor',
    361 => 'Archive',
    362 => 'Program',
    363 => 'Channel',
    364 => 'Favorites',
    365 => 'EPG',
    366 => 'PVR',
    367 => 'MHP',
    368 => 'Language',
    369 => 'Title',
    370 => 'Subtitle',
    371 => 'Angle',
    372 => 'Zoom',
    373 => 'Mode',
    374 => 'Keyboard',
    375 => 'Screen',
    376 => 'PC',
    377 => 'TV',
    378 => 'TV2',
    379 => 'VCR',
    380 => 'VCR2',
    381 => 'Sat',
    382 => 'Sat2',
    383 => 'CD',
    384 => 'Tape',
    385 => 'Radio',
    386 => 'Tuner',
    387 => 'Player',
    388 => 'Text',
    389 => 'DVD',
    390 => 'Aux',
    391 => 'MP3',
    392 => 'Audio',
    393 => 'Video',
    394 => 'Directory',
    395 => 'List',
    396 => 'Memo',
    397 => 'Calendar',
    398 => 'Red',
    399 => 'Green',
    400 => 'Yellow',
    401 => 'Blue',
    402 => 'ChannelUp',
    403 => 'ChannelDown',
    404 => 'First',
    405 => 'Last',
    406 => 'AB',
    407 => 'Next',
    408 => 'Restart',
    409 => 'Slow',
    410 => 'Shuffle',
    411 => 'Break',
    412 => 'Previous',
    413 => 'Digits',
    414 => 'TEEN',
    415 => 'TWEN',
    448 => 'Delete EOL',
    449 => 'Delete EOS',
    450 => 'Insert line',
    451 => 'Delete line',
  }

  # type = Relative
  EVENTS[2] = {
    0 => 'X',
    1 => 'Y',
    2 => 'Z',
    6 => 'HWheel',
    7 => 'Dial',
    8 => 'Wheel',
    9 => 'Misc',
  }

  # type = Absolute
  EVENTS[3] = {
    0 => 'X',
    1 => 'Y',
    2 => 'Z',
    3 => 'Rx',
    4 => 'Ry',
    5 => 'Rz',
    6 => 'Throttle',
    7 => 'Rudder',
    8 => 'Wheel',
    9 => 'Gas',
    10 => 'Brake',
    16 => 'Hat0X',
    17 => 'Hat0Y',
    18 => 'Hat1X',
    19 => 'Hat1Y',
    20 => 'Hat2X',
    21 => 'Hat2Y',
    22 => 'Hat3X',
    23 => 'Hat 3Y',
    24 => 'Pressure',
    25 => 'Distance',
    26 => 'XTilt',
    27 => 'YTilt',
    28 => 'Tool Width',
    32 => 'Volume',
    40 => 'Misc',
  }

  # type = Misc
  EVENTS[4] = {
    0 => 'Serial',
    1 => 'Pulseled',
    2 => 'Gesture',
    3 => 'RawData',
    4 => 'ScanCode',
  }

  # type = LED
  EVENTS[17] = {
    0 => 'NumLock',
    1 => 'CapsLock',
    2 => 'ScrollLock',
    3 => 'Compose',
    4 => 'Kana',
    5 => 'Sleep',
    6 => 'Suspend',
    7 => 'Mute',
    8 => 'Misc',
  }

  # type = Sound
  EVENTS[18] = {
    0 => 'Click',
    1 => 'Bell',
    2 => 'Tone',
  }

  # type = Repeat
  EVENTS[20] = {
    0 => 'Delay',
    1 => 'Period',
  }
end
