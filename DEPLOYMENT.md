# 🦊 FOXAI FLUX - Vercel部署指南

## 🚀 快速部署

这个项目已经配置好可以直接在Vercel上部署。

### 📁 项目结构
```
├── index.html              # 主应用文件
├── flux-image-generator.html # 原始文件（备份）
├── test_api_config.html     # API测试工具
├── vercel.json             # Vercel配置文件
└── README.md               # 项目说明
```

### 🔧 配置信息

**API端点**:
- 主要: `/api/flux` (Vercel代理，推荐)
- 备用: `http://49.51.72.37:5678/webhook/flux` (直连)

**访问路径**:
- 主应用: `/`
- API测试: `/test`

### 🛡️ CORS解决方案

项目包含Vercel Serverless Function代理，自动解决：
- ✅ CORS跨域问题
- ✅ HTTPS/HTTP混合内容问题
- ✅ 浏览器安全限制

### 🌐 部署后访问

部署成功后，您可以通过以下方式访问：

1. **主应用**: `https://your-project.vercel.app`
2. **API测试**: `https://your-project.vercel.app/test`

### ⚠️ 注意事项

1. **CORS设置**: 确保API服务器配置了正确的CORS头
2. **HTTPS混合内容**: 如果遇到问题，可能需要将API升级为HTTPS
3. **API稳定性**: 应用依赖外部API服务器的稳定性

### 🔍 故障排除

如果遇到API连接问题：
1. 使用 `/test` 页面检查API连接状态
2. 检查浏览器控制台的错误信息
3. 确认API服务器是否正常运行

---
**由 FOXAI 强力驱动 🦊**
