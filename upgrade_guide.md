# n8n 工作流升级指南 - v1.102.1

## 概述
本文档说明了将 FLUX 图像生成工作流从旧版本升级到 n8n 1.102.1 版本的主要变更。

## 主要问题及解决方案

### 1. 表达式语法规范化
**问题**: 表达式中的函数参数格式不规范
**解决方案**: 在所有函数参数后添加空格，确保符合最新语法规范

```javascript
// 旧格式
{{ $ifEmpty($('GET请求').item.json.query.width,1024) }}

// 新格式
{{ $ifEmpty($('GET请求').item.json.query.width, 1024) }}
```

### 2. JSON 表达式格式优化
**问题**: JSON 对象中的表达式格式可能导致解析错误
**解决方案**: 确保所有 JSON 表达式使用正确的格式

```json
// 优化前后对比
{
  "width": {{ $ifEmpty($('GET请求').item.json.query.width,1024) }},
  "height": {{ $ifEmpty($('GET请求').item.json.query.height,1024) }}
}

// 优化后
{
  "width": {{ $ifEmpty($('GET请求').item.json.query.width, 1024) }},
  "height": {{ $ifEmpty($('GET请求').item.json.query.height, 1024) }}
}
```

### 3. 节点版本兼容性
**当前使用的节点版本**:
- Webhook: typeVersion 2
- HTTP Request: typeVersion 4.2
- IF 条件: typeVersion 2.2
- Respond to Webhook: typeVersion 1.1

这些版本都与 n8n 1.102.1 兼容。

## 测试建议

### 1. 基本功能测试
```bash
# 测试无 seed 的请求
curl "http://49.51.72.37:5678/workflow/lskCjTsoomNhqBjq?prompt=a beautiful sunset"

# 测试有 seed 的请求
curl "http://49.51.72.37:5678/workflow/lskCjTsoomNhqBjq?prompt=a beautiful sunset&seed=123456"

# 测试自定义尺寸
curl "http://49.51.72.37:5678/workflow/lskCjTsoomNhqBjq?prompt=a cat&width=512&height=512"
```

### 2. 错误处理测试
- 测试无效的提示词
- 测试 API 连接失败情况
- 验证错误响应格式

## 额外优化建议

### 1. 添加输入验证
考虑在 Webhook 节点后添加验证逻辑：
- 检查 prompt 参数是否存在
- 验证 width/height 参数范围
- 限制 seed 值范围

### 2. 超时设置
为 HTTP Request 节点添加超时配置：
```json
{
  "timeout": 30000
}
```

### 3. 重试机制
考虑为图像生成节点添加重试配置：
```json
{
  "retryOnFail": true,
  "maxTries": 3
}
```

## 部署说明

1. **备份现有工作流**: 在升级前确保备份当前工作流配置
2. **测试环境验证**: 先在测试环境中验证升级后的工作流
3. **逐步部署**: 建议先停用旧工作流，部署新版本，然后激活
4. **监控**: 部署后密切监控工作流执行情况和错误日志

## 故障排除

### 常见错误及解决方案

1. **"The string did not match the expected pattern"**
   - 检查所有表达式语法
   - 确保函数参数格式正确

2. **"Authentication failed"**
   - 验证 Bearer Token 凭据配置
   - 检查 API 密钥是否有效

3. **"JSON parse error"**
   - 检查 JSON 表达式格式
   - 验证响应体结构

## 联系支持

如果在升级过程中遇到问题，请：
1. 检查 n8n 执行日志
2. 验证 API 凭据配置
3. 测试单个节点执行情况 