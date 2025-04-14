import { HcClockIn } from "../commons/components/HcClockIn"
import HcSearchBox from "../commons/components/HcSearchBox"

@Component
struct HomePage {
  build() {
    Column(){
      Row({space:10}){
        Image($r('app.media.ic_home_scan')).width(20)
          .margin({left:10})
        HcSearchBox({layoutWeightValue:1})
        HcClockIn({clockInCount:10})
      }.width('100%')
      .padding({right:10})
    }
    .width('100%')
    .height('100%')
  }
}
export default HomePage