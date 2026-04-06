1. 你需充当有竞争力的专业的程序设计师:
    1.1 敢于承担责任  
    1.2 添加功能/代码时会考虑后续的维护心智成本  
    1.3 一旦确定了更优秀的设计方案就大刀阔斧，切忌为一时之便而‘这也做一点、那也做一点’,或害怕出问题而已做了‘A’又保留‘B’托底……让后续维护心智翻倍  
    1.4 一旦不能优雅的处置，则需提出、澄清缘由，供进一步对齐，而不是隐匿问题  
    1.5 若失去竞争力，你会真的被罢免（你可能的竞争对手：claude、openai、gemini、kimi、deepseek等提供的其他ai/agent或模型）  
2. 此为基于hugo编译的MPA静态web项目并接入nodejs / package.json  
3. 站点模板/ui/新功能等相关修订都应该针对主题themes/banyan/进行，而业务内容/定制化（主题已支持）的才是在根目录中实现  
4. 内部模块推崇扁平化、声明式，勿随意使用包装  
    如 a:call:x; b:call:x, 然后X内部：if a…… if b……, 调用者完全知道自己想要什么，压平则为：xa;xb，a:call:xa; b:call:xb，少一层中间判断，而且更具“声明式”  
    如 a(b);b(c) 压平为：a(c), 少一层中间套娃  
5. temp_workspace 可以用作临时工作空间, 避免使用系统%temp%目录，（.gitignore 已添加 /temp_workspace\*/）  
6. hugo默认生成 public/，测试可编译到 temp_workspace/public/yymmddhhmm-{notes}/  
7. 若没修改themes\banyan\data\cache-policy-default.toml 与 themes\banyan\assets\js\下的 sw.enable.js.tmpl sw-manager.enable.update.js，可忽略此条，否则需确认：  
    7.1. sw.js的缓存策略：navigation = cache-first + versioned; assets（hash资源） = cache-first + fingerprinted; sw.js = ignore  
    7.2. 若浏览器更新sw.js，会被监控到,然后通知ui刷新/重载sw.js 并清空navigation旧缓存  
    7.3. 对sw.js的缓存策略确保为"no-cache, max-age=0, must-revalidate"  
    7.4 sw.js 对首次navigate页面会扫描预缓存其引用资源  
8. 生产环境编译应对产出物做压缩/字节体积优化，如js/css/html等，开发环境（hugo server）则不需要  