import QuestionItemComp from "./QuestionItemComp"

@Component
struct QuestionListComp {
  @State isRefreshing: boolean = false
  // 是否加载完成
  @State isFinished: boolean = true
  // 正在加载中...
  @State isLoading: boolean = false

  // 模拟1秒更新完成
  onRefresh() {
    setTimeout(() => {
      this.isRefreshing = false
    }, 1000)
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(Array.from({ length: 10 }), (item: number) => {
          ListItem() {
            QuestionItemComp({
              item: {
                id: '1',
                stem: '蛇年大吉',
                difficulty: 1,
                likeCount: 10,
                views: 2,
                readFlag: 1
              }
            })
          }
        })
        this.LoadMoreBuilder()
      }
      .width('100%')
      .height('100%')
      .divider({
        strokeWidth: 2,
        color: $r('app.color.home_gray'),
        startMargin: 10,
        endMargin: 10
      })
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
    }
    .onRefreshing(() => {
      this.onRefresh()
    })
  }

  @Builder
  LoadMoreBuilder() {
    ListItem() {
      // 加载完成
      if (this.isFinished) {
        Row() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      // 没有加载完成且正在加载中
      else if (this.isLoading) {
        Row({ space: 4 }) {
          LoadingProgress()
            .width(20)
          Text('正在加载...')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
    }
    .height(80)
  }
}

export default QuestionListComp