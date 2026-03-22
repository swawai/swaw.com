1. 此为基于hugo编译的MPA静态web项目并接入nodejs / package.json  
2. 站点模板/ui/新功能等相关修订都应该针对主题themes/banyan/进行，而业务内容/定制化（主题已支持）的才是在根目录中实现  
3. 内部模块推崇扁平化、声明式，勿随意使用包装  
    如 a:call:x; b:call:x, 然后X内部：if a…… if b……, 调用者完全知道自己想要什么，压平则为：xa;xb，a:call:xa; b:call:xb，少一层中间判断，而且更具“声明式”  
    如 a(b);b(c) 压平为：a(c), 少一层中间套娃  
4. hugo默认生成 public/，测试可编译到 public-yymmddhhmm-{notes}, （.gitignore 已添加 /public\*/）  
5. temp_workspace 可以用作临时工作空间, 避免使用系统%temp%目录，（.gitignore 已添加 /temp_workspace\*/）  
6. 若没修改themes\banyan\data\cache-policy-default.toml 与 themes\banyan\assets\js\下的 sw.enable.js.tmpl sw-manager.enable.update.js，可忽略此条，否则需确认：  
    6.1. sw.js的缓存策略：navigation = cache-first + versioned; assets（hash资源） = cache-first + fingerprinted; sw.js = ignore  
    6.2. 若浏览器更新sw.js，会被监控到,然后通知ui刷新/重载sw.js 并清空navigation旧缓存  
    6.3. 对sw.js的缓存策略确保为"no-cache, max-age=0, must-revalidate"  
    6.4 sw.js 对首次navigate页面会扫描预缓存其引用资源  
7. 生产环境编译应对产出物做压缩/字节体积优化，如js/css/html等，开发环境（hugo server）则不需要  