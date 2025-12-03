FROM python:3.11-slim

WORKDIR /app

RUN apt-get update
RUN apt-get install -y iproute2 dnsutils netcat-openbsd iputils-ping

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
