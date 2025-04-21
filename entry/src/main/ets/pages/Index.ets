// tab的数据
import  HomePage  from './HomePage';
import  InterViewPage  from './InterviewPage';
import  {MinePage}  from './MinePage';
import  ProjectPage  from './ProjectPage';

// 图片（默认，高亮），文字
interface TabItem {
  icon: Resource; // 默认图片
  activeIcon: Resource; // 高亮图片
  name: string; // 文字
}

@Entry
@Component
struct Index {
  //  StorageProp 单向 还是双向？
  @StorageProp('topHeight')
  topHeight: number = 0;
  @StorageProp('bottomHeight')
  bottomHeight: number = 0;
  @State
  activeIndex: number = 0
  // 定义变量
  tabList: TabItem[] = [
    {
      icon: $r('app.media.tabbar_home'),
      activeIcon: $r('app.media.tabbar_home_fill'),
      name: '首页'
    },
    {
      icon: $r('app.media.tabbar_project'),
      activeIcon: $r('app.media.tabbar_project_fill'),
      name: '项目'
    },
    {
      icon: $r('app.media.tabbar_interview'),
      activeIcon: $r('app.media.tabbar_interview_fill'),
      name: '面经'
    },
    {
      icon: $r('app.media.tabbar_mine'),
      activeIcon: $r('app.media.tabbar_mine_fill'),
      name: '我的'
    }
  ]

  @Builder
  tabBuilder(item: TabItem, index: number) {
    Column({ space: 5 }) {
      Image(this.activeIndex === index ? item.activeIcon : item.icon)
        .width(25)
      Text(item.name)
        .fontSize(14)
        .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_03'))
    }
  }

  build() {
    Column() {
      // 默认是第 0 个，如果要指定其他的可以设置一下，为 0 可以省略不写
      Tabs({ index: this.activeIndex }) {
        ForEach(this.tabList, (item: TabItem, index) => {
          TabContent() {
            if (index === 0) {
              HomePage()
            } else if (index === 1) {
              ProjectPage()
            } else if (index === 2) {
              InterViewPage()
            } else {
              MinePage()
            }
          }
          .tabBar(this.tabBuilder(item, index))
        })
      }
      .scrollable(false)
      .barPosition(BarPosition.End)
      .onTabBarClick(index => this.activeIndex = index)
    }
    .padding({ bottom: this.bottomHeight })
  }
}