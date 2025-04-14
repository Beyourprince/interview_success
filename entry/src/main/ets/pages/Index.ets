import HomePage from './HomePage';
import InterviewPage from './InterviewPage';
import MinePage from './MinePage';
import ProjectPage from './ProjectPage';

// 图片（默认，高亮），文字
interface TabItem {
  icon: Resource; // 默认图片
  activeIcon: Resource; // 高亮图片
  name: string; // 文字
}
@Entry
@Component
struct Index {
@State activeIndex:number=0
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
  build() {
    Column() {
      Tabs({barPosition:BarPosition.End}){
       ForEach(this.tabList,(item:TabItem,index)=>{
         TabContent(){
           if(index===0){
       HomePage()
           }else if(index===1){
             ProjectPage()
           }else if(index===2){
             InterviewPage()
           }else {
             MinePage()
           }
         }
         .tabBar(this.tabBuilder(item,index))
       })
      }.onTabBarClick(index=>this.activeIndex=index)
    }
    .height('100%')
    .width('100%')
  }
  @Builder tabBuilder(item:TabItem,index:number){
    Column({space:5}){
      Image(this.activeIndex===index?item.activeIcon:item.icon).width(25)
      Text(item.name).fontSize(14)
        .fontColor(this.activeIndex===index?$r('app.color.black'):$r('app.color.common_green'))
    }
  }
}