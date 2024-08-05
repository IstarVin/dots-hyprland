// For every option, see ~/.config/ags/modules/.configuration/user_options.js
// (vscode users ctrl+click this: file://./modules/.configuration/user_options.js)
// (vim users: `:vsp` to split window, move cursor to this path, press `gf`. `Ctrl-w` twice to switch between)
//   options listed in this file will override the default ones in the above file

const userConfigOptions = {
    'ai': {
        'defaultGPTProvider': "oxygen3",
    },
    'apps': {
        'taskManager': 'gnome-system-monitor'
    },
    'appearance': {
        'fakeScreenRounding': 2
    },
    'time': {
        'format': '%I:%M %p',
        'interval': 60000,
        'dateInterval': 3600000,
    },
    'search': {
        'engineBaseUrl': "https://search.brave.com/search?q=",
        'excludedSites': [],
    },
    'workspaces': {
        'shown': 10,
    },
    'sidebar': {
        'pages': {
            'apis': {
                'order': ['gpt', 'gemini', 'waifu', 'booru']
            }
        }
    }
}

export default userConfigOptions;
