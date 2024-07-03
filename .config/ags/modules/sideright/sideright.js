import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { execAsync, exec } = Utils;
const { Box, EventBox } = Widget;
import {
    ToggleIconBluetooth,
    ToggleIconWifi,
    HyprToggleIcon,
    ModuleNightLight,
    ModuleInvertColors,
    ModuleIdleInhibitor,
    ModuleEditIcon,
    ModuleReloadIcon,
    ModuleSettingsIcon,
    ModulePowerIcon,
    ModuleRawInput,
    ModuleCloudflareWarp
} from "./quicktoggles.js";
import ModuleNotificationList from "./centermodules/notificationlist.js";
import ModuleAudioControls from "./centermodules/audiocontrols.js";
import ModuleWifiNetworks from "./centermodules/wifinetworks.js";
import ModuleBluetooth from "./centermodules/bluetooth.js";
import ModuleConfigure from "./centermodules/configure.js";
import ModuleROGConfigure from "./centermodules/rogconfigure.js";
import { ModuleCalendar } from "./calendar.js";
import { getDistroIcon } from '../.miscutils/system.js';
import { MaterialIcon } from '../.commonwidgets/materialicon.js';
import { ExpandingIconTabContainer } from '../.commonwidgets/tabcontainer.js';
import { checkKeybind } from '../.widgetutils/keybind.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

const centerWidgets = [
    {
        name: 'Notifications',
        materialIcon: 'notifications',
        contentWidget: ModuleNotificationList,
    },
    {
        name: 'Audio controls',
        materialIcon: 'volume_up',
        contentWidget: ModuleAudioControls,
    },
    {
        name: 'Bluetooth',
        materialIcon: 'bluetooth',
        contentWidget: ModuleBluetooth,
    },
    {
        name: 'Wifi networks',
        materialIcon: 'wifi',
        contentWidget: ModuleWifiNetworks,
        onFocus: () => execAsync('nmcli dev wifi list').catch(print),
    },
    {
        name: 'Live config',
        materialIcon: 'tune',
        contentWidget: ModuleConfigure,
    },
    {
        name: 'ROG Config',
        materialIcon: 'laptop_windows',
        contentWidget: ModuleROGConfigure,
    },
];

function _secondsToHms(d) {
    d = Number(d);
    var h = Math.floor(d / 3600);
    var m = Math.floor(d % 3600 / 60);
    var s = Math.floor(d % 3600 % 60);

    var hDisplay = h > 0 ? h + (h == 1 ? " hour" : " hours") : "";
    var mDisplay = ", " m > 0 ? m + (m == 1 ? " minute" : " minutes") : "";
    var sDisplay = ", " s > 0 ? s + (s == 1 ? " second" : " seconds") : "";

    return (hDisplay == "" && mDisplay == "") ? sDisplay: hDisplay + mDisplay; 
}

