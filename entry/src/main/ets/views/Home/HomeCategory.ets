import HcTag from "../../commons/components/HcTag"
import { QuestionType } from "../../models"
const mockData: QuestionType[] = [
  { id: 1, name: 'ArkTS', displayNewestFlag: 0 },
  { id: 2, name: 'ArkUI', displayNewestFlag: 1 },
  { id: 3, name: 'Hap', displayNewestFlag: 1 },
  { id: 4, name: 'Hsp', displayNewestFlag: 0 },
  { id: 5, name: 'Har', displayNewestFlag: 0 },
  { id: 6, name: 'Ability', displayNewestFlag: 0 },
  { id: 7, name: 'Stage', displayNewestFlag: 0 },
  { id: 8, name: 'Kit', displayNewestFlag: 0 }
]
@Component
struct HomeCategory {
  @State questionTypeList: QuestionType[] = mockData
  @State activeIndex: number = 0
  build() {
    Tabs(){
      ForEach(this.questionTypeList,(item:QuestionType,index)=>{
         TabContent(){
         HcTag({difficulty:5})
         }.tabBar(this.tabBarBuilder(item,index))
      },(item:QuestionType)=>item.id.toString())
    }.barMode(BarMode.Scrollable)
    .divider({
      strokeWidth:1
    })
    .layoutWeight(1)
    .onTabBarClick(index=>this.activeIndex=index)
  }
  @Builder tabBarBuilder(item:QuestionType,index:number){
  Row({space:4}){
    Stack({alignContent:Alignment.Bottom}) {
      Text(item.name)
        .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_01'))
        .height(40)
      // 标记线
      Text()
        .width(this.activeIndex===index?20:0)
        .height(this.activeIndex===index?2:0)
        .backgroundColor($r('app.color.black'))
        .animation({ duration: this.activeIndex === index ? 300 : 0 })
    }.height(40)
    if(item.displayNewestFlag) {
      Image($r('app.media.ic_home_new')).width(30)
    }
  }.margin({right:10,left:10})
  }
}
export default HomeCategory