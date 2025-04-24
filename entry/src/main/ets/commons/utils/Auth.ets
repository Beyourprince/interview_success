import { User } from '../../models'
import { router } from '@kit.ArkUI'

export const UserStoreKey = 'hc-user'

class Auth {
  initUser() {
    PersistentStorage.persistProp<User>(UserStoreKey, {} as User)
  }

  getUser() {
    return AppStorage.get<User>(UserStoreKey) || {} as User
  }

  setUser(user: User) {
    AppStorage.setOrCreate<User>(UserStoreKey, user)
  }

  checkAuth(options: router.RouterOptions | Function) {
    const user = this.getUser()
    if (user.token) {
      if (typeof options === 'function') {
        options()
      } else {
        router.pushUrl(options)
      }
    } else {
      // 未登录，拦截到登录页
      if (typeof options === 'function') {
        router.pushUrl({ url: 'pages/LoginPage' })
      } else {
        // 带上 return_url 用户登录回跳
        const params = options.params as Record<string, string> || {}
        params.return_url = options.url
        router.pushUrl({ url: 'pages/LoginPage', params })
      }
    }
  }
}

export const auth = new Auth()