## 1. Introduction to Git

### What is Git?

Version control systems track and maintain the history of changes in files and folders over time. These systems enable developers to view and restore previous versions of a project, document the reasoning behind changes, and work on parallel branches of development. They are essential for collaboration, allowing teams to see changes made by others and resolve conflicts that arise during concurrent development.

Git, created by Linux Torvalds for managing the Linux kernel source code, distinguishes itself among version control systems like Subversion, Bitbucket, and Mercurial through its distributed architecture. In Git's approach, every developer maintains a complete copy of the repository locally. This complete copy serves dual purposes: it acts as a full backup of the project and enables developers to work offline effectively. The distributed nature eliminates single points of failure and provides teams with more flexible workflow options.

### Git vs GitHub

Git and GitHub serve different but complementary roles in modern software development. Git is the version control system itself—a locally installed software tool that tracks and manages code changes. Developers can use Git completely offline on their local machines, handling tasks like branching, merging, and maintaining project history without any connection to external services.

GitHub, in contrast, is a web-based hosting platform that extends Git's capabilities into the cloud. It provides a centralized location for storing Git repositories and adds powerful collaborative features. These include pull requests for code review, issue tracking for project management, and wikis for documentation. GitHub also offers team management tools and supports continuous integration workflows.

While GitHub has become synonymous with Git hosting, it's important to note that other services like GitLab and Bitbucket offer similar functionality. Developers can use Git without ever touching GitHub or any other hosting service, but the reverse isn't true—GitHub's functionality fundamentally depends on Git.
## 2. Core Concepts
It is possible to learn how to use Git in a top-down fashion (starting with its interface), but this can lead to a lot of confusion. This ends with you just memorizing a bunch of commands and magic incantations, which makes it hard to fix things when things go wrong. Thus, we believe its important to understand Git's fundamental architecture and terminology, which will help you better understand how the commands will manipulate the underlying data model. This section explores the essential concepts that form the foundation of Git's functionality.

### 2.1 Git Architecture
Git's architecture is built around a system that tracks, stores, and manages your project's content and history through three main components, the working directory, staging area / index, repository (local and remote), and stash. The repository contains the complete history and tracking information for your project, stored within a `.git` directory. The working directory represents the actual files on your filesystem where you are actively making changes like editing your code and adding files. When you check out a certain version of your project, Git will populate the working directory with those files, allowing you to see and modify them directly. Between the working directory and your repository, there is the staging area of index. This intermediate area serves as the preparation space for your next commit.

Additionally, Git maintains both local and remote repositories. Your local repository stores all committed changes on your machine, while remote repositories, hosted on services like GitHub or GitLab, enable collaboration with other developers. The local repository contains all the objects and references needed to maintain your project's complete history, while remote repositories serve as central points for sharing and synchronizing changes between team members.

Finally, git maintains a stash, which acts as a place to hide modifications while you work on something else. 

### 2.2 Key Terminology

Git's terminology precisely describes different components and operations within its version control system. Understanding these key terms provides the foundation for working effectively with Git.

A commit represents a snapshot of your project at a specific point in time, capturing the complete state of all tracked files. It also contains its parents, the author of the commit and a message. Each commit is identified by a unique hash ID (like "c69e0cc32f3c1c8f2730cade36a8f75dc8e3d480"), which is derived from its metadata properties.

Branches enable parallel development streams within the same repository. A branch is simply a pointer to a specific commit that automatically moves forward as new commits are added. When you create a new branch, Git creates a new pointer to your current commit. As you make changes and create new commits on this branch, only this pointer moves forward, leaving your other branches unaffected. This mechanism allows multiple development efforts to proceed simultaneously without interfering with each other. The default branch in Git is typically named 'master' (though 'main' is becoming more common), representing your project's primary development line.

The HEAD is a special pointer that indicates your current position in the repository. It usually points to the latest commit of the branch you're working on, telling Git where to apply new changes when you make a commit. When you check out a different branch or specific commit, HEAD moves to point to that new location. A "detached HEAD" state occurs when HEAD points directly to a commit rather than a branch, though this is less common in typical workflows.

Tags provide a way to mark specific points in your repository's history as significant, typically used for marking release versions. Unlike branches, tags are fixed references that point to specific commits and don't move when new commits are added. They serve as permanent bookmarks to important states of your project, such as release versions (v1.0, v2.0) or major milestones.
### 2.3 File States
Every file in your working directory exists in one of two tracking states: tracked or untracked. Tracked files are those that were present in your last snapshot (commit) or have been explicitly staged. These files are actively managed by Git, meaning Git recognizes and monitors changes to them. Untracked files, conversely, are all other files in your working directory that weren't in your last snapshot and haven't been staged.

Tracked files themselves can exist in three distinct states: modified, staged, or committed. When you first edit a tracked file, Git recognizes it as modified, indicating that changes have been made since the last commit. These modifications exist only in your working directory until you explicitly stage them. Staging a file means you've marked its current state for inclusion in your next commit—you're preparing a new snapshot of your project. Finally, a committed file has had its changes permanently stored in your Git repository. This progression of states forms a fundamental workflow in Git: you modify files in your working directory, selectively stage the changes you want to include in your next commit, and finally commit those changes to permanently record that version of your project.

## 3. Essential Git Operations
This section covers the essential commands and workflows you'll use daily, from setting up repositories to tracking changes and managing your work. While Git offers numerous advanced features, mastering these basic operations provides the foundation for all version control tasks.
### 3.1 Repository Setup
To create a new repository, navigate to your project's directory and execute `git init`. This command creates a hidden `.git` directory that contains all the necessary metadata and object database for version control.

When you initialize a repository, Git begins tracking the directory's contents, though it won't actually record any changes until you explicitly commit them. The initialization process also creates the default branch, typically named 'master' or 'main', which serves as your primary line of development.

Alternatively, you can clone an existing repository using `git clone <repository-url>`. This command creates a complete copy of the repository, including its entire history. When you clone a repository, Git automatically sets up a remote connection to the original repository, naming it 'origin' by default. This connection allows you to synchronize your local copy with the remote repository later.

### 3.2 Basic Workflow 
The basic workflow you follow in Git is that you make changes to your files and then record / commit those changes to the repository. The process begins in your working directory, where you make changes to files, those changes get staged in the staging area, and then you commit them.

To start tracking new files or stage modified files, use `git add`. This command moves files to the staging area, preparing them for commitment. You can stage individual files (`git add filename`), multiple files (`git add file1 file2`), or all changes in the current directory (`git add .`). The staging area allows you to selectively choose which changes to include in your next commit, enabling you to create logical, atomic commits even when you have multiple unrelated changes in your working directory. 

Once you've staged your changes, create a new commit using `git commit`. Each commit should represent a logical unit of work and include a descriptive message explaining what changes were made and why. Write commit messages in the present tense, being specific about what the commit does rather than what you did. For example:

```bash
git commit -m "Add user authentication feature"
```

To view the status of your working directory at any time, use `git status`. This command shows which files are modified, staged, or untracked. For a more detailed view of changes, use `git diff` to see unstaged changes or `git diff --staged` to view staged changes that will be included in your next commit.

After committing your changes locally, you'll often need to share them with others by pushing to a remote repository. The `git push` command synchronizes your local commits with a remote repository, making your changes accessible to other team members. By default, pushing updates the corresponding remote branch with your local commits. For instance, when working on the main branch, `git push origin main` sends all new commits to the 'main' branch on the remote repository named 'origin'. Before pushing, it's good practice to first update your local repository with any remote changes using `git pull` to avoid potential conflicts. Git will only allow pushes that can be cleanly integrated into the remote repository—if there are conflicting changes, you'll need to resolve them locally first by pulling and merging the remote changes before attempting to push again.

### 3.3 Branching and Integration 
The concept of branching lies at the heart of Git's power. A branch represents an independent line of development, allowing multiple development efforts to proceed simultaneously without interference. Understanding how branches work and how to integrate changes between them is crucial for effective version control.
#### Creating and Managing Branches
A branch in Git is simply a lightweight movable pointer to a specific commit. When you create a new branch using `git branch feature-name`, Git creates a new pointer to your current commit. However, creating a branch doesn't automatically switch your working directory to that branch. To begin working on the new branch, use `git checkout feature-name`, or combine both operations with `git checkout -b feature-name`.
As you make commits on a branch, only that branch's pointer moves forward. This independence allows you to switch between different features or bug fixes, maintaining separate lines of development that don't affect each other.

For example:
```bash
git branch authentication   # Creates new branch
git checkout authentication # Switches to the branch
# Or more concisely:
git checkout -b authentication
```

As you make commits on a branch, only that branch's pointer moves forward. This independence allows you to switch between different features or bug fixes, maintaining separate lines of development that don't affect each other.

#### Merging Strategies
When it's time to incorporate changes from one branch into another, Git provides several merging strategies. The two primary approaches are fast-forward merges and three-way merges.

**Fast-Forward Merges**
A fast-forward merge occurs when there is a direct linear path between the source and target branches. Consider this scenario: you create a feature branch, make several commits, and no new commits appear on the main branch. In this case, Git simply moves the main branch pointer forward to match the feature branch:

```bash
git checkout main
git merge feature-branch  # Results in fast-forward if possible
```

This creates a clean, linear history but is only possible when no parallel development has occurred on the target branch.

**Three-Way Merges**
When the target branch has progressed independently, Git performs a three-way merge. This process creates a new "merge commit" that has two parent commits—one from each branch. Git automatically merges the changes when they don't conflict, preserving both development histories:

```bash
git checkout main
git merge feature-branch
# If successful, creates a merge commit
# If conflicts occur, requires manual resolution
```

#### Rebasing

Rebasing offers an alternative approach to integrating changes between branches. While merging preserves complete history and creates a new merge commit, rebasing rewrites history by replaying commits from one branch onto another. This results in a linear project history, as if all work had been done sequentially rather than in parallel.

```bash
git checkout feature-branch
git rebase main
```

This command takes all commits from your feature branch and replays them on top of the main branch. The process works by:
1. Finding the common ancestor of both branches
2. Saving the changes from each commit in your feature branch as temporary patches
3. Resetting your feature branch to the same commit as main
4. Replaying your changes one by one

**When to Use Rebasing vs. Merging**
Choose rebasing when:
- You want to maintain a clean, linear project history
- Your feature branch is private and not shared with others
- You need to integrate the latest changes from the main branch into your feature branch

Choose merging when:
- You want to preserve the complete history of your project
- The branch is public and shared with other developers
- You want to maintain the context of parallel development

**Interactive Rebasing**
Interactive rebasing provides fine-grained control over your commit history. Using `git rebase -i`, you can modify commits as they're replayed:

```bash
git rebase -i main
```

This opens an editor where you can:
- Reorder commits
- Edit commit messages
- Combine multiple commits into one
- Split commits into smaller ones
- Remove commits entirely

Interactive rebasing is particularly useful for cleaning up your commit history before merging a feature branch into the main branch. However, use this with caution on shared branches, as rewriting history can cause problems for other developers working with the same code.

### 3.4 Collaboration
Effective collaboration in Git extends beyond basic version control operations to encompass workflows that enable multiple developers to work together seamlessly. Understanding these collaborative features and practices is essential for successful team development.
#### Working with Remotes
Remote repositories serve as the central point of collaboration in Git projects. While Git is distributed by nature, meaning every developer has a complete copy of the repository, remotes provide a shared reference point for synchronizing changes between team members. The `git remote` command manages connections to other repositories. When you clone a repository, Git automatically sets up a remote named 'origin' pointing to the source repository. You can view your configured remotes and their URLs using the following command:

```bash
git remote -v
```

Adding additional remotes is often useful, particularly when working with forks, where you might want to keep your copy synchronized with an upstream repository while maintaining your own separate development branch. You can add new remotes using:

```bash
git remote add upstream https://github.com/original/repository.git
```

#### Pull Requests
Pull requests represent a formal way to propose changes from one branch to another, typically used when contributing to shared repositories. While Git itself doesn't have a built-in pull request feature, hosting platforms like GitHub, GitLab, and Bitbucket provide this functionality as part of their collaborative toolset. The typical pull request workflow begins with creating a feature branch from the main development branch. After making and committing changes locally, you push the feature branch to your remote repository and open a pull request through your hosting platform. This initiates a period of code review and discussion, during which you can address feedback and update the pull request as needed. Once approved, the changes can be merged into the target branch.

#### Handling Conflicts
Merge conflicts occur when Git cannot automatically reconcile different changes to the same part of a file. While conflicts are a natural part of collaborative development, regular synchronization with the main branch can help minimize their frequency. You should frequently update your branch with changes using:

```bash
git fetch origin
git rebase origin/main
```

When conflicts do occur, Git marks the conflicting sections in your files with special markers (<<<<<<<, \=\=\=\=\=\=\=, >>>>>>>). Resolution involves opening the conflicting files, deciding which changes to keep or how to combine them, removing the conflict markers, and staging the resolved files. After resolving conflicts, you stage the files and continue the rebase:

```bash
git add <resolved-file>
git rebase --continue
```

## 4. Troubleshooting and Recovery 
While Git provides robust version control capabilities, situations inevitably arise where you need to undo changes or recover from mistakes. Understanding Git's recovery tools and processes is essential for maintaining a healthy repository and resolving common issues that occur during development. This section covers various techniques for undoing changes, recovering lost work, and addressing common Git problems.
### 4.1 Undoing Changes

Git provides several mechanisms for undoing changes, each suited to different scenarios depending on whether the changes have been committed and whether you want to preserve the changes for later use. Understanding these options helps you choose the most appropriate approach for your situation.

When working with uncommitted changes in your working directory, Git offers straightforward ways to undo modifications. For files that have been modified but not yet staged, you can use `git checkout` to discard the changes and restore the file to its state in the last commit:

```bash
git checkout -- filename.txt
```

For changes that have been staged but not yet committed, the `git restore` command provides a interface for unstaging changes while preserving the modifications in your working directory:

```bash
git restore --staged filename.txt
```

When you need to undo committed changes, Git provides several reset options with different levels of impact. A soft reset moves the branch pointer to an earlier commit while preserving your staged changes:

```bash
git reset --soft HEAD~1
```

This approach is particularly useful when you want to combine several commits into one or when you've committed changes to the wrong branch. The soft reset keeps your changes staged, allowing you to immediately create a new commit with the same changes.

A mixed reset, which is the default behavior, moves the branch pointer and unstages changes:

```bash
git reset HEAD~1
```

This option gives you the flexibility to review and restage changes before recommitting them, essentially allowing you to reorganize your commits while preserving the actual changes in your working directory.

The most dramatic option is a hard reset, which moves the branch pointer and discards all changes, returning your working directory to the state of the specified commit:

```bash
git reset --hard HEAD~1
```

Hard resets should be used with caution as they permanently discard changes. However, they can be valuable when you need to completely abandon recent commits and start fresh from a known good state.

For situations where you want to undo a commit while preserving the commit history, Git provides the revert command:

```bash
git revert commit-hash
```

Unlike reset, which removes commits from the history, revert creates a new commit that undoes the changes from a specific commit. This approach is particularly important when working with shared branches, as it maintains a clear history of changes and avoids disrupting other developers' work.

When using these commands, it's important to understand their scope and impact. The checkout command works on individual files or your entire working directory, reset affects your branch position and optionally your working directory, and revert creates new commits to undo previous changes. Each has its appropriate use case, and choosing the right tool depends on factors such as whether the changes have been shared with others, whether you want to preserve the ability to recover the changes later, and how many commits you need to affect.

### 4.2 Common Issues and Solutions

Dangit, my branch got all tangled up with conflicts and nothing makes sense anymore!
```bash
# First, save any uncommitted changes you care about
git stash

# Get back to a known good state
git fetch origin
git checkout main
git reset --hard origin/main

# Create a fresh branch from here
git checkout -b fresh-start-branch

# Get your stashed changes back if needed
git stash pop
```
This gives you a clean slate while preserving your work. Sometimes it's better to start fresh than to untangle a messy branch.

Dangit, I committed sensitive information like passwords or API keys!
```bash
# Remove the sensitive file from git tracking but keep it locally
git rm --cached sensitive_file.txt

# Rewrite git history to remove all traces of the file
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch sensitive_file.txt" \
  --prune-empty --tag-name-filter cat -- --all

# Force push the changes (be careful!)
git push origin --force --all
```
After this, immediately change any exposed passwords or API keys, as they should be considered compromised.

Dangit, I've been working on the wrong remote repository this whole time!
```bash
# Check current remote
git remote -v

# Add the correct remote
git remote add correct-origin https://correct-repo-url.git

# Fetch all branches from new remote
git fetch correct-origin

# Reset main to match the correct remote
git reset --hard correct-origin/main

# Update remote URL if needed
git remote set-url origin https://correct-repo-url.git
```
This helps when you've accidentally cloned the wrong fork or repository.

Dangit, I need to move my last few commits to a different branch!
```bash
# Create a new branch with all current commits
git branch new-branch

# Move back 3 commits on current branch
git reset --hard HEAD~3

# Switch to the new branch with the commits
git checkout new-branch
```
This is perfect for when you realize you've been committing to main instead of a feature branch.

Dangit, my Git workspace is a mess with untracked files everywhere!
```bash
# See what would be deleted first (dry run)
git clean -n

# Delete all untracked files
git clean -f

# Delete all untracked files and directories
git clean -fd

# Also remove ignored files
git clean -fdx
```
Be careful with clean commands - they permanently delete files!

Dangit, I accidentally deleted a file but haven't committed the deletion!
```bash
# Restore the file from the last commit
git checkout -- deleted_file.txt

# If you're using newer Git versions
git restore deleted_file.txt
```
This works great for recovering files that were accidentally deleted.

Dangit, I need to undo a merge that was just committed!
```bash
# Find the commit before the merge
git reflog

# Reset to that commit
git reset --hard HEAD@{1}

# Or revert the merge if it's been pushed
git revert -m 1 <merge-commit-hash>
```
The revert approach is safer if others might have pulled your changes.

Dangit, I need to temporarily store my changes but don't want to commit them!
```bash
# Store all tracked changes
git stash

# Store all changes, including untracked files
git stash -u

# Store with a descriptive message
git stash save "work in progress for feature X"

# List all stashes
git stash list

# Apply most recent stash
git stash pop

# Apply specific stash
git stash apply stash@{2}
```
Stashing is perfect for when you need to quickly switch contexts.

Dangit, I need to find which commit introduced a bug!
```bash
# Start the binary search
git bisect start

# Mark current state as bad
git bisect bad

# Mark a known good commit
git bisect good <commit-hash>

# Git will checkout commits to test
# Mark each commit as good or bad until found
git bisect good  # or
git bisect bad

# When done, return to original state
git bisect reset
```
This binary search approach helps find problematic commits quickly.

Dangit, I need to remove a file from Git history completely!
```bash
# Remove file from all commits
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/file' \
  --prune-empty --tag-name-filter cat -- --all

# Force push all branches
git push origin --force --all
```
Useful for removing large files or sensitive data that was accidentally committed.

Dangit, I committed to develop but this should have been a hotfix!
```bash
# Create a new hotfix branch from production
git checkout production
git checkout -b hotfix/issue-123

# Cherry pick your commit from develop
git cherry-pick <commit-hash>

# Delete the commit from develop
git checkout develop
git reset --hard HEAD~1
```
This keeps your hotfix separate from regular development work.

Dangit, my feature branch is dozens of commits behind main!
```bash
# Update your local main
git fetch origin
git checkout main
git pull

# Rebase your feature branch
git checkout feature-branch
git rebase main

# If you hit conflicts:
# 1. Resolve conflicts
# 2. git add resolved-files
# 3. git rebase --continue
# 4. Or git rebase --abort to start over
```
Rebasing keeps your feature branch up to date and maintains a clean history.

Dangit, I need to change the author of previous commits!
```bash
# Change the last commit's author
git commit --amend --author="New Author <email@address.com>"

# Change multiple commits' authors
git rebase -i HEAD~3  # Last 3 commits
# Change 'pick' to 'edit' for commits to modify
# For each commit:
git commit --amend --author="New Author <email@address.com>" --no-edit
git rebase --continue
```
Useful when commits have the wrong author information.

Dangit, I pushed a massive file and now the repository is huge!
```bash
# Remove the file from git history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/huge/file' \
  --prune-empty --tag-name-filter cat -- --all

# Clean up the repository
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push all branches
git push origin --force --all
git push origin --force --tags
```
This helps reduce repository size by completely removing large files from history.

Dangit, my submodules are all messed up!
```bash
# Initialize submodules if they haven't been yet
git submodule init

# Update all submodules to their proper commits
git submodule update --init --recursive

# Pull latest changes for all submodules
git submodule foreach git pull origin main

# If submodules are on wrong commits
git submodule foreach git reset --hard
git submodule update --recursive
```

