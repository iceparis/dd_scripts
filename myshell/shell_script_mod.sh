#!/usr/bin/env bash
## CUSTOM_SHELL_FILE for https://gitee.com/lxk0301/jd_docker/tree/master/docker
### 编辑docker-compose.yml文件添加: - CUSTOM_SHELL_FILE=https://raw.githubusercontent.com/iceparis/dd_scripts/sync/jdshell/shell_script_mod.sh
#### 容器完全启动后执行 docker exec -it jd_scripts /bin/sh -c 'crontab -l'

function redrain(){
    # https://github.com/longzhuzhu/nianyu
    rm -rf /longzhuzhu
    git clone https://github.com/longzhuzhu/nianyu.git /longzhuzhu
    # 拷贝脚本
    for jsname in $(find /longzhuzhu/qx -name "*.js"); do cp ${jsname} /scripts/${jsname##*/}; done
    echo "30 16-23/1 * * * node /scripts/long_half_redrain.js >> /scripts/logs/long_half_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "0 0-23/1 * * * node /scripts/long_super_redrain.js >> /scripts/logs/long_super_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "1 20 1-18 6 * node /scripts/long_hby_lottery.js >> /scripts/logs/long_hby_lottery.log 2>&1" >> /scripts/docker/merged_list_file.sh
}
function jddj(){
    # 备份cookie文件
    [[ -f /scripts/jddj/jddj_cookie.js ]] && cp -rf /scripts/jddj/jddj_cookie.js /scripts/backup_jddj_cookie.js
    # clone
    rm -rf /scripts/jddj && git clone https://github.com/passerby-b/JDDJ.git /scripts/jddj
    # 下载自定义cookie文件地址,如私密的gist地址,需修改
    jddj_cookiefile="https://raw.githubusercontent.com/iceparis/dd_scripts/JDDJ/jddj_cookie.js"
    curl -so /scripts/jddj/jddj_cookie.js $jddj_cookiefile
    # 下载cookie文件失败时从备份恢复
    test $? -eq 0 || cp -rf /scripts/jddj/backup_jddj_cookie.js /scripts/backup_jddj_cookie.js
    # 设定任务
    echo "10 0,3,8,11,17 * * * node /scripts/jddj/jddj_fruit.js >> /scripts/logs/jddj_fruit.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "*/5 * * * * node /scripts/jddj/jddj_fruit_collectWater.js >> /scripts/logs/jddj_fruit_collectWater.log 2>&1" >> /scripts/docker/merged_list_file.sh
}
function main(){
    # 首次运行时拷贝docker目录下文件
    [[ ! -d /jd_diy ]] && mkdir /jd_diy && cp -rf /scripts/docker/* /jd_diy
    redrain
    jddj
    # 拷贝docker目录下文件供下次更新时对比
    cp -rf /scripts/docker/* /jd_diy
}

main
