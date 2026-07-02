# Cloud Compilation

由于没有本地 Docker 环境，我们已经配置了 GitHub Actions 进行云端编译。
只需将修改的文件（如 `Dockerfile.git-2.33.0`）提交并 push 到 GitHub，GitHub Actions 会自动触发编译，并在运行结束后提供 `git-2.33.0.tar.gz` 或对应构建产物供下载。
