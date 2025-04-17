import { HcClockIn } from "../commons/components/HcClockIn"
import HcSearchBox from "../commons/components/HcSearchBox"
import QuestionItemComp from "../commons/components/QuestionItemComp"
import HomeCategory from "../views/Home/HomeCategory"

@Component
struct HomePage {
  @Builder
  SwiperItemBuilder(src: ResourceStr) {
    Row() {
      Image(src)
        .width('100%')
        .aspectRatio(2.65)
        .objectFit(ImageFit.Fill)
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
  build() {
    Column(){
      // 1头部
      Row({space:10}){
        Image($r('app.media.ic_home_scan')).width(20)
          .margin({left:10})
        HcSearchBox({layoutWeightValue:1})
        HcClockIn({clockInCount:10})
      }.width('100%')
      .padding({right:10})

      // 2轮播图

      Swiper(){
        ForEach([$r('app.media.banner_ai'), $r('app.media.banner_pj'), $r('app.media.banner_qa')],
          (item: ResourceStr) => {
            this.SwiperItemBuilder(item)
          })
      }.padding({top:15,bottom:15})
      .autoPlay(true)
      .interval(1000)
      .indicator(
        DotIndicator.dot().itemWidth(10).itemHeight(10)
          .selectedItemWidth(15)
          .selectedItemHeight(15)
          .color($r('app.color.common_gray_01'))
          .selectedColor($r('app.color.common_green'))
      )

      // 3.试题分类
      HomeCategory()
      // QuestionItemComp({
      //   item:{
      //     id:'1',
      //     stem:'震惊，竟然已经到了 2025 年。过完年之后又要上班啦~',
      //     views:10,
      //     likeCount:20,
      //     difficulty:2,
      //     readFlag:0
      //   }
      // })
    }
    .width('100%')
    .height('100%')
  }
}
export default HomePage