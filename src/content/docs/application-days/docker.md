---
title: Docker Application Day
description: Docker Application Day for CMSC398W.
---

Three debugging tasks, each involving a broken Docker setup. Read the error, find the cause, fix it.

Repository: [https://github.com/cmsc398w/DockerApplicationDay](https://github.com/cmsc398w/DockerApplicationDay)

Submit on Gradescope.

---

## Part 1: Debug a Broken Docker Build

A FastAPI app has a Dockerfile that fails to build. Find the problem and fix it.

```bash
cd assignment/part1
docker build -t fastapi-app .
```

Read the error. Look at the Dockerfile and the `app/` directory. Think about build context and working directory.

After fixing it:

```bash
docker build -t fastapi-app .
docker run -d -p 8000:8000 fastapi-app
curl http://localhost:8000
```

**Submit:** The corrected Dockerfile and 1-2 sentences on what was wrong and how you fixed it.

---

## Part 2: Debug a Container Networking Issue

A FastAPI app and a Redis cache are running via Docker Compose, but the API cannot reach Redis.

```bash
cd assignment/part2
docker-compose up -d
curl http://localhost:8000/health
# {"status":"unhealthy","redis":"disconnected",...}
```

Get into the container and investigate:

```bash
docker exec -it part2-api-1 bash

ss -tulnp          # what's listening on this container's localhost?
nc -zv localhost 6379   # can we reach port 6379 here?
ping -c 2 redis         # does the "redis" hostname resolve?
dig localhost +short
dig redis +short         # are these the same IP?
nc -zv redis 6379        # can we reach redis:6379?
```

Look at `api/app.py`. What host is the code using to connect to Redis? Fix it.

```bash
docker-compose down && docker-compose up
curl http://localhost:8000/health
# {"status":"healthy","redis":"connected"}
```

**Submit:** A brief write-up on the change you made and why.

---

## Part 3: Write a Dockerfile from Scratch

You have a Python HTTP server. Write a Dockerfile that packages it.

The Dockerfile must:

- Use an appropriate Python base image
- Set a working directory
- Copy the application files
- Expose port 8080
- Define the command to run the server

```bash
docker build -t simple-server .
docker run -p 8080:8080 simple-server

curl http://localhost:8080
# {"message":"Simple Python HTTP Server","status":"running"}
```

**Submit:** Your Dockerfile and a brief explanation of why you chose each instruction.
