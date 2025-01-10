# DitherShader

Dither Shader 库，用于实现像素抖动，模拟半透明

shader 需要定义两个参数（库中使用），默认值随意

```
_MaxDitherDistance ("Max Dither Distance", Float) = 10.0
_MinDitherDistance ("Min Dither Distance", Float) = 2.0
```

shader 中需要引用库文件

```
#include "dither.cginc"
```

且需要计算屏幕像素坐标

```
o.pos = UnityObjectToClipPos(v.vertex);
o.screenPos = ComputeScreenPos(o.pos);
```

具体使用见测试 shader

> 测试 shader 为 urp 管线