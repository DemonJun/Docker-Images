#!/usr/bin/fish

# 加载环境变量和配置
source /root/.config/fish/config.fish

cat <<EOF > /root/.version-fox/.tool-versions
java 17.0.14+7-tem
maven 3.9.9
nodejs 20.19.3
EOF

vfox use java@17.0.14+7-tem -g
vfox use maven@3.9.9 -g
vfox use nodejs@20.19.3 -g

# 如果 ENABLE_SSH 为 true，则启动 SSH 服务
if test "$ENABLE_SSH" = "true"
    exec sudo /usr/sbin/sshd -D
else
    # 如果提供了命令参数，则执行该命令
    if test (count $argv) -gt 0
        exec $argv
    else
        # 如果没有提供命令，则启动 fish 作为登录 shell
        exec fish -l
    end
end 