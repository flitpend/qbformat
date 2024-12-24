# qbformat: 签报格式化工具
## 背景
在央国企、事业单位和其他单位工作的朋友常会遇到根据 GB/T 9704-2012 格式标准写签报等公文的要求。部分对格式要求极为苛刻的单位会导致员工日常工作中花费大量时间精力重复调整文件格式。
本工具提供了一个基础模版，可将类 markdown 格式的 txt 文件生成为基本满足格式要求的 Word 文档。
## 准备工作
使用前需安装 Pandoc，请移步 Pandoc 项目官方 Github 下载最新 release：
https://github.com/jgm/pandoc/releases/latest

## 使用方法
在文件夹内新建 txt 文件，文件名自取，或者直接修改 example.txt（推荐）。在 txt 文件中写好签报内容，用后文所述格式来标记每一行，无须关心字体、空行、缩进、编号等段落格式。
保存后双击运行文件夹内的`qbformat.bat`（Windows）或在 Terminal 中运行`perl qbformat.pl`（Mac 或 Linux），程序将自动对各级标题编号，并按常见签报格式要求生成 Word 文档（docx 格式），文件名与 txt 文件名相同。
若文件夹中有多个 txt 文件，程序将逐一生成对应的 Word 文档。

## 格式标记
通过类似 markdown 的语法进行格式标记：
```
没有井号：正文「仿宋_GB2312，三号，两端对齐」
# 一个井号：一级标题「黑体，三号，编号格式：一、二、三、」
## 两个井号：二级标题「楷体_GB2312，三号，编号格式：（一）（二）（三）」
### 三个井号：三级标题「仿宋_GB2312，三号，编号格式：1. 2. 3. 」
#### 四个井号：四级标题「仿宋_GB2312，三号，编号格式：（1）（2）（3）」
##### 五个井号：签报标题「方正小标宋，二号，居中」
###### 六个井号：附件「仿宋_GB2312，三号，特殊缩进，多个附件需手动编号」
####### 七个井号：落款「仿宋_GB2312，三号，右对齐，用于写部门和日期」
**头尾两个星号：加粗正文**
<br> 表示 line break，添加一个空行
&nbsp; 表示 non-breaking space，添加一个空格（包括前后英文的 & 和 ;）
```

注：
1. txt 文本中全部空行将被忽略。因此不论在 txt 中空多少行，最终在 Word 文档中效果都只是另起一段。需要强制空行请使用`<br>`；
2. 一级和二级标题目前支持自动编号到 99，三级和四级标题支持编号到 2,147,483,647，应该够用了；
3. 目前暂不支持表格和图片，只能在生成好的 word 文档中手动添加；
4. 请不要删除、修改或重命名文件夹中的 t.docx，该文件是 Pandoc 用来生成签报的格式模板。
