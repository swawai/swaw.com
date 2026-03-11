1. 此为基于hugo编译的MPA静态web项目,hugo二进制在：.xvenv\hugo.exe  
2. hugo默认生成 public/，测试可编译到 public-*，如 public-test-v202601020000, （.gitignore 已添加 /public\*/）  
3. 内部模块推崇扁平化,谨慎使用包装，如[a:call:x; b:call:x, 然后X内部：if a then…… else if b then……, 压平则为：xa;xb，a:call:xa; b:call:xb，少一层if/else] 或如[a(b);b(c) 压平为：a(c), 少一层中间套娃]  
4. hugo.toml 本质上是基于themes\banyan\exampleSite\hugo.toml 的定制版，直接修改hugo.toml 有利于快速开发，但稳定后应该同步修订themes\banyan\exampleSite\hugo.toml  
5. 站点实例相关的修订不应该写入到themes/banyan/中, 而框架/主题相关则应该  
6. themes\banyan\assets\js\ 下若源文件自身含 Hugo 模板语法（如 {{ ... }}），文件名应以 .tmpl 结尾；若是纯 JS，即使最终仍会被 Hugo pipeline 发布、拼接或指纹化，也应保持 .js 后缀，减少维护时的心智负担  
7. 若没修改edgeone.json 与 themes\banyan\assets\js\下的 sw.* / sw-manager.* 相关文件，可忽略此条，否则需确认：  
    7.1. sw.js只处理html等无hash资源的缓存，使用SWR策略永远立即返回缓存资源-然后检查新版  
    7.2. 若浏览器更新sw.js，会被sw-manager.js监控到,然后通知ui刷新(这主要是为了用户更快看到新内容，因为SWR策略可能返回非常老的资源)  
    7.3. edgeone.json中对sw.js的缓存策略确保为"no-cache, max-age=0, must-revalidate"

