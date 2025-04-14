import { hilog } from '@kit.PerformanceAnalysisKit'


class Logger{
  private domain:number
  private tag:string
  constructor(domain:number=0xFF00,tag:string='InterviewSuccess') {
    this.domain=domain
    this.tag=tag
  }

  info(...args:string[]){
    hilog.info(this.domain, this.tag, "%{public}s %{public}s ",args);
  }
  debug(...args:string[]){
    hilog.debug(this.domain, this.tag, "%{public}s %{public}s ",args);
  }
  warn(...args:string[]){
    hilog.warn(this.domain, this.tag, "%{public}s %{public}s ",args);
  }
  error(...args:string[]){
    hilog.error(this.domain, this.tag, "%{public}s %{public}s ",args);
  }
  fatal(...args:string[]){
    hilog.fatal(this.domain, this.tag, "%{public}s %{public}s ",args);
  }
}

// 后续任何一个位置要使用，都是这个实例化对象
export const logger = new Logger()

