FROM python:3.11-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Добавляем Poetry в PATH
ENV PATH="/root/.local/bin:$PATH"

# Настройка рабочей директории
WORKDIR /workspaces/langchain

# Настройки Poetry для использования в контейнере
RUN poetry config virtualenvs.create true \
    && poetry config virtualenvs.in-project true

# Копируем только файлы зависимостей для кэширования слоев
COPY pyproject.toml poetry.toml ./

# Устанавливаем зависимости
RUN poetry install --no-root --no-interaction

# Сообщаем, что мы хотим запустить bash при запуске контейнера
CMD ["bash"]
