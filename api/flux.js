// Vercel Serverless Function - FOXAI FLUX API代理
// 解决CORS和混合内容问题

export default async function handler(req, res) {
  // 设置CORS头
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Accept');
  
  // 处理预检请求
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }
  
  // 只允许GET请求
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  
  try {
    // 获取查询参数
    const { prompt, width = '1024', height = '1024', seed } = req.query;
    
    if (!prompt) {
      res.status(400).json({ 
        success: false, 
        error: '缺少必需参数: prompt' 
      });
      return;
    }
    
    // 构建API请求URL
    const apiUrl = 'http://49.51.72.37:5678/webhook/flux';
    const params = new URLSearchParams({
      prompt,
      width,
      height,
      ...(seed && { seed })
    });
    
    console.log(`代理请求到: ${apiUrl}?${params.toString()}`);
    
    // 调用实际的API
    const response = await fetch(`${apiUrl}?${params.toString()}`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'FOXAI-FLUX-Vercel-Proxy/1.0'
      },
      timeout: 60000 // 60秒超时
    });
    
    if (!response.ok) {
      throw new Error(`API响应错误: ${response.status} ${response.statusText}`);
    }
    
    const data = await response.json();
    
    // 返回结果
    res.status(200).json({
      success: true,
      ...data,
      proxy: true,
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('API代理错误:', error);
    
    res.status(500).json({
      success: false,
      error: error.message || '服务器内部错误',
      proxy: true,
      timestamp: new Date().toISOString()
    });
  }
}
