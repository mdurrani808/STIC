## Part 2: Debug a Container Networking Issue

### Background

A FastAPI application needs to connect to a Redis cache. Both services are running in containers orchestrated by Docker Compose, but the API **cannot connect** to Redis.

The application will start successfully, but when you check if it can reach Redis, you'll see errors.

### Tasks

1. Run the app:

   ```bash
   cd assignment/part2
   docker-compose up -d
   ```

2. Test the API

   ```bash
   # In another terminal:
   curl http://localhost:8000/health
   ```

   You should see: `{"status":"unhealthy","redis":"disconnected",...}`

   This means the API cannot connect to Redis.

3. Read the logs.

   ```bash
   docker logs part2-api-1
   ```

4. Use networking CLI tools to investigate:

   Get into the API container:

   ```bash
   docker exec -it part2-api-1 bash
   ```

   Now run these commands in the container investigate:

   **Step 1:** What's listening on this container's localhost?

   ```bash
   ss -tulnp
   # Look for what's on port 6379. Is Redis running here?
   ```

   **Step 2:** Can we connect to localhost:6379?

   ```bash
   nc -zv localhost 6379
   # Does this succeed or fail?
   ```

   **Step 3:** What about the "redis" hostname?

   ```bash
   ping -c 2 redis
   # Does this hostname exist? What IP does it resolve to?
   ```

   **Step 4:** Compare DNS resolution:

   ```bash
   dig localhost +short
   dig redis +short
   # Are these the same or different IPs?
   ```

   **Step 5:** Can we connect to redis:6379?

   ```bash
   nc -zv redis 6379
   # Does THIS succeed?
   ```

5. Hints:
   - Look at the code in `api/app.py` - what host is being used for Redis?
   - What does `localhost` mean inside a Docker container?
   - Where is Redis actually running?
   - How should containers communicate with each other in Docker Compose?
   - Look at the service name in `docker-compose.yml`

6. Fix the Redis host in `api/app.py`

7. Verify:

   ```bash
   # Exit the container first (type 'exit' or press Ctrl+D)
   docker-compose down
   docker-compose up

   # In another terminal:
   curl http://localhost:8000/health
   # Should now return: {"status":"healthy","redis":"connected"}

   # Test the counter functionality:
   curl http://localhost:8000/count
   # Should return: {"count":1,"message":"Counter incremented"}
   ```

### What to Submit

- A brief write-up that talks about the change you made and why you made it.
