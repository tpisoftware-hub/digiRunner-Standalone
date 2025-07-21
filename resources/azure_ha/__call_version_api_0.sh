#!/bin/bash

# 设置变量
API_URL="http://127.0.0.1:8442/dgrv4/version"  # 替换为您的 API URL
MAX_RETRIES=30
RETRY_INTERVAL=5
containerAppName=$1

# 定义一个函数来检查 API
check_version_api() {
    for i in $(seq 1 $MAX_RETRIES)
    do
        echo "Attempt $i of $MAX_RETRIES"
        
        # 使用 curl 检查 API
        response=$(curl -k -s -o /dev/null -w "%{http_code}" $API_URL)
        
        if [ $response -eq 200 ]; then
            echo "API is up and running!"
            return 0
        else
            echo "API is not ready yet. HTTP status code: $response"
            
            if [ $i -lt $MAX_RETRIES ]; then
                echo "Waiting for $RETRY_INTERVAL seconds before next attempt..."
                sleep $RETRY_INTERVAL
            fi
        fi
    done

    echo "API did not become available after $MAX_RETRIES attempts."
    return 1
}

# 调用 API 检查函数
check_version_api

# 根据 API 检查结果执行后续操作
if [ $? -eq 0 ]; then
    echo "API check successful. Continuing with the rest of the script..."
    # 在这里添加您想要执行的后续命令
    # 例如：
    # your_next_command
    # another_command
    sh __call_update_ip_api.sh "http://localhost:8442/dgrv4/tptoken/oauth/token" "http://localhost:8442/dgrv4/17/DPB9903" "http://localhost:8442/dgrv4/11/DPB0062" "$containerAppName";
else
    echo "API check failed. Exiting."
    exit 1
fi
echo "."
