FROM debian:11

# Шаг 1: Установка минимальных инструментов + netcat (для Health Check)
RUN apt-get update && apt-get install -y curl xvfb python3

# Указываем Koyeb, какой порт слушать
EXPOSE 8000