const timeRow = Box({
    className: 'spacing-h-10 sidebar-group-invisible-morehorizpad',
    children: [
        Widget.Icon({
            icon: getDistroIcon(),
            className: 'txt txt-larger',
        }),
        Widget.Revealer({
            transitionDuration: userOptions.animations.durationSmall,
            transition: 'slide_right',
            revealChild: false,
            child: Widget.Label({
                hpack: 'center',
                className: 'txt-small txt',
                setup: (self) => {
                    const getUptime = async () => {
                        try {
                            await execAsync(['bash', '-c', 'uptime -p']);
                            return execAsync(['bash', '-c', `uptime -p | sed -e 's/...//;s/ day\\| days/d/;s/ hour\\| hours/h/;s/ minute\\| minutes/m/;s/,[^,]*//2'`]);
                        } catch {
                            return execAsync(['bash', '-c', 'uptime']).then(output => {
                                const uptimeRegex = /up\s+((\d+)\s+days?,\s+)?((\d+):(\d+)),/;
                                const matches = uptimeRegex.exec(output);
    
                                if (matches) {
                                    const days = matches[2] ? parseInt(matches[2]) : 0;
                                    const hours = matches[4] ? parseInt(matches[4]) : 0;
                                    const minutes = matches[5] ? parseInt(matches[5]) : 0;
    
                                    let formattedUptime = '';
    
                                    if (days > 0) {
                                        formattedUptime += `${days} d `;
                                    }
                                    if (hours > 0) {
                                        formattedUptime += `${hours} h `;
                                    }
                                    formattedUptime += `${minutes} m`;
    
                                    return formattedUptime;
                                } else {
                                    throw new Error('Failed to parse uptime output');
                                }
                            });
                        }
                    };
    
                    self.poll(5000, label => {
                        getUptime().then(upTimeString => {
                            label.label = `Uptime: ${upTimeString}`;
                        }).catch(err => {
                            console.error(`Failed to fetch uptime: ${err}`);
                        });
                    });
                },
            }),
            setup: (self) => self.hook(Battery, (self) => {
                self.revealChild = Battery.energy_rate === 0
            })
        }),

        Widget.Revealer({
            transitionDuration: userOptions.animations.durationSmall,
            transition: 'slide_right',
            revealChild: true,
            child: Box({
                className: "spacing-h-10",
                children: [
                    Widget.Label({
                        hpack: 'center',
                        className: 'txt-small txt',
                        setup: (self) => self
                            .hook(Battery, (self) => {
                                execAsync(['bash', '-c', 'cat /tmp/since-time.txt'])
                                    .then(sinceTime => {
                                        self.label = `Uptime: ${_secondsToHms((Date.now() - Number(sinceTime)) / 1000)}`
                                    })
                                    .catch(print)
                            })
                        ,
                    }),
                    Widget.Label({
                        hpack: 'center',
                        className: 'txt-small txt',
                        setup: (self) => self
                            .hook(Battery, (self) => {
                                self.label = `(${Number(Utils.exec('cat /tmp/since.txt').replace('%', '')) - Battery.percent}%)`
                            })
                    }),
                ]
            }),

            setup: (self) => self.hook(Battery, (self) => {
                if (Battery.charging) {
                    Utils.exec(['bash', '-c', "upower -i $(upower -e | grep BAT) | awk '/percentage:/ {print $2}' > /tmp/since.txt"])
                    Utils.exec(['bash', '-c', `echo ${Date.now()} > /tmp/since-time.txt`])
                }
                self.revealChild = Battery.energy_rate !== 0 && !Battery.charging
            })
        }),
        Widget.Revealer({
            transitionDuration: userOptions.animations.durationSmall,
            transition: 'slide_right',
            revealChild: false,
            child: Widget.Label({
                hpack: 'center',
                className: 'text-small txt',
                setup: (self) => self
                    .hook(Battery, (self) => {
                        self.label = `Time to full: ${_secondsToHms(Battery.time_remaining)}`
                    })
            }),
            setup: (self) => self.hook(Battery, (self) => {
                self.revealChild = Battery.energy_rate !== 0 && Battery.charging
            })
        }),

        Widget.Box({ hexpand: true }),
        // ModuleEditIcon({ hpack: 'end' }), // TODO: Make this work
        ModuleReloadIcon({ hpack: 'end' }),
        ModuleSettingsIcon({ hpack: 'end' }),
        ModulePowerIcon({ hpack: 'end' }),
    ]
});

const togglesBox = Widget.Box({
    hpack: 'center',
    className: 'sidebar-togglesbox spacing-h-5',
    children: [
        ToggleIconWifi(),
        ToggleIconBluetooth(),
        // await ModuleRawInput(),
        // await HyprToggleIcon('touchpad_mouse', 'No touchpad while typing', 'input:touchpad:disable_while_typing', {}),
        await ModuleNightLight(),
        await ModuleInvertColors(),
        ModuleIdleInhibitor(),
        await ModuleCloudflareWarp(),
    ]
})

export const sidebarOptionsStack = ExpandingIconTabContainer({
    tabsHpack: 'center',
    tabSwitcherClassName: 'sidebar-icontabswitcher',
    icons: centerWidgets.map((api) => api.materialIcon),
    names: centerWidgets.map((api) => api.name),
    children: centerWidgets.map((api) => api.contentWidget()),
    onChange: (self, id) => {
        self.shown = centerWidgets[id].name;
        if (centerWidgets[id].onFocus) centerWidgets[id].onFocus();
    }
});

export default () => Box({
    vexpand: true,
    hexpand: true,
    css: 'min-width: 2px;',
    children: [
        EventBox({
            onPrimaryClick: () => App.closeWindow('sideright'),
            onSecondaryClick: () => App.closeWindow('sideright'),
            onMiddleClick: () => App.closeWindow('sideright'),
        }),
        Box({
            vertical: true,
            vexpand: true,
            className: 'sidebar-right spacing-v-15',
            children: [
                Box({
                    vertical: true,
                    className: 'spacing-v-5',
                    children: [
                        timeRow,
                        togglesBox,
                    ]
                }),
                Box({
                    className: 'sidebar-group',
                    children: [
                        sidebarOptionsStack,
                    ],
                }),
                ModuleCalendar(),
            ]
        }),
    ],
    setup: (self) => self
        .on('key-press-event', (widget, event) => { // Handle keybinds
            if (checkKeybind(event, userOptions.keybinds.sidebar.options.nextTab)) {
                sidebarOptionsStack.nextTab();
            }
            else if (checkKeybind(event, userOptions.keybinds.sidebar.options.prevTab)) {
                sidebarOptionsStack.prevTab();
            }
        })
    ,
});
