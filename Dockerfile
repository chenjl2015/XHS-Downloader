# ---- 阶段 1: 构建器 (Builder) ----
FROM python:3.12-bullseye as builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements_fixed.txt requirements.txt

RUN pip install --no-cache-dir --prefix="/install" -r requirements.txt

# ---- 阶段 2: 最终镜像 (Final Image) ----
FROM python:3.12-slim

WORKDIR /app

LABEL name="XHS-Downloader" authors="JoeanAmier" repository="https://github.com/JoeanAmier/XHS-Downloader"

COPY --from=builder /install /usr/local

COPY locale /app/locale
COPY source /app/source
COPY static/XHS-Downloader.tcss /app/static/XHS-Downloader.tcss
COPY LICENSE /app/LICENSE
COPY main.py /app/main.py

EXPOSE 15556

VOLUME /app/Volume

CMD ["python", "main.py", "api"]
