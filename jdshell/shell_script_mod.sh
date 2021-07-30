#!/usr/bin/env bash
## CUSTOM_SHELL_FILE for https://gitee.com/lxk0301/jd_docker/tree/master/docker
### 编辑docker-compose.yml文件添加: - CUSTOM_SHELL_FILE=https://raw.githubusercontent.com/iceparis/dd_scripts/sync/jdshell/shell_script_mod.sh
#### 容器完全启动后执行 docker exec -it jd_scripts /bin/sh -c 'crontab -l'

function redrain(){
    # https://github.com/longzhuzhu/nianyu
    rm -rf /longzhuzhu
    git clone https://ghproxy.com/https://github.com/iceparis/nianyu.git /longzhuzhu
    # 拷贝脚本
    for jsname in $(find /longzhuzhu/qx -name "*.js"); do cp ${jsname} /scripts/${jsname##*/}; done
    echo "30 20-23/1 * * * node /scripts/long_half_redrain.js >> /scripts/logs/long_half_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "0 0-23/1 * * * node /scripts/long_super_redrain.js >> /scripts/logs/long_super_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
}
function smiek(){
    # https://github.com/smiek2221/scripts
    rm -rf /smiek
    git clone https://ghproxy.com/https://github.com/smiek2221/scripts.git /smiek
    # 拷贝脚本
    cp /smiek/JDJRValidator_Pure.js /scripts/JDJRValidator_Pure.js
    cp /smiek/jd_sign_graphics.js /scripts/jd_sign_graphics.js
    cp /smiek/sign_graphics_validate.js /scripts/sign_graphics_validate.js
    echo "10 10 * * * node /scripts/jd_sign_graphics.js >> /scripts/logs/jd_sign_graphics.log 2>&1" >> /scripts/docker/merged_list_file.sh
}
function main(){
    # 首次运行时拷贝docker目录下文件
    [[ ! -d /jd_diy ]] && mkdir /jd_diy && cp -rf /scripts/docker/* /jd_diy
    redrain
    smiek
    # 拷贝docker目录下文件供下次更新时对比
    cp -rf /scripts/docker/* /jd_diy
}
main
