# ベースイメージとして CUDA Runtime を選択
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# 必要なツールとAPTのパラレルダウンロードを設定
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gpg && \
    echo 'Acquire::Queue-Mode "host";' > /etc/apt/apt.conf.d/99parallel && \
    ## uv
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    ## nvidia-container-toolkit
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    nvidia-container-toolkit && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 環境変数の設定
ENV PATH="/root/.local/bin:$PATH"

# 作業ディレクトリの設定
WORKDIR /usr/local/app

# 必要なファイルをコンテナにコピー
COPY . .
