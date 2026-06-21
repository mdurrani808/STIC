---
title: Git Application Day
description: Git Application Day for CMSC398W.
---

Five exercises, each starting from a broken or messy repository. Fix each one using the Git commands covered in class.

Repository: [https://github.com/cmsc398w/git-application-day](https://github.com/cmsc398w/git-application-day)

---

## Submission

After finishing each exercise, run the commands in its **Submit** section and paste the output into a file named `answers.txt`. Label each answer:

```
=== Exercise 1 ===
<paste output here>

=== Exercise 2 ===
<paste output here>
```

Upload `answers.txt` and the entire `application-day` folder (zipped) to Gradescope. The zip must include the `exercise/` subdirectory for each exercise.

---

## Exercise 1: Merge Conflict (10 min)

```bash
cd 01-merge-conflict
source setup.sh
cd exercise
```

Two branches both modified `file.txt`. Merge them so both lines end up in the file.

1. Run `git log --oneline --graph --all` to see where the branches diverged.
2. Merge `merge-conflict-branch1` into `master`.
3. Open `file.txt`, remove the conflict markers, and keep both lines.
4. Stage `file.txt` and complete the merge.
5. Confirm with `git log --oneline --graph`.

**Submit:** `git log --oneline --graph` and `cat file.txt`

---

## Exercise 2: Reset (10 min)

```bash
cd 02-reset
source setup.sh
cd exercise
```

The repo has 10 commits. Step backward using different reset modes, then use `revert` to undo a commit without rewriting history.

1. `git log --oneline` to see the starting state.
2. `git reset --soft HEAD~1` -- check `git status` and `git log`. Where did commit 10 go?
3. `git reset --mixed HEAD~1` -- what is different from `--soft`?
4. `git reset --hard HEAD~1` -- what changed compared to `--mixed`? Note that `9.txt` and `10.txt` are still present. Why?
5. You are now at commit 7. Run `git revert HEAD~1` to undo commit 6.
6. Confirm with `git log --oneline`. You should see 8 commits, the most recent a revert.

**Submit:** `git log --oneline` and `ls`

---

## Exercise 3: Detached HEAD (10 min)

```bash
cd 03-detached-head
source setup.sh
cd exercise
```

You checked out an old commit and HEAD is detached. Any commits made here are not attached to a branch and may be discarded.

1. `git status` -- read git's description of the state.
2. `git log --oneline --graph --all` -- find where HEAD and `master` are.
3. Create `hotfix.txt`, add it, and commit with message `hotfix: emergency patch`.
4. Run `git log --oneline --graph --all` to see the floating commit.
5. Save it: `git branch hotfix`
6. Switch back: `git checkout master`
7. Cherry-pick the hotfix commit onto master.
8. Confirm with `git log --oneline --graph --all`.

**Submit:** `git log --oneline --graph --all` and `ls`

---

## Exercise 4: Save My Commit (12 min)

```bash
cd 04-save-my-commit
source setup.sh
cd exercise
```

The repo was reset to an early commit. `holygrail.txt` is gone from the working directory, but the commit that added it still exists in git's object store -- just not reachable from any branch. `git reflog` records every position HEAD has been at.

1. `git log --oneline` to see the short history.
2. `ls` to confirm `holygrail.txt` is missing.
3. `git reflog` to find the commit with message `found the holy grail`.
4. `git cherry-pick <sha>` to bring that commit onto master.
5. `ls` and `cat holygrail.txt` to confirm the file is back.

**Submit:** `git log --oneline`, `ls`, and `cat holygrail.txt`

---

## Exercise 5: Bad Commit (10 min)

```bash
cd 05-bad-commit
source setup.sh
cd exercise
```

One of five commits introduced `badfile`, which should never have been committed. Use `git bisect` to find it by binary search, then `git revert` to undo it without rewriting history.

A commit is **bad** if `badfile` exists. A commit is **good** if it does not.

1. `git log --oneline` to see the history.
2. `git bisect start`
3. `git bisect bad` to mark the current state.
4. Mark the first commit good: `git bisect good <sha>`
5. For each commit git checks out, run `ls`. Mark it good or bad accordingly.
6. When bisect identifies the culprit, run `git bisect reset`.
7. `git revert <bad-commit-sha>` -- accept the default message.
8. `ls` to confirm `badfile` is gone.

**Submit:** `git log --oneline` and `ls`

---

## Grading

Each exercise is worth 10 points (50 pts total).

| Exercise | What is checked |
|----------|-----------------|
| 1 | `file.txt` has no conflict markers, contains both lines, merge commit exists |
| 2 | Log has exactly 8 commits, most recent is a revert, `8.txt` removed |
| 3 | HEAD is on master, `hotfix` branch exists, `hotfix.txt` is present, master has 5 commits |
| 4 | `holygrail.txt` exists and contains `42` |
| 5 | `badfile` is gone, a revert commit exists in the log |
