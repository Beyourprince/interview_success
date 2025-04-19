import HcTag from "../../commons/components/HcTag"
import QuestionListComp from "../../commons/components/QuestionListComp"
import { QuestionType, SortType } from "../../models"
import { http } from '../../commons/utils/Http'
import { DataType } from "@kit.MediaLibraryKit"

const mockData: QuestionType[] = []

@Extend(Text)
function textTitle() {
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.black'))
  .width('100%')
  .margin({ top: 20 })
}

@Component
struct HomeCategory {
  @State questionTypeList: QuestionType[] = mockData
  @State activeIndex: number = 0
  @State isShow: boolean = false
  @State filterDataIndex: number = 0
  @State filterDataSort: SortType = SortType.Default

  aboutToAppear(): void {
    this.getQuestionTypeList()
  }

  async getQuestionTypeList() {
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    console.log('+++res:' + JSON.stringify(res))
    this.questionTypeList = res
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Tabs() {
        ForEach(this.questionTypeList, (item: QuestionType, index) => {
          TabContent() {
            QuestionListComp({ typeId: item.id })
          }.tabBar(this.tabBarBuilder(item, index))
        }, (item: QuestionType) => item.id.toString())
      }
      .barMode(BarMode.Scrollable)
      .barHeight(44)
      .divider({
        strokeWidth: 1
      })
      .layoutWeight(1)
      .onTabBarClick(index => this.activeIndex = index)

      Row() {
        Image($r('app.media.ic_home_filter'))
          .width(34)
      }
      .width(54)
      .height(44)
      .linearGradient({ angle: 90, colors: [['#00FFFFFF', 0], ['#FFFFFF', 0.285]] })
      .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
        showClose: false,
        height: 400
      })
      .onClick(() => {
        this.isShow = true
      })
    }
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
    }.margin({ right: index === this.questionTypeList.length - 1 ? 70 : 10, left: 10 })
  }

  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
        Text('筛选题目')
          .layoutWeight(1)
          .fontSize(18)
          .fontWeight(500)
          .fontColor($r('app.color.black'))
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      // 排序方式
      Flex({ wrap: FlexWrap.Wrap }) {
        FilterButton({
          text: '默认',
          sort: this.filterDataSort,
          selected: this.filterDataSort === SortType.Default
        }).onClick(() => {
          this.filterDataSort = SortType.Default
        })
        FilterButton({
          text: '浏览量',
          isSort: true,
          sort: this.filterDataSort,
          selected: [SortType.ViewLow, SortType.ViewHigh].includes(this.filterDataSort)
        }).onClick(() => {
          if ([SortType.ViewLow, SortType.ViewHigh].includes(this.filterDataSort)) {
            this.filterDataSort = this.filterDataSort === SortType.ViewLow ? SortType.ViewHigh : SortType.ViewLow
          } else {
            this.filterDataSort = SortType.ViewLow
          }
        })
        FilterButton({
          text: '难度',
          isSort: true,
          sort: this.filterDataSort,
          selected: [SortType.DifficultyLow, SortType.DifficultyHigh].includes(this.filterDataSort)
        }).onClick(() => {
          if ([SortType.DifficultyLow, SortType.DifficultyHigh].includes(this.filterDataSort)) {
            this.filterDataSort =
              this.filterDataSort === SortType.DifficultyLow ? SortType.DifficultyHigh : SortType.DifficultyLow
          } else {
            this.filterDataSort = SortType.DifficultyLow
          }
        })
        FilterButton({
          text: '推荐',
          sort: this.filterDataSort,
          selected: this.filterDataSort === SortType.Commend
        }).onClick(() => {
          this.filterDataSort = SortType.Commend
        })
      }

      Text('选择分类')
        .textTitle()
      // 选择分类
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionTypeList, (item: QuestionType, i: number) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag === 1,
            selected: i === this.filterDataIndex
          })
            .onClick(() => {
              this.filterDataIndex = i
            })
        })
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }
}


@Component
struct FilterButton {
  text: string = ''
  isNew: boolean = false
  isSort: boolean = false
  @Prop selected: boolean = false
  @Prop sort: SortType = SortType.Default

  build() {
    Row() {
      Text(this.text)
        .fontSize(12)
        .fontColor(this.selected ? $r('app.color.common_main_color') : $r('app.color.black'))
      if (this.isNew) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .position({ right: -26, top: -7 })
      }
      if (this.isSort) {
        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_up'))
            .size({ width: 12, height: 6 })
            .fillColor(this.selected && this.sort % 2 === 1 ? $r('app.color.common_main_color') : $r('app.color.black'))
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .size({ width: 12, height: 6 })
            .fillColor(this.selected && this.sort % 2 === 0 ? $r('app.color.common_main_color') : $r('app.color.black'))
        }
        .margin({ top: -0.5, left: 2 })
      }
    }
    .height(30)
    .padding({ left: 10, right: 10 })
    .backgroundColor($r('app.color.common_gray_bg'))
    .borderRadius(4)
    .margin({ top: 12, right: this.isNew ? 26 : 10 })
  }
}

export default HomeCategory