import { window } from '@kit.ArkUI'

class StatusBar {
  async setDarkBar() {
    await this.setBar({
      statusBarContentColor: '#000000'
    })
  }

  async setLightBar() {
    await this.setBar({
      statusBarContentColor: '#ffffff'
    })
  }

  async setBar(props: window.SystemBarProperties) {
    const context = AppStorage.get<Context>('context')
    if (context) {
      const win = await window.getLastWindow(context)
      win.setWindowSystemBarProperties(props)
    }
  }
}

export const statusBar = new StatusBar()