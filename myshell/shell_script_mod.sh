#!/usr/bin/env bash
## CUSTOM_SHELL_FILE for https://gitee.com/lxk0301/jd_docker/tree/master/docker
### 编辑docker-compose.yml文件添加: - CUSTOM_SHELL_FILE=https://raw.githubusercontent.com/iceparis/dd_scripts/sync/jdshell/shell_script_mod.sh
#### 容器完全启动后执行 docker exec -it jd_scripts /bin/sh -c 'crontab -l'

function smiek(){
    # https://github.com/smiek2221/scripts
    rm -rf /smiek
    git clone https://github.com/smiek2221/scripts.git /smiek
    # 拷贝脚本
    cp /smiek/JDJRValidator_Pure.js /scripts/JDJRValidator_Pure.js
    cp /smiek/jd_sign_graphics.js /scripts/jd_sign_graphics.js
    cp /smiek/sign_graphics_validate.js /scripts/sign_graphics_validate.js
    echo "12 10 * * * node /scripts/jd_sign_graphics.js >> /scripts/logs/jd_sign_graphics.log 2>&1" >> /scripts/docker/merged_list_file.sh
}
function jddj(){
    # clone
    rm -rf /scripts/jddj && git clone https://github.com/passerby-b/JDDJ.git /scripts/jddj
    # 拷贝脚本
    cp /scripts/jddj/jd_dreamFactory2.js /scripts/jd_dreamFactory2.js
    # 设定任务
    echo "5 1 * * * node /scripts/jd_dreamFactory2.js >> /scripts/logs/jd_dreamFactory2.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

function main(){
    # 首次运行时拷贝docker目录下文件
    [[ ! -d /jd_diy ]] && mkdir /jd_diy && cp -rf /scripts/docker/* /jd_diy
    smiek
    jddj
    # 拷贝docker目录下文件供下次更新时对比
    cp -rf /scripts/docker/* /jd_diy
}
main
