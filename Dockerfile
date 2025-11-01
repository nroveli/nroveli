# ИСХОДНЫЙ ОБРАЗ
FROM 9hitste/app:latest

# 1. Установка всех утилит и зависимостей (включая зависимости браузера)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget tar netcat bash curl sudo bzip2 psmisc bc \
    libcanberra-gtk-module libxss1 sed libxtst6 libnss3 libgtk-3-0 \
    libgbm-dev libatspi2.0-0 libatomic1 && \
    rm -rf /var/lib/apt/lists/*

# 2. Установка порта
ENV PORT 10000
EXPOSE 10000

# 3. КОМАНДА ЗАПУСКА (CMD)
CMD bash -c " \
    # --- ШАГ А: НЕМЕДЛЕННЫЙ ЗАПУСК HEALTH CHECK ---
    while true; do echo -e 'HTTP/1.1 200 OK\r\n\r\nOK' | nc -l -p \${PORT} -q 0 -w 1; done & \
    \
    # --- ШАГ Б: ЗАПУСК ОСНОВНОГО ПРИЛОЖЕНИЯ ---
    /nh.sh \
    --token=701db1d250a23a8f72ba7c3e79fb2c79 \
    --system-session \
    --bulk-add-proxy-type=http \
    --bulk-add-proxy-list='45.3.40.245:3129|45.3.36.226:3129|65.111.8.43:3129|45.3.62.224:3129|65.111.21.30:3129' \
    --allow-crypto=no \
    --session-note=sliplane_nroveli \
    --note=sliplane_nroveli \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --headless & \
    \
    # --- ШАГ В: КОПИРОВАНИЕ КОНФИГОВ ---
    sleep 70; \
    echo 'Начинаю копирование конфигурации...' && \
    mkdir -p /etc/9hitsv3-linux64/config/ && \
    wget -q -O /tmp/main.tar.gz https://github.com/drugop/drugop/archive/main.tar.gz && \
    tar -xzf /tmp/main.tar.gz -C /tmp && \
    cp -r /tmp/drugop-main/config/* /etc/9hitsv3-linux64/config/ && \
    rm -rf /tmp/main.tar.gz /tmp/drugop-main && \
    echo 'Копирование конфигурации завершено.'; \
    \
    # --- ШАГ Г: УДЕРЖАНИЕ КОНТЕЙНЕРА ---
    tail -f /dev/null \
"
