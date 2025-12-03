## Part 3: Write a Dockerfile from Scratch

### Background

You have a simple Python HTTP server application that you need to containerize. Write a Dockerfile that properly packages this application.

### Tasks

1. Examine the application

2. Write a Dockerfile that:
   - Uses an appropriate Python base image
   - Sets a working directory
   - Copies the necessary application files
   - Exposes the correct port (the server runs on port 8080)
   - Defines the command to run the server

3. Build and test your image

   ```bash
   docker build -t simple-server .
   docker run -p 8080:8080 simple-server

   # In another terminal:
   curl http://localhost:8080
   # Should return: {"message":"Simple Python HTTP Server","status":"running"}
   ```

### What to Submit

- Your complete Dockerfile
- A brief explanation of why you chose each instruction
