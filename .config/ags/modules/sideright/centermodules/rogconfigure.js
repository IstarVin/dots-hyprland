import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { ConfigSpinButton } from '../../.commonwidgets/configwidgets.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { Box, Scrollable } = Widget;
const { exec } = Utils;

export default (props) => {

  const mainContent = Scrollable({
    vexpand: true,
    child: Box({
      vertical: true,
      className: 'spacing-v-10',
      children: [
        ConfigSpinButton({
          icon: "charger",
          name: "Charge Limit",
          desc: "Battery stops charging when reach limit. (20-100)",
          initValue: Number(exec(`bash -c "cat /etc/asusd/asusd.ron | grep -oP 'charge_control_end_threshold: \K\d+' | cut -d',' -f1"`)),
          step: 1, minValue: 20, maxValue: 100,
          onChange: (_, newVal) => {
            Utils.execAsync(`asusctl -c ${newVal}`).catch(print)
          }
        }),
        // ConfigSection({
        //     name: "Asusctl",
        //     children: []
        // }),
        // ConfigSection({
        //     name: "Supergfx",
        //     children: []
        // })
      ]
    })
  })

  return Box({
    ...props,
    className: 'spacing-v-5',
    vertical: true,
    children: [
      mainContent,
      // footNote,
    ]
  })
}
