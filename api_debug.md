# SiliconFlow API 401错误调试指南

## 🚨 错误分析
您遇到的"提示词优化失败：401 - Invalid token"错误表明：
- ✅ n8n工作流语法已经修复成功
- ❌ SiliconFlow API的认证token有问题

## 🔍 可能原因

### 1. API Token 问题
- Token已过期
- Token格式错误  
- Token权限不足
- Token未正确配置

### 2. API配置问题
- Bearer Auth凭据ID不匹配
- 凭据未正确保存
- 环境变量未设置

## 🛠️ 解决步骤

### 步骤1: 检查API Token
1. 登录 [SiliconFlow控制台](https://cloud.siliconflow.cn/)
2. 进入"API密钥"页面
3. 检查现有token状态：
   - 是否已过期
   - 剩余额度是否充足
   - 权限是否包含聊天和图像生成

### 步骤2: 获取新的Token
如果token有问题，重新生成：
1. 在SiliconFlow控制台删除旧token
2. 创建新的API密钥
3. 复制完整的token字符串

### 步骤3: 更新n8n凭据
1. 在n8n中打开"Credentials"页面
2. 找到名为"Bearer Auth account"的凭据
3. 更新Token字段：
   ```
   sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
4. 保存凭据

### 步骤4: 验证凭据配置
确认以下节点使用正确的凭据：
- ✅ 提示词优化节点
- ✅ 图像生成(有seed)节点  
- ✅ 图像生成(无seed)节点

## 🧪 测试方法

### 方法1: 单独测试API
使用curl命令直接测试API：

```bash
# 测试聊天API (提示词优化)
curl -X POST "https://api.siliconflow.cn/v1/chat/completions" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen2.5-7B-Instruct",
    "messages": [
      {
        "role": "user", 
        "content": "Hello"
      }
    ],
    "max_tokens": 100
  }'
```

### 方法2: 测试图像生成API
```bash
# 测试图像生成API
curl -X POST "https://api.siliconflow.cn/v1/images/generations" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a beautiful sunset",
    "model": "black-forest-labs/FLUX.1-dev",
    "image_size": "1024x1024"
  }'
```

## 📝 常见解决方案

### 1. Token格式检查
确保token格式正确：
- ✅ `sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- ❌ 不要包含多余空格或换行
- ❌ 不要包含"Bearer "前缀

### 2. 权限检查
确认token有以下权限：
- ✅ 聊天模型权限 (Qwen/Qwen2.5-7B-Instruct)
- ✅ 图像生成权限 (FLUX.1-dev, Kolors)

### 3. 余额检查
确认账户有足够余额：
- 聊天API: 约0.001-0.01元/次
- 图像生成: 约0.1-0.5元/张

## 🔧 n8n凭据重新配置步骤

1. **打开n8n管理界面**
2. **进入Credentials页面**
3. **找到或创建Bearer Auth凭据**：
   - Name: `Bearer Auth account`
   - Token: `sk-your-actual-token-here`
4. **更新工作流节点**：
   - 确保所有HTTP Request节点都使用这个凭据
   - 凭据ID应为: `kDSNYisuS6BtbNhR`

## ⚡ 快速修复脚本

如果需要快速测试API连接，可以使用以下脚本：

```bash
#!/bin/bash
echo "🔑 SiliconFlow API测试"
echo "请输入您的API Token:"
read -r TOKEN

echo "测试聊天API..."
curl -s -X POST "https://api.siliconflow.cn/v1/chat/completions" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"model": "Qwen/Qwen2.5-7B-Instruct", "messages": [{"role": "user", "content": "Hello"}], "max_tokens": 10}' \
  | python3 -m json.tool

echo -e "\n测试图像生成API..."
curl -s -X POST "https://api.siliconflow.cn/v1/images/generations" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "test", "model": "black-forest-labs/FLUX.1-dev", "image_size": "512x512"}' \
  | python3 -m json.tool
```

## 📞 如果仍有问题

1. **检查SiliconFlow服务状态**
2. **联系SiliconFlow技术支持**
3. **确认API调用限制**
4. **检查网络连接**

---

**总结**: 401错误表明工作流本身已经修复成功，现在只需要解决API认证配置即可！🎯 