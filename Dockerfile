# Stage 1: Builder
FROM python:3.12-alpine AS builder
WORKDIR /app
RUN apk add --no-cache build-base libffi-dev
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt
COPY . .

# Stage 2: Runtime
FROM python:3.12-alpine
WORKDIR /app
COPY --from=builder /install /usr/local
COPY --from=builder /app /app
EXPOSE 8080
CMD ["python", "/app/app.py"]
