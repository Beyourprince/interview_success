import HcTag from "../../commons/components/HcTag"
import QuestionListComp from "../../commons/components/QuestionListComp"
import { QuestionType } from "../../models"
import { http } from '../../commons/utils/Http'

const mockData: QuestionType[] = []

@Component
struct HomeCategory {
  @State questionTypeList: QuestionType[] = mockData
  @State activeIndex: number = 0

  aboutToAppear(): void {
    this.getQuestionTypeList()
  }

  async getQuestionTypeList() {
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    console.log('+++res:' + JSON.stringify(res))
    this.questionTypeList = res
  }

  build() {
    Tabs() {
      ForEach(this.questionTypeList, (item: QuestionType, index) => {
        TabContent() {
          QuestionListComp({typeId:item.id})
        }.tabBar(this.tabBarBuilder(item, index))
      }, (item: QuestionType) => item.id.toString())
    }.barMode(BarMode.Scrollable)
    .divider({
      strokeWidth: 1
    })
    .layoutWeight(1)
    .onTabBarClick(index => this.activeIndex = index)
  }

  @Builder
  tabBarBuilder(item: QuestionType, index: number) {
    Row({ space: 4 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(item.name)
          .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_01'))
          .height(40)
        // 标记线
        Text()
          .width(this.activeIndex === index ? 20 : 0)
          .height(this.activeIndex === index ? 2 : 0)
          .backgroundColor($r('app.color.black'))
          .animation({ duration: this.activeIndex === index ? 300 : 0 })
      }.height(40)

      if (item.displayNewestFlag) {
        Image($r('app.media.ic_home_new')).width(30)
      }
    }.margin({ right: 10, left: 10 })
  }
}

export default HomeCategory