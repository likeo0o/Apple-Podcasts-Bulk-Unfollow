# 使用与验证记录 / Usage and validation record

## 已有的真实成功使用

**用户明确确认：自己成功运行使用的是经 GPT 修改优化后的快速取消关注脚本，也就是本次上传的 `unfollow_all_podcasts.applescript`。** 这是来自使用者的真实使用反馈，应当如实保留，不能因为发布整理时没有重新运行就写成“这份脚本未经实际使用”。

The user explicitly confirms successful real use of the GPT-optimized fast script supplied for publication. This is user-reported runtime evidence; it is distinct from the maintainer's compile checks.

完整的成功运行环境（macOS 版本、Podcasts 版本、应用语言和视图配置）没有单独记录。源码中 macOS 26 / Darwin 25.5.0 的注释不是对用户成功运行环境的独立测量，也不能据此扩大跨版本兼容承诺。

## 发布文件身份

- 当前唯一入口：`unfollow_all_podcasts.applescript`。
- 与上传文件和桌面成功运行文件逐字节一致：292 行、9,440 字节。
- SHA-256：`d42c4321f64aeb62b6f23ea926ce3bf7b301e7039e171c226fdbb7d1c04963ea`。
- 未改变运行逻辑、500 次上限、弹窗移除行为或源码注释。
- 已移除首次整理时放在入口的额外保护改写稿，以及容易误解的 `original/` 重复目录。历史内容仍可在 Git 提交记录中追溯。

## 发布整理时完成的检查

- 全文代码审查，确认缓存分组、浅层菜单搜索、短间隔重试及已去除的全窗口移除按钮兜底路径。
- 成功运行文件的 AppleScript 编译通过；编译输出已清理。该检查在准备环境 macOS 27.2（26B123）完成。
- 当前发布包仅包含上述快速脚本及其文档、许可证，共 8 个文件。校验文件身份、UTF-8、内部文档链接及说明与源码的一致性。
- 本地 ZIP 包与当前文件同步；远端发布后核对 Git blob 哈希。

## 本次没有做的事情

- **没有重新执行取消关注脚本**，也没有新增任何真实取消关注或删除操作。此前用户成功使用的记录仍然有效。
- 没有自行复现下载弹窗、跨设备同步、恢复或全部节目取消关注结果。
- 没有建立跨 macOS / Podcasts 版本和语言的兼容性矩阵，也没有可复现的速度基准。
- 没有对未知上游第三方版权进行独立法律确认。

The correct status is: **user-tested fast script, preserved unchanged; compiler and static checks performed during publication; no additional runtime test performed by the publisher.**
