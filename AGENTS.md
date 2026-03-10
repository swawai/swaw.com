此为基于hugo编译的MPA静态web项目,hugo二进制在：.xvenv\hugo.exe
hugo默认生成 public/，测试可编译到 public-*，如 public-test-v202601020000, （.gitignore 已添加 /public\*/）
内部模块谨慎使用包装，推崇扁平化，如 a:call:x; b:call:x, 然后X内部包装：if a then…… else if b then……，压平则：xa;xb，变为：a:call:xa; b:call:xb，少一层if/else; 或如 a(b);b(c) 压平则为：a(c), 少一层中间套娃
