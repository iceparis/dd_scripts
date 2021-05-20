#!/usr/bin/env bash
## CUSTOM_SHELL_FILE for https://gitee.com/lxk0301/jd_docker/tree/master/docker
### 编辑docker-compose.yml文件添加: - CUSTOM_SHELL_FILE=https://raw.githubusercontent.com/monk-coder/dust/dust/shell_script_mod.sh
#### 容器完全启动后执行 docker exec -it jd_scripts /bin/sh -c 'crontab -l'

function monkcoder(){
    # https://github.com/monk-coder/dust
    rm -rf /monkcoder /scripts/monkcoder_*
    git clone https://github.com/monk-coder/dust.git /monkcoder
    # 拷贝脚本
    for jsname in $(find /monkcoder -name "*.js" | grep -vE "\/backup\/\|\/i-chenzhe\/"); do cp ${jsname} /scripts/monkcoder_${jsname##*/}; done
    # 匹配js脚本中的cron设置定时任务
    for jsname in $(find /monkcoder -name "*.js" | grep -vE "\/backup\/\|\/i-chenzhe\/"); do
        jsnamecron="$(cat $jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
        test -z "$jsnamecron" || echo "$jsnamecron node /scripts/monkcoder_${jsname##*/} >> /scripts/logs/monkcoder_${jsname##*/}.log 2>&1" >> /scripts/docker/merged_list_file.sh
    done
}


function redrain(){
    # https://github.com/monk-coder/dust
    rm -rf /longzhuzhu
    rm jd-half-mh.json
    rm jd-half-rain.json
    rm jd-live-rain.json
    rm longzhuzhu.boxjs.json
    rm jd_half_redrain.js
    rm jd_super_redrain.js
    git clone https://github.com/nianyuguai/longzhuzhu.git /longzhuzhu
    # 拷贝脚本
    for jsname in $(find /longzhuzhu/qx -name "*.js"); do cp ${jsname} /scripts/${jsname##*/}; done
    for jsoname in $(find /longzhuzhu/qx -name "*.json"); do cp ${jsoname} /scripts/${jsoname##*/}; done
    echo "30 16-23/1 * * * node /scripts/jd_half_redrain.js >> /scripts/logs/jd_half_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "0 0-23/1 * * * node /scripts/jd_super_redrain.js >> /scripts/logs/jd_super_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

function main(){
    # 首次运行时拷贝docker目录下文件
    [[ ! -d /jd_diy ]] && mkdir /jd_diy && cp -rf /scripts/docker/* /jd_diy
    monkcoder
    redrain
    # 拷贝docker目录下文件供下次更新时对比
    cp -rf /scripts/docker/* /jd_diy
}

main
