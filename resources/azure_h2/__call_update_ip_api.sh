#!/bin/bash

function call_update_IP_api_with_token() {
    local TOKEN_URL="${1:-https://localhost:18081/dgrv4/tptoken/oauth/token}"
    local API_URL="${2:-https://localhost:18081/dgrv4/17/DPB9903}"
    local API_URL2="${3:-https://localhost:18081/dgrv4/11/DPB0062}"

# curl 'https://localhost:18080/dgrv4/tptoken/oauth/token' \
#   -H 'accept: application/json, text/plain, */*' \
#   -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundaryTP5bJqt5CeQvfTGB' \
#   --data-raw $'------WebKitFormBoundaryTP5bJqt5CeQvfTGB\r\nContent-Disposition: form-data; name="grant_type"\r\n\r\npassword\r\n------WebKitFormBoundaryTP5bJqt5CeQvfTGB\r\nContent-Disposition: form-data; name="username"\r\n\r\nmanager\r\n------WebKitFormBoundaryTP5bJqt5CeQvfTGB\r\nContent-Disposition: form-data; name="password"\r\n\r\nbWFuYWdlcjEyMw==\r\n------WebKitFormBoundaryTP5bJqt5CeQvfTGB--\r\n' \
#   --insecure

    # 獲取 token，使用 -F 選項來發送表單數據
    local token_response=$(curl -s -k -X POST "$TOKEN_URL" \
        -H 'accept: application/json, text/plain, */*' \
        -F 'grant_type=password' \
        -F 'username=manager' \
        -F 'password=bWFuYWdlcjEyMw==')


    # 從 JSON 響應中提取 access_token
    # local access_token=$(echo "$token_response" | jq -r .access_token)
    # 從 JSON 響應中提取 access_token (不使用 jq)
    local access_token=$(echo "$token_response" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')

    if [ -z "$access_token" ]; then
        echo "Failed to retrieve access token" >&2
        return 1
    fi

    echo "Access Token:"
    echo $access_token
    echo "Successfully retrieved access token."

    # 使用 token 調用 API...1...Keeper Server IP
    local api_response1=$(curl -s -k -X POST "$API_URL" \
        -H 'accept: application/json, text/plain, */*' \
        -H "authorization: Bearer $access_token" \
        -H 'content-type: application/json' \
        --data '{"ReqHeader":{"txSN":"","txDate":"","txID":"","cID":"","locale":""},"ReqBody":{"id":"DGRKEEPER_IP","oldVal":"127.0.0.1","newVal":"127.0.0.1","memo":"DGRKEEPER Server Host","encrptionType":"NONE"}}')

    # 輸出 API 響應...1
    echo "API Response...1...KeeperServer IP:"
    echo "$api_response1"
    echo "."

    local api_response2=$(curl -s -k -X POST "$API_URL" \
        -H 'accept: application/json, text/plain, */*' \
        -H "authorization: Bearer $access_token" \
        -H 'content-type: application/json' \
        --data '{"ReqHeader":{"txSN":"","txDate":"","txID":"","cID":"","locale":""},"ReqBody":{"id":"TSMP_EDITION","oldVal":"Cn88-nNO8-xx8u-un88-nVoF-Fr48-80rc-L5rF-xN#8-e1=x-6#xo-=d4#-2\u0021=n-\u0021#2\u0021-=\u0021\u0021\u0021-\u0021\u0021\u0021","newVal":"Ce88-nRPO-exx8-GMue-88ni-Hoed-\u0021B4x-x\u0021Cr-nx\u0021r-Fn\u0021#-xU\u0021=-x\u0021#8-\u0021=8\u0021-#d\u0021=-n\u0021#n-\u0021=\u0021\u0021-\u0021\u0021\u0021\u0021-","memo":"","encrptionType":"NONE"}}')
        
    # 輸出 API 響應...2
    echo "$api_response2"
    echo "."
    
    # 使用 token 調用 API...3....改為 Composer IP
    local api_response2=$(curl -s -k -X POST "$API_URL" \
        -H 'accept: application/json, text/plain, */*' \
        -H "authorization: Bearer $access_token" \
        -H 'content-type: application/json' \
        --data '{"ReqHeader":{"txSN":"","txDate":"","txID":"","cID":"","locale":""},"ReqBody":{"id":"TSMP_COMPOSER_ADDRESS","oldVal":"https://127.0.0.1:8440","newVal":"http://127.0.0.1:8440","memo":"COMPOSER IP","encrptionType":"NONE"}}')

    # 輸出 API 響應...3
    echo "API Response...3...Composer IP:"
    echo "$api_response2"
    echo "."
    
    # 使用 token 調用 API...4....reset.func
    local api_response3=$(curl -s -k -X POST "$API_URL2" \
        -H 'accept: application/json, text/plain, */*' \
        -H "authorization: Bearer $access_token" \
        -H 'content-type: application/json' \
        --data-raw '{"ReqHeader":{"txSN":"","txDate":"","txID":"DPB0062","cID":"","locale":""},"ReqBody":{"refItemNo":"SYNC_DATA1","refSubitemNo":null,"startDateTime":"2024/10/06 17:13","inParams":"cmVzZXQuZnVuYw==","identifData":""}}')

    # 輸出 API 響應...4
    echo "API Response...4...'reset.func':"
    echo "$api_response3"
    echo "."
    
    # 使用 token 調用 API...5....AUTO_INITSQL_FLAG=false
    local api_response2=$(curl -s -k -X POST "$API_URL" \
        -H 'accept: application/json, text/plain, */*' \
        -H "authorization: Bearer $access_token" \
        -H 'content-type: application/json' \
        --data '{"ReqHeader":{"txSN":"","txDate":"","txID":"","cID":"","locale":""},"ReqBody":{"id":"AUTO_INITSQL_FLAG","oldVal":"true","newVal":"false","memo":"AUTO_INITSQL_FLAG=false","encrptionType":"NONE"}}')

    # 輸出 API 響應...5
    echo "API Response...5...AUTO_INITSQL_FLAG=false"
    echo "$api_response2"
    echo "."

    return 0
}


call_update_IP_api_with_token "$@"



