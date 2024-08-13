import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
const { execAsync } = Utils;
import Indicator from '../../../services/indicator.js';
import { StatusIcons } from '../../.commonwidgets/statusicons.js';
import { Tray } from "./tray.js";
import { setupCursorHover } from '../../.widgetutils/cursorhover.js';
import { coffeeStatus } from '../../../variables.js';
import { MaterialIcon } from '../../.commonwidgets/materialicon.js';

const powerProfiles = await Service.import('powerprofiles')

const SeparatorDot = () => Widget.Revealer({
    transition: 'slide_left',
    revealChild: false,
    attribute: {
        'count': SystemTray.items.length,
        'update': (self, diff) => {
            self.attribute.count += diff;
            self.revealChild = (self.attribute.count > 0);
        }
    },
    child: Widget.Box({
        vpack: 'center',
        className: 'separator-circle',
    }),
    setup: (self) => self
        .hook(SystemTray, (self) => self.attribute.update(self, 1), 'added')
        .hook(SystemTray, (self) => self.attribute.update(self, -1), 'removed')
    ,
});

// const NumUpdatePackageIndicator = Widget.Label({
//   className: 'txt-small txt',
//   setup: (self) => self.poll(43200000, label => {
//     execAsync(['bash', '-c', 'checkupdates | wc -l']).then(out => {
//       if (Number(out) == 0) {
//         label.label = ``
//         label.tooltipText = 'All package are up to date'
//       } else {
//         label.label = `󰮯  ${out}`
//       }
//     })
//   })
// })

const ActiveProfile = Widget.Button({
    child: Widget.Label({
        className: 'txt-large icon-material',
        // label: powerProfiles.bind('active_profile'),
        setup: self => self.hook(powerProfiles, label => {
            switch (powerProfiles.active_profile) {
                case 'performance':
                    label.label = "speed"
                    label.tooltipText = "Performance"
                    break
                case 'balanced':
                    label.label = "token"
                    label.tooltipText = "Balanced"
                    break
                case 'power-saver':
                    label.label = "data_saver_on"
                    label.tooltipText = "Power Saver"
                    break
            }
            // label.label = powerProfiles.active_profile
        })
    }),
    onPrimaryClick: () => {
        if (powerProfiles.active_profile === "performance") {
            powerProfiles.active_profile = "power-saver"
        } else {
            powerProfiles.active_profile = "performance"
        }
    },
    onMiddleClick: () => powerProfiles.active_profile = "balanced",
    setup: setupCursorHover
})

const CoffeMode = Widget.Revealer({
    child: Widget.Button({
        child: Widget.Label({
            className: "icon-material txt-large",
            label: "coffee"
        })
    }),
    revealChild: coffeeStatus.bind()
})

export default (monitor = 0) => {
    const barTray = Tray();
    const barStatusIcons = StatusIcons({
        className: 'bar-statusicons',
        setup: (self) => self.hook(App, (self, currentName, visible) => {
            if (currentName === 'sideright') {
                self.toggleClassName('bar-statusicons-active', visible);
            }
        }),
    }, monitor);
    const SpaceRightDefaultClicks = (child) => Widget.EventBox({
        onHover: () => { barStatusIcons.toggleClassName('bar-statusicons-hover', true) },
        onHoverLost: () => { barStatusIcons.toggleClassName('bar-statusicons-hover', false) },
        onPrimaryClick: () => App.toggleWindow('sideright'),
        onSecondaryClick: () => execAsync(['bash', '-c', 'playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"` &']).catch(print),
        onMiddleClick: () => execAsync('playerctl play-pause').catch(print),
        setup: (self) => self.on('button-press-event', (self, event) => {
            if (event.get_button()[1] === 8)
                execAsync('playerctl previous').catch(print)
        }),
        child: child,
    });
    const emptyArea = SpaceRightDefaultClicks(Widget.Box({ hexpand: true, }));
    const indicatorArea = SpaceRightDefaultClicks(Widget.Box({
        children: [
            SeparatorDot(),
            barStatusIcons
        ],
    }));
    const actualContent = Widget.Box({
        hexpand: true,
        className: 'spacing-h-5 bar-spaceright',
        children: [
            // NumUpdatePackageIndicator,
            emptyArea,
            barTray,
            CoffeMode,
            ActiveProfile,
            indicatorArea,
        ],
    });

    return Widget.EventBox({
        onScrollUp: () => {
            if (!Audio.speaker) return;
            if (Audio.speaker.volume <= 0.09) Audio.speaker.volume += 0.01;
            else Audio.speaker.volume += 0.03;
            Indicator.popup(1);
        },
        onScrollDown: () => {
            if (!Audio.speaker) return;
            if (Audio.speaker.volume <= 0.09) Audio.speaker.volume -= 0.01;
            else Audio.speaker.volume -= 0.03;
            Indicator.popup(1);
        },
        child: Widget.Box({
            children: [
                actualContent,
                SpaceRightDefaultClicks(Widget.Box({ className: 'bar-corner-spacing' })),
            ]
        })
    });
}
