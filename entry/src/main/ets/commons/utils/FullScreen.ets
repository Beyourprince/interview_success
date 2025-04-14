import { window } from '@kit.ArkUI';

class FullScreen {
  // 开启 记录 顶部+底部的间隙
  async enable() {
    // 获取窗口对象
    const context = AppStorage.get<Context>('context');

    if (context) {
      // 开启沉浸式
      // 上下文对象获取窗口（上下文对象很多地方都需要）
      const win = await window.getLastWindow(context);
      win.setWindowLayoutFullScreen(true)
      // 2. 获取布局避让遮挡的区域
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 以导航条避让为例
      let avoidArea = win.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea.bottomRect.height; // 获取到导航条区域的高度
      AppStorage.setOrCreate('bottomHeight', px2vp(bottomRectHeight));

      type = window.AvoidAreaType.TYPE_SYSTEM; // 以状态栏避让为例
      avoidArea = win.getWindowAvoidArea(type);
      let topRectHeight = avoidArea.topRect.height; // 获取状态栏区域高度
      AppStorage.setOrCreate('topHeight', px2vp(topRectHeight));
    }
  }

  // 关闭 清空 顶部+底部的间隙
  async disable() {
    // 获取窗口对象
    const context = AppStorage.get<Context>('context');

    if (context) {
      // 开启沉浸式
      const win = await window.getLastWindow(context);
      win.setWindowLayoutFullScreen(false)
      AppStorage.setOrCreate('topHeight', 0);
      AppStorage.setOrCreate('bottomHeight', 0);


    }
  }
}

export const fullScreen = new FullScreen()