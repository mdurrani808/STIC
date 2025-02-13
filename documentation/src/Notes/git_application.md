# Git in Practice

## Introduction / Setup

Now that you've learned about how Git actually works under the hood, we can start learning about how to use Git. There are a variety of interfaces avaliable to interact with Git, like the command line, various GUIs, tools like GitHub, and more. In this lesson, we'll focus on the command line version. If you don't have Git installed on your machine, install it using the instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). You may also need to complete some some [first time setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) which we will not be covering here.

Note that a lot of this content is referenced from the [Pro Git book](https://git-scm.com/book/en/v2), with the respective liscense found [here](https://creativecommons.org/licenses/by-nc-sa/3.0/).

### Getting Started with Repositories

The first thing you'll need to do when working with Git is to get your Git repository. This is done either by taking a local directory and converting it into a Git repository or by cloning an existing Git repository from somehwere like GitHub.

#### Initializing A Local Repository Using `git init`

To create a new Git repository, navigate to your desired directory and run:

```bash
git init
```

This creates a `.git` subdirectory that stores all version control data, including objects, references, and the commit history.

#### Cloning an Existing Repository

To copy an existing repository from services like GitHub or GitLab, use:

```bash
git clone <url>
```

This command:

- Creates a new directory named after the project
- Downloads the complete repository history, including all commits and branches
- Sets up your working directory with files from the default branch (typically main or master)

Git supports both HTTPS and SSH protocols for cloning, which you can choose based on your authentication requirements. While cloning is typically done once at the start of working with a repository, you can also clone specific branches if needed.

### Recording Changes

- Adding files to staging
- Partial staging techniques
- Creating commits
- Writing effective commit messages

### History Management

- Viewing commit history
- Filtering log output
- Finding specific changes
- Formatting history display

### Undoing Operations

- Fixing commit messages
- Unstaging files
- Unmodifying files
- Recovery strategies

### Remote Work

- Adding remote repositories
- Fetching and pulling
- Pushing changes
- Managing remote connections

### Tagging and References

- Creating tags

## Git Branching

### Branch Fundamentals

- Understanding branches
- Creating new branches
- Switching branches
- Branch visualization

### Basic Branch Operations

- Creating branches
- Merging basics
- Handling conflicts
- Rebasing basics
- Rebase vs merge

### Branch Management

- Listing branches
- Deleting branches
- Branch organization
- Maintenance patterns

### Remote Branch Operations

- Remote branch tracking
- Pushing to remotes
- Remote branch cleanup
- Branch synchronization
