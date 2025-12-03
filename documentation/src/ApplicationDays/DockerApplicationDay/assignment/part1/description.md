## Part 1: Debug a Broken Docker Build

### Background

You've been given a simple FastAPI application with a Dockerfile that fails to build. Your task is to identify and fix the issue.

### Tasks

1. Build the image

   ```bash
   cd assignment/part1
   docker build -t fastapi-app .
   ```

2. Read the error message

3. Root cause the issue:
   - Examine the Dockerfile
   - Look at the file structure in `app/`
   - Think about Docker's build context and working directory

4. Fix the Dockerfile

5. **Rebuild and verify:**

   ```bash
   docker build -t fastapi-app .
   docker run -d -p 8000:8000 fastapi-app
   curl http://localhost:8000
   ```

### Submit

- The corrected Dockerfile
- A brief explanation (1-2 sentences) of what was wrong and how you fixed it
