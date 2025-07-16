#!/usr/bin/fish

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