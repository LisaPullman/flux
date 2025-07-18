#!/bin/bash
# n8n FLUX工作流测试命令
# 请替换 YOUR_N8N_URL 为您的实际n8n地址

# 设置n8n URL（多个服务器地址，优先使用新服务器）
NEW_SERVER_URL="http://49.51.72.37:5678"
NEW_WEBHOOK_PATH="/workflow/lskCjTsoomNhqBjq"
OLD_SERVER_URL="http://35.212.175.4:5678"
OLD_WEBHOOK_PATH="/webhook/flux"

# 默认使用新服务器
N8N_URL="$NEW_SERVER_URL"
WEBHOOK_PATH="$NEW_WEBHOOK_PATH"

echo "🧪 n8n FLUX工作流测试命令"
echo "================================="
echo "📍 新服务器地址: ${NEW_SERVER_URL}${NEW_WEBHOOK_PATH}"
echo "📍 旧服务器地址: ${OLD_SERVER_URL}${OLD_WEBHOOK_PATH}"
echo "📍 当前测试地址: ${N8N_URL}${WEBHOOK_PATH}"
echo ""

echo "📝 测试案例1: 基本请求（无seed）"
echo "命令："
echo "curl -X GET \"${N8N_URL}${WEBHOOK_PATH}?prompt=a%20beautiful%20sunset%20over%20mountains\" -H \"Content-Type: application/json\""
echo ""

echo "📝 测试案例2: 完整请求（有seed）"
echo "命令："
echo "curl -X GET \"${N8N_URL}${WEBHOOK_PATH}?prompt=a%20cute%20cat%20sitting%20on%20a%20table&width=512&height=512&seed=123456\" -H \"Content-Type: application/json\""
echo ""

echo "📝 测试案例3: 大尺寸请求"
echo "命令："
echo "curl -X GET \"${N8N_URL}${WEBHOOK_PATH}?prompt=abstract%20art%20with%20vibrant%20colors&width=1024&height=768\" -H \"Content-Type: application/json\""
echo ""

echo "📝 测试案例4: 错误测试（空提示词）"
echo "命令："
echo "curl -X GET \"${N8N_URL}${WEBHOOK_PATH}?prompt=\" -H \"Content-Type: application/json\""
echo ""

echo "🚀 执行测试（如果已配置正确的URL）"
echo "================================="

# 取消注释下面的行来实际执行测试
# read -p "是否执行测试案例1？(y/n): " -n 1 -r
# echo
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#     echo "执行测试案例1..."
#     curl -X GET "${N8N_URL}${WEBHOOK_PATH}?prompt=a%20beautiful%20sunset%20over%20mountains" -H "Content-Type: application/json"
# fi

echo ""
echo "🔍 服务器连通性测试"
echo "================================="

echo "测试新服务器连通性..."
if curl -s --connect-timeout 5 "${NEW_SERVER_URL}${NEW_WEBHOOK_PATH}?prompt=test" > /dev/null 2>&1; then
    echo "✅ 新服务器 (${NEW_SERVER_URL}) 连接正常"
else
    echo "❌ 新服务器 (${NEW_SERVER_URL}) 连接失败"
fi

echo "测试旧服务器连通性..."
if curl -s --connect-timeout 5 "${OLD_SERVER_URL}${OLD_WEBHOOK_PATH}?prompt=test" > /dev/null 2>&1; then
    echo "✅ 旧服务器 (${OLD_SERVER_URL}) 连接正常"
else
    echo "❌ 旧服务器 (${OLD_SERVER_URL}) 连接失败"
fi

echo ""
echo "📋 使用说明："
echo "1. 系统会优先使用新服务器，如果失败会自动切换到旧服务器"
echo "2. 确保n8n实例正在运行且工作流已激活"
echo "3. 确保已正确配置SiliconFlow API凭据"
echo "4. 取消注释测试执行部分来运行实际测试"

echo ""
echo "🔧 期望的响应格式："
echo "{"
echo "  \"success\": true,"
echo "  \"originalPrompt\": \"原始提示词\","
echo "  \"enhancedPrompt\": \"优化后的提示词\","
echo "  \"imageUrl\": \"生成的图像URL\","
echo "  \"parameters\": {"
echo "    \"width\": 1024,"
echo "    \"height\": 1024,"
echo "    \"seed\": null,"
echo "    \"model\": \"black-forest-labs/FLUX.1-dev\""
echo "  }"
echo "}" 