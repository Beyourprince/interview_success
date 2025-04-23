import HcTag from "../../commons/components/HcTag"
import QuestionListComp from "../../commons/components/QuestionListComp"
import { QuestionType, SortType } from "../../models"
import { http } from '../../commons/utils/Http'
import { DataType } from "@kit.MediaLibraryKit"
import { HcSkeleton } from "../../commons/components/HcSkeleton"
import { HcSkeletonItem } from "../../commons/components/HcSkeletonItem"
import { emitter } from "@kit.BasicServicesKit"
import { LOGIN_EVENT } from "../../commons/constants"

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
  @State activeIndex: number = 0 //当前所在分类
  @State isShow: boolean = false
  @State filterDataIndex: number = 0
  @State filterDataSort: SortType = SortType.Default
  @State sort: SortType = SortType.Default
  // 加载
  @State loading: boolean = false

  aboutToAppear(): void {
    this.getQuestionTypeList()
    emitter.on(LOGIN_EVENT, () => {
      this.getQuestionTypeList()
    })
  }

  async getQuestionTypeList() {
    this.loading = true
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    this.questionTypeList = res
    this.loading = false
  }

  build() {
    if (this.loading) {
      this.SkeletonBuilder()
    } else {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ index: this.activeIndex }) {
          ForEach(this.questionTypeList, (item: QuestionType, index) => {
            TabContent() {
              QuestionListComp({
                typeId: item.id,
                sort: this.sort,
                activeIndex: this.activeIndex,
                index: index
              })
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
          this.filterDataIndex = this.activeIndex
        })
      }
    }
  }

  // 试题分类
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

  // 筛选弹窗
  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
          .onClick(() => {
            this.filterDataIndex = 0
            this.filterDataSort = SortType.Default
          })
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
          .onClick(() => {
            this.isShow = false
            this.activeIndex = this.filterDataIndex
            this.sort = this.filterDataSort
          })
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

  @Builder
  SkeletonBuilder() {
    HcSkeleton() {
      Column() {
        Row({ space: 16 }) {
          HcSkeletonItem({ widthValue: 60 })
          HcSkeletonItem({ widthValue: 100 })
          HcSkeletonItem({ widthValue: 80 })
          HcSkeletonItem({ widthValue: 40 })
        }
        .height(44)
        .width('100%')

        ForEach([1, 2, 3, 4, 5, 6], () => {
          Column({ space: 10 }) {
            HcSkeletonItem({ widthValue: '90%' })
            HcSkeletonItem({ widthValue: '45%' })
          }
          .height(80)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        })
      }
      .padding({ left: 16, right: 16 })
    }
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