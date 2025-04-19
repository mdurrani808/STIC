# Docker

## What Is Docker
Docker is an open platform for developing, shipping, and running applications. It allows you to package your application along with all its dependencies into a container, ensuring it runs consistently across different environments, whether on your local machine, a testing server, or in the cloud.

Think of it like putting your whole app into a portable box that works anywhere.

Unlike virtual machines, Docker containers are lightweight and have minimal overhead, enabling more efficient use of system resources. Docker also helps separate applications from infrastructure, allowing you to manage and deploy software faster and more reliably. By using Docker’s tools for packaging, testing, and deployment, you can significantly reduce the time between writing code and running it in production.

## Docker Architecture

### What Are Containers?

Imagine you're developing a web app that has three main components a React frontend, a Python backend API, and a PostgreSQL database. To get started, you'd normally have to install Node.js, Python, and PostgreSQL on your machine. But here's the catch:

- How do you ensure you’re using the same versions of these tools as your teammates?
- How do you avoid conflicts with other apps on your machine that might use different versions?
- How do you guarantee consistency across development, CI/CD pipelines, staging, and production?

That’s where containers come in.

Think of containers as lightweight, isolated environments that bundle up everything your app needs: the code, runtime, system tools, libraries, and settings,  into a neat little package.

In this example:

- The React frontend runs in its own container, with its own Node environment.
- The Python backend lives in another container, with a specific Python version and dependencies.
- The PostgreSQL database runs in yet another container, completely separate from the others.

We'll get into how these containers may communicate later

Each of these containers is:

- **Self-contained**: Everything the app needs (like dependencies or binaries) is included.
- **Isolated**: Containers don’t interfere with one another or the host system.
- **Independent**: You can start, stop, or delete one without touching the others.
- **Portable**: They work *anywhere*, on your laptop, on your friend’s machine, in a cloud VM, or on a Kubernetes cluster.

With containers, you never have to worry about the “it works on my machine” problem again.

Docker makes creating and managing these containers easy through simple configuration files (like `Dockerfile` and `docker-compose.yml`), and it helps streamline both local development and deployment workflows.


#### Containers vs Virtual Machines

To understand why containers are such a big deal, it helps to compare them to virtual machines (VMs):

- A **virtual machine** is a full-blown computer running inside another computer, it has its own OS, kernel, drivers, and more. That’s a lot of overhead if you just want to run a single app.
- A **container**, on the other hand, is just an isolated process. It shares the host’s kernel and resources, making it much lighter and faster to start. If you run multiple containers, they all still share the same kernel.

So while VMs are great for complete system isolation, containers are more efficient when you just need to isolate applications.


#### Using Containers and VMs Together

In cloud environments, you’ll often see both used together:

- Cloud providers give you VMs as the base machines.
- On those VMs, you run multiple **containers**, each hosting a separate app or service.

This hybrid approach helps you use resources more efficiently. For example, instead of running one app per VM, you can run many containerized apps on a single VM, saving cost and infrastructure.

#### Code Examples
TODO

### What Are Images?

Since containers are isolated processes, you might wonder where do they get their files, dependencies, and configurations from?

That’s the job of **container images**.

A **container image** is a packaged snapshot of everything a container needs to run: code, runtime, system libraries, binaries, environment variables, configuration files, and more. It serves as the blueprint for launching containers.

For example:
- A **PostgreSQL image** includes the database engine, config files, and required libraries.
- A **Python web app image** contains the Python runtime, your application code, and any Python packages your app depends on.

#### Key Principles of Images

1. **Images are immutable**  
   Once an image is created, it does not change. If you need to modify it, you create a new image or build on top of the existing one.

2. **Images are built in layers**  
   Each layer reflects a filesystem change, such as installing a package, adding a config file, or copying your app code. These layers are stacked to form the complete image.

This makes images efficient and reusable. For instance, if you build a Python app, you can start from a base image like `python:3.11` and add only what’s specific to your app on top. This minimizes build time and duplication.



#### Real-World Examples

To make things more concrete, here are a few scenarios where Docker images help simplify and streamline development:

##### 1. **Web Application Stack**

Imagine you're building a full web app with a frontend, backend, and database:

- `node:20-alpine`: This image gives you a minimal Node.js environment to build and serve your React frontend. You don’t need to install Node.js manually, it’s already inside the image.
- `python:3.11-slim`: This is a lightweight Python image, ideal for running a Flask or Django backend. You can extend it by adding your app code and required Python packages.
- `postgres:15`: This image comes preconfigured with PostgreSQL. When you run a container from it, you immediately get a working database server with no setup required.

With Docker Compose, you can define all three in a single file, and use it to bring up your entire app stack

##### 2. **Data Science / Dev Environment**

If you're working with Python for data science, you can use:

- `jupyter/scipy-notebook`: A prebuilt image that includes Jupyter Notebook, NumPy, SciPy, pandas, matplotlib, and more. You avoid the hassle of setting up the Python environment locally and just pull the image and you're ready to go.

This is especially useful when collaborating with others, since everyone can use the same image and get identical environments.


#### Finding Images

Docker Hub is the default and largest public registry for container images. You can search for, download, and use thousands of prebuilt images directly from your terminal or Docker Desktop.

#### Types of Docker Hub Images

- **Docker Official Images**  
  Curated and maintained by Docker. These are the most secure and widely used images. Examples: `nginx`, `mysql`, `ubuntu`.

- **Docker Verified Publishers**  
  Images from trusted software vendors like Redis, Elastic, and GitHub, verified by Docker for authenticity.

- **Docker-Sponsored Open Source**  
  Maintained by open-source projects with Docker’s support. Examples include images from PostGIS, Drupal, or Apache Airflow.

You can use these images as-is or as base layers in your own custom images.


#### Code Examples
TODO

### What is a Registry?

Now that you know what a container image is, you may wonder: where do you store these images? While it's possible to store them locally on your computer, what if you want to share them with others or use them on different machines? This is where **container image registries** come into play.

A **registry** is a centralized place for storing and sharing container images. Think of it like a library where you can upload and download images. These registries can be public, like Docker Hub, or private, for more controlled access. 

#### Public Registries
- **Docker Hub**: This is the default, public registry that anyone can use to store and share images. It hosts millions of container images, including official images like `nginx`, `python`, and `ubuntu`.
- **Google Container Registry (GCR)**: Offered by Google Cloud, this registry allows developers to store Docker images securely in Google Cloud.
- **Amazon Elastic Container Registry (ECR)**: Amazon’s version of a container image registry, tightly integrated with AWS.
- **Azure Container Registry (ACR)**: A registry service provided by Microsoft Azure, for storing and managing Docker images in the cloud.

#### Private Registries
You can also run your own private registry if you prefer to keep your container images within your organization or have stricter security requirements. Examples of private registries include:
- **Harbor**: An open-source container registry that provides high-security features and integration with other CI/CD tools.
- **JFrog Artifactory**: A universal artifact repository manager that includes support for Docker images.
- **GitLab Container Registry**: A feature of GitLab that lets you store Docker images within your GitLab repositories.

#### Registry vs. Repository

When working with registries, you'll come across two main terms: **registry** and **repository**. While they sound similar, they are different:

- **Registry**: This is the central storage system that manages and serves container images. It can store many images across different projects.
- **Repository**: A repository is a collection of related images within a registry. It can be thought of as a folder that groups images based on a project or application.

For example, a registry like Docker Hub can contain multiple repositories, each with different versions of images for the same project.

**Example**: On Docker Hub, the `python` repository might contain multiple images for different versions of Python (e.g., `python:3.9`, `python:3.10`), and you can pull the exact version you need for your project.

With registries, you can ensure that all the images you need are stored safely, accessible to your team, and version-controlled across different environments.

### What is Docker Compose?

Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to configure and manage multiple containers in a single YAML file, making it easier to connect services like databases, message queues, and web apps.

#### Key Concepts of Docker Compose

1. **Declarative Configuration**: You define what you want (services, networks, volumes), and Compose takes care of the rest. Changes to the configuration are automatically reconciled by running `docker-compose up` again.
  
2. **Multi-container Applications**: Compose simplifies the management of complex systems where multiple containers need to interact, such as a web app and its database.

3. **Service Definition**: Each container is defined as a service in the Compose file, specifying the Docker image, environment variables, ports, volumes, and dependencies.

#### Dockerfile vs Compose File

- **Dockerfile**: Defines how a single container image should be built.
- **Compose file**: Defines how multiple containers should run and interact, often referencing Dockerfiles to build images for each service.

#### Example of a Docker Compose File

```yaml
version: '3'
services:
  web:
    build:
      context: .
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=postgres://db:5432/mydatabase
    depends_on:
      - db
  db:
    image: postgres:12
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=mypassword
      - POSTGRES_DB=mydatabase

volumes:
  postgres_data:
```

#### Starting and Managing Services

To start the services:

```bash
docker-compose up
```

To stop them:

```bash
docker-compose down
```

#### Benefits of Docker Compose

- **Simplifies Multi-container Environments**: Easily manage complex applications with multiple services.
- **Automatic Networking**: Containers can communicate without manual networking configuration.
- **Consistency**: Share the Compose file to ensure everyone is running the same setup.

Docker Compose makes it easier to manage and scale multi-container applications, ensuring consistency across development and production environments.

## Building Images

### Image Layers

Each layer in an image represents a set of filesystem changes, which could be additions, deletions, or modifications. Think of each layer as an instruction that builds on the previous one. Here's an example to show how an image might be built step-by-step:

1. **Layer 1**: Adds basic commands and a package manager (e.g., `apt` for Debian-based images).
2. **Layer 2**: Installs a runtime environment, like Python, and dependency managers such as `pip`.
3. **Layer 3**: Copies the application's `requirements.txt` file, which lists the required Python dependencies.
4. **Layer 4**: Installs the specific dependencies from the `requirements.txt` file.
5. **Layer 5**: Copies the actual application source code into the image.

This stacking of layers is highly beneficial because it allows layers to be reused between images. For instance, if you want to create another Python-based application, you can reuse the Python base layer, making the build faster and reducing storage and bandwidth. Here's an example:

- **Base Image**: A minimal OS with basic utilities.
- **Layer 1**: Install Python runtime.
- **Layer 2**: Install specific Python packages for the new app.
- **Layer 3**: Copy application code.

By reusing layers, you avoid duplicating effort, saving on build time and disk space.

#### Benefits of Image Layering

- **Reusability**: Since layers are immutable, you can reuse them in multiple images. For example, after downloading a base Python image, any new Python app only needs to install dependencies and copy in the app's code.
- **Efficiency**: Reusing layers reduces build time and minimizes storage use. If you've already downloaded a base image or a shared layer, Docker won't need to download it again for other containers.
- **Smaller Distributions**: When images are layered, Docker only needs to transfer the new or modified layers when distributing the image, which saves bandwidth.

#### How Layering Works: Union Filesystem

The magic behind image layers is a **union filesystem**. Here's a simple breakdown of how it works:

1. **Layer Extraction**: Each image layer is stored as a separate directory on the host's filesystem.
2. **Container Startup**: When you run a container, Docker creates a **union filesystem**. The layers are stacked on top of each other to create a unified view. This allows the container to see a single filesystem, despite it being made up of multiple layers.
3. **Chroot**: When the container starts, its root directory (`/`) is set to the location of this unified directory using the `chroot` system call. This ensures the container operates as though it has its own filesystem.
4. **Writable Layer**: In addition to the image layers, a new writable directory is created specifically for the running container. This allows the container to make changes (like modifying files) without altering the original image layers. The container can read from the image layers but writes to its own filesystem.

This layered approach is particularly useful because it allows you to run multiple containers from the same underlying image. Each container has its own isolated writable layer, but they share the same image layers, making it more resource-efficient.

#### Example: Layered Python Image

Imagine you have two applications that use Python. Both of them need the same base Python image, but each app has its own specific dependencies.

1. **First Application**:
   - Starts with the same base Python image.
   - Installs libraries such as `flask` and `gunicorn`.
   - Copies the app code into the container.

2. **Second Application**:
   - Uses the same Python base image.
   - Installs libraries like `django` and `psycopg2`.
   - Copies different app code into the container.

Even though both containers are based on the same Python base, their layers are unique. The shared base layers don't need to be downloaded again, and only the differences between the two are stored.

### Dockerfiles

A **Dockerfile** is a text-based document that contains a set of instructions used to create a container image. These instructions define what software and dependencies to install, where to place files, what environment variables to set, and how to configure the container for runtime. Docker then reads the Dockerfile to automatically build an image according to the instructions.

#### Example of a Basic Dockerfile

Here's an example of a Dockerfile that sets up a Python application:

```dockerfile
FROM python:3.12
WORKDIR /usr/local/app

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
COPY src ./src
EXPOSE 5000

# Setup an app user so the container doesn't run as the root user
RUN useradd app
USER app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```

In this example:
- **FROM** sets the base image to `python:3.12`.
- **WORKDIR** sets the working directory for subsequent commands.
- **COPY** copies the `requirements.txt` and `src` directories into the container.
- **RUN** installs dependencies and creates a non-root user.
- **CMD** defines the default command that runs the application when the container starts.

#### Common Dockerfile Instructions

Here are some of the most common instructions used in Dockerfiles:

| Instruction | Description |
|-------------|-------------|
| **FROM**    | Specifies the base image to start with. |
| **WORKDIR** | Sets the working directory in the container. |
| **COPY**    | Copies files from the host machine into the container. |
| **RUN**     | Executes commands in the container while building the image. |
| **ENV**     | Sets environment variables in the container. |
| **EXPOSE**  | Declares the ports the container will listen on at runtime. |
| **USER**    | Specifies the user the container runs as. |
| **CMD**     | Sets the default command to run when the container starts. |

#### Format of a Dockerfile

- Dockerfile instructions are typically **uppercase** to distinguish them from arguments.
- A Dockerfile must begin with the **FROM** instruction, which defines the base image to build from.
- Lines that start with `#` are comments.
- **Arguments** and **instructions** are used in sequence to define how the container image is built.

#### Dockerfile Instructions Explained

1. **FROM**  
   Specifies the base image to start from, e.g., `FROM python:3.12`.

2. **WORKDIR**  
   Sets the working directory where all commands are run. Example: `WORKDIR /usr/local/app`.

3. **COPY**  
   Copies files from the host machine into the image. For instance: `COPY requirements.txt ./` copies the `requirements.txt` file into the current directory of the container.

4. **RUN**  
   Executes commands in the image during the build. For example: `RUN pip install --no-cache-dir -r requirements.txt`.

5. **ENV**  
   Sets environment variables for the container. Example: `ENV APP_ENV=production`.

6. **EXPOSE**  
   Indicates which ports the container will listen on at runtime. Example: `EXPOSE 5000`.

7. **USER**  
   Sets the user and group ID the container will run as. Example: `USER app`.

8. **CMD**  
   Defines the default command that runs when the container starts. Example: `CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]`.

#### Other Dockerfile Instructions

- **ADD**: Adds local or remote files and directories to the container.
- **ARG**: Defines build-time variables.
- **ENTRYPOINT**: Specifies the default executable when the container starts.
- **HEALTHCHECK**: Defines a command to check the health of the container.
- **LABEL**: Adds metadata to the image (e.g., author or version).
- **VOLUME**: Creates a mount point for external storage in the container.

#### Best Practices for Dockerfiles

1. **Minimize the Number of Layers**: Try to combine commands in a single `RUN` instruction when possible. This reduces the number of layers and keeps the image smaller.
2. **Use Specific Image Versions**: Always specify the version of the base image (e.g., `FROM python:3.12`), rather than using the `latest` tag to ensure consistent builds.
3. **Leverage Caching**: Docker caches layers when building images. Structure your Dockerfile so that layers likely to change (like copying the source code) are placed toward the end of the Dockerfile. This allows Docker to cache earlier layers (like dependency installation) and avoid rebuilding them every time.

### Building Docker Images

Building a Docker image involves creating a containerized version of your application from a **Dockerfile**. The Dockerfile contains a series of instructions for Docker to follow in order to assemble the image. You typically build an image using the `docker build` command.

#### Basic Docker Build Command

To build a Docker image, you use the following command:

```bash
docker build .
```

The `.` at the end specifies the **build context**, which is the directory where Docker will look for the `Dockerfile` and any files referenced by it. Docker processes the Dockerfile instructions and builds the image step by step.

#### Example Build Output

When you run the `docker build` command, you will see an output similar to this:

```bash
$ docker build .
[+] Building 3.5s (11/11) FINISHED                                            docker:desktop-linux
 => [internal] load build definition from Dockerfile                            0.0s
 => => transferring dockerfile: 308B                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.12                0.0s
 => [internal] load .dockerignore                                               0.0s
 => => transferring context: 2B                                                 0.0s
 => [1/6] FROM docker.io/library/python:3.12                                    0.0s
 => [internal] load build context                                               0.0s
 => => transferring context: 123B                                               0.0s
 => [2/6] WORKDIR /usr/local/app                                                0.0s
 => [3/6] RUN useradd app                                                       0.1s
 => [4/6] COPY ./requirements.txt ./requirements.txt                            0.0s
 => [5/6] RUN pip install --no-cache-dir --upgrade -r requirements.txt          3.2s
 => [6/6] COPY ./app ./app                                                      0.0s
 => exporting to image                                                          0.1s
 => => exporting layers                                                         0.1s
 => => writing image sha256:9924dfd9350407b3df01d1a0e1033b1e543523ce7d5d5e2c83a724480ebe8f00  0.0s
```

This output shows each layer being created and the final image ID (`sha256:9924dfd...`). You can run containers from this image using the ID, although it’s often more practical to tag the image for easier reference.

### Build Caching and Efficiency

Docker uses a **build cache** to speed up the image building process. Each instruction in the Dockerfile creates a new layer. Docker caches these layers to avoid rebuilding them if they haven’t changed. This saves time and resources.

#### Cache Invalidation

Changes to certain instructions can invalidate Docker's cache, triggering a rebuild of the affected layers. For example:
- **RUN**: Modifications to commands in the `RUN` instruction invalidate the cache.
- **COPY/ADD**: Changes to the files copied into the image can invalidate the cache for subsequent layers.
- If a layer is invalidated, all layers that depend on it are also invalidated, which may cause a longer build time.

To optimize build speed, you should structure your Dockerfile so that less-frequently changed parts are placed earlier (such as installing dependencies), and more dynamic parts (like copying the application code) are placed later.

### Multi-Stage Builds

**Multi-stage builds** allow you to separate the build process from the final runtime environment, significantly reducing the size of your final image and minimizing the attack surface. This is especially useful for applications with large build dependencies that are not needed at runtime.

#### Example of a Multi-Stage Dockerfile

```dockerfile
# Stage 1: Build Environment
FROM node:20-alpine AS build-stage
WORKDIR /app
COPY . .
RUN yarn install --production

# Stage 2: Runtime Environment
FROM node:20-alpine AS final-stage
WORKDIR /app
COPY --from=build-stage /app .
CMD ["node", "./src/index.js"]
```

In this Dockerfile:
- The **build stage** uses a full Node.js environment to install dependencies and prepare the application.
- The **final stage** uses a smaller runtime image, only copying over the necessary application files from the build stage.

This method helps you build more efficient Docker images by excluding unnecessary build dependencies from the final image.
