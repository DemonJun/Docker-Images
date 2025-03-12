#!/usr/bin/fish

# 加载环境变量和配置
source /root/.config/fish/config.fish

sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen 
locale-gen

vfox use java@17.0.14+7-tem -g
vfox use maven@3.9.9 -g 
vfox use nodejs@23.9.0 -g

# 如果 ENABLE_SSH 为 true，则启动 SSH 服务
if test "$ENABLE_SSH" = "true"
    exec sudo /usr/bin/sshd -D
else
    # 如果提供了命令参数，则执行该命令
    if test (count $argv) -gt 0
        exec $argv
    else
        # 如果没有提供命令，则启动 fish 作为登录 shell
        exec fish -l
    end
end 