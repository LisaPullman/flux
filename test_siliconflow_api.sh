#!/bin/bash

echo "🔑 SiliconFlow API连接测试"
echo "==============================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否提供了token
if [ $# -eq 0 ]; then
    echo "请输入您的SiliconFlow API Token:"
    echo "格式: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    read -r TOKEN
else
    TOKEN=$1
fi

echo "🔍 Token格式检查..."
if [[ $TOKEN =~ ^sk-[a-zA-Z0-9]{32,}$ ]]; then
    echo -e "${GREEN}✅ Token格式正确${NC}"
else
    echo -e "${RED}❌ Token格式可能有误${NC}"
    echo "正确格式应为: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
fi

echo ""
echo "🧪 测试1: 聊天API (提示词优化使用的API)"
echo "-----------------------------------"

CHAT_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://api.siliconflow.cn/v1/chat/completions" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen2.5-7B-Instruct",
    "messages": [
      {
        "role": "user",
        "content": "Hello, this is a test."
      }
    ],
    "max_tokens": 50
  }')

HTTP_CODE=$(echo "$CHAT_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$CHAT_RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ 聊天API测试成功 (HTTP $HTTP_CODE)${NC}"
    echo "响应预览:"
    echo "$RESPONSE_BODY" | python3 -m json.tool 2>/dev/null | head -10
elif [ "$HTTP_CODE" = "401" ]; then
    echo -e "${RED}❌ 聊天API认证失败 (HTTP $HTTP_CODE)${NC}"
    echo "错误详情:"
    echo "$RESPONSE_BODY" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE_BODY"
else
    echo -e "${YELLOW}⚠️  聊天API测试异常 (HTTP $HTTP_CODE)${NC}"
    echo "响应:"
    echo "$RESPONSE_BODY"
fi

echo ""
echo "🧪 测试2: 图像生成API"
echo "-------------------"

IMAGE_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://api.siliconflow.cn/v1/images/generations" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a simple test image",
    "model": "black-forest-labs/FLUX.1-dev",
    "image_size": "512x512"
  }')

HTTP_CODE=$(echo "$IMAGE_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$IMAGE_RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ 图像生成API测试成功 (HTTP $HTTP_CODE)${NC}"
    echo "响应预览:"
    echo "$RESPONSE_BODY" | python3 -m json.tool 2>/dev/null | head -5
elif [ "$HTTP_CODE" = "401" ]; then
    echo -e "${RED}❌ 图像生成API认证失败 (HTTP $HTTP_CODE)${NC}"
    echo "错误详情:"
    echo "$RESPONSE_BODY" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE_BODY"
else
    echo -e "${YELLOW}⚠️  图像生成API测试异常 (HTTP $HTTP_CODE)${NC}"
    echo "响应:"
    echo "$RESPONSE_BODY"
fi

echo ""
echo "📊 测试总结"
echo "============"

# 分析结果
CHAT_SUCCESS=false
IMAGE_SUCCESS=false

if echo "$CHAT_RESPONSE" | tail -n1 | grep -q "200"; then
    CHAT_SUCCESS=true
fi

if echo "$IMAGE_RESPONSE" | tail -n1 | grep -q "200"; then
    IMAGE_SUCCESS=true
fi

if [ "$CHAT_SUCCESS" = true ] && [ "$IMAGE_SUCCESS" = true ]; then
    echo -e "${GREEN}🎉 所有API测试成功!${NC}"
    echo "✅ 您的Token可以正常使用"
    echo "✅ 可以正常调用聊天和图像生成API"
    echo ""
    echo "📝 下一步操作:"
    echo "1. 在n8n中更新Bearer Auth凭据"
    echo "2. 确保凭据ID为: kDSNYisuS6BtbNhR"
    echo "3. 重新测试工作流"
elif [ "$CHAT_SUCCESS" = false ] && [ "$IMAGE_SUCCESS" = false ]; then
    echo -e "${RED}❌ 所有API测试失败${NC}"
    echo "🔧 建议操作:"
    echo "1. 检查Token是否正确复制"
    echo "2. 登录SiliconFlow控制台验证Token状态"
    echo "3. 确认账户余额充足"
    echo "4. 重新生成新的API密钥"
else
    echo -e "${YELLOW}⚠️  部分API测试失败${NC}"
    echo "聊天API: $([ "$CHAT_SUCCESS" = true ] && echo "✅ 成功" || echo "❌ 失败")"
    echo "图像API: $([ "$IMAGE_SUCCESS" = true ] && echo "✅ 成功" || echo "❌ 失败")"
fi

echo ""
echo "💡 如果仍有问题，请:"
echo "1. 访问 https://cloud.siliconflow.cn/ 检查账户状态"
echo "2. 确认API密钥权限设置"
echo "3. 检查账户余额和使用限制" 