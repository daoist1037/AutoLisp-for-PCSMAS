# AutoCAD
## 1. 打印
[原址](https://knowledge.autodesk.com/zh-hans/support/autocad/troubleshooting/caas/sfdcarticles/sfdcarticles/CHS/PDF-created-from-AutoCAD-shows-frames-around-text-in-PDF-viewer.html)

`问题：`

在（通过 Adobe、Foxit 等）查看使用 AutoCAD 或 Civil 3D 创建的 PDF 时，文本周围会显示边框
+ 对于 PDF 文件中的 SHX 文字，边框可能显示为注释
+ 边框可能有特定颜色。示例：黄色
+ 可以通过使用 PDF 驱动程序打印或导出为 PDF 来创建 PDF，例如：
    + DWG to PDF 打印驱动程序
    + AutoCAD PDF（常规文档）

`原因：`
+ 启用了将使用 SHX 字体的文字对象存储为注释的选项
+ PDF 已损坏。损坏的原因可能包括：
    + PDF 的固有功能
    + PDF 内部注释或链接
    + PDF 提取过程

`解决方案:`
在 AutoCAD 中禁止将 SHX 文字存储为注释
+ 在命令行中，键入 `PDFSHX`，并将值设置为 0
+ 再次输出或打印 PDF
> 注意：在 AutoCAD 2016 SP1 中，该系统变量名为 EPDFSHX。

使用其他的打印驱动程序创建 PDF
+ 从 AutoCAD：
    + 在命令行中键入 PLOT。
    + 选择 Microsoft to PDF 打印驱动程序。
    + 保存 PDF。
+ 从 PDF 查看器软件：
    + 在 PDF 查看器软件中打开 PDF 文件
    + 使用打印机驱动程序（如“Microsoft Print to PDF”）再次打印 PDF。
    + 选择仅打印文档而不打印注释的选项：
        + 在“注释和表单”下，选择“文档”选项
        + 打开新创建的 PDF，对话框应该会消失。