#!/usr/bin/env bash
## CUSTOM_SHELL_FILE for https://gitee.com/lxk0301/jd_docker/tree/master/docker
### 编辑docker-compose.yml文件添加: - CUSTOM_SHELL_FILE=https://raw.githubusercontent.com/iceparis/dd_scripts/sync/jdshell/shell_script_mod.sh
#### 容器完全启动后执行 docker exec -it jd_scripts /bin/sh -c 'crontab -l'

function star261(){
     if [ ! -d "/star261/" ]; then
        echo "未检查到star261仓库脚本，初始化下载相关脚本..."
        git clone -b main https://github.com/star261/jd.git /star261
    else
        echo "更新star261脚本相关文件..."
        git -C /star261 reset --hard
        git -C /star261 pull origin main --rebase
    fi
    cp -f /star261/scripts/jd_jxmc.js /scripts
    cp -f /star261/scripts/jd_productZ4Brand.js /scripts
    cp -f /star261/scripts/jd_ddworld.js /scripts
     echo "35 23 * * * node /scripts/jd_productZ4Brand.js >> /scripts/logs/jd_productZ4Brand.log 2>&1" >> /scripts/docker/merged_list_file.sh
     echo "28 9 * * * node /scripts/jd_ddworld.js >> /scripts/logs/jd_ddworld.log 2>&1" >> /scripts/docker/merged_list_file.sh
}
function main(){
    # 首次运行时拷贝docker目录下文件
    [[ ! -d /jd_diy ]] && mkdir /jd_diy && cp -rf /scripts/docker/* /jd_diy
    star261
    # 拷贝docker目录下文件供下次更新时对比
    cp -rf /scripts/docker/* /jd_diy
}
main
