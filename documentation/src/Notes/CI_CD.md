# Continuous Integration & Continuous Deployment

## Continuous Integration (CI)

### Why/How is CI used in devlopment?

Let’s say I’m working on software that controls a robot that makes food. S, from pasta to pancakes, and everything works pretty smoothly. But now we’ve been asked to add support for a new recipe: **an omelet**.

This new recipe is a little more complicated because it depends on additional timing, temperature adjustments, and the robot’s ability to flip the omelet mid-cook. It means adding new logic to our code and adjusting some test cases to make sure nothing else breaks.

Here’s how Continuous Integration (CI) helps make this kind of change easy and safe:


#### Step-by-Step: Adding a New Feature with CI

1. **Get the Latest Code**
   - I open my development environment and grab the latest code using:
     ```bash
     git pull origin main
     ```
   - This ensures I’m working on top of the most recent version of the robot's recipe software.

2. **Build and Test Locally**
   - Before making any changes, I run a local build:
     - It checks my environment is set up properly.
     - It compiles or packages the code.
     - It runs all the current automated tests.
   - If anything fails, I fix it first before starting on the omelet logic, that way I know I’m not building on top of something already broken.

3. **Add the Omelet Logic**
   - I implement the new cooking instructions for the robot to handle omelets.
   - I write new automated tests to confirm that it cooks an omelet correctly (and doesn't mess up scrambled eggs or pancakes).
   - I keep running the build and test suite often as I work to catch bugs early.

4. **Sync Before Pushing**
   - Before I push my changes, I pull from the main branch again because one of my teammates just added code for a new salad recipe.
   - If there are conflicts or updates, I merge them and rerun tests to make sure everything still works.

5. **Push the Changes**
   - Once all tests pass locally, I push the changes to the central repo:
     ```bash
     git push origin main
     ```

6. **CI Server Kicks In**
   - A CI service like GitHub Actions, GitLab CI, or Jenkins sees the push.
   - It checks out the updated code, runs the build and all tests again in a clean, isolated environment.
   - This confirms the change works not just on *my* machine but in the shared build system too.

7. **Get Feedback**
   - If everything passes, I get a notification that the omelet logic is good to go.
   - If anything fails, I can review logs, fix the problem, and repeat.


---

### What is Continuous Integration?

**Continuous Integration (CI)** is the practice of automatically building and testing code *every time you make a change* and push it to a shared repository.

CI is built around this philosophy:
> *"Integrate early, integrate often."*

It helps development teams:
- Avoid painful last-minute integrations.
- Catch bugs early.
- Ensure everyone is working with the latest, working codebase.
- Encourage modular, testable code design.

---

### Core Components of CI

| Component        | Purpose                                                   |
|------------------|-----------------------------------------------------------|
| **Version Control** | Store and manage source code (e.g., Git, GitHub)         |
| **CI Server**       | Detect changes, trigger builds, run tests (e.g., GitHub Actions) |
| **Build System**    | Compile and bundle your project (e.g., `make`, `npm`, `gradle`) |
| **Test Suite**      | Ensure correctness via automated unit/integration tests |
| **Notification**    | Alert devs to success/failure (Slack, email, GitHub UI) |

---

### Why is CI Important?

CI keeps teams fast, clean, and confident. It:
- Shortens the feedback loop.
- Prevents the "merge hell" of late integration.
- Helps spot bugs before they hit production.
- Makes onboarding and collaboration easier.

### What a CI-Ready Project Looks Like

The earlier story gives a sense of how it *feels* to work in a Continuous Integration environment but to actually **implement CI effectively**, a few technical requirements must be met. Below are the essential foundations for a working CI system.
#### Everything Belongs in Version Control
Almost every team uses version control (typically Git), but to support CI, it’s not enough to just track the source code. Your repository should provide everything a developer needs to build and run the project from scratch.

A new team member should be able to:

1. Clone the repository on a fresh machine.
2. Run a single setup script or command.
3. Build and test the entire product with no missing files or configuration.
This includes:
- Application source code
- Automated test code
- Database schemas & seed/test data
- Build scripts
- Configuration files (e.g., `.env`, `.json`, `.yml`)
- Version-locked dependencies

> While not everything has to be stored *directly* in the repository, it should be accessible via **immutable links**  such as pinned dependencies or asset IDs that always resolve to the same resource.

#### Don't Check In Build Outputs

Only store what’s necessary to create the product, **not the product itself**.

What to store:
- `src/`
- `tests/`
- `package.json`, `pom.xml`, `requirements.txt`
- CI configs (`.github/workflows/`, `.gitlab-ci.yml`)
- Dockerfiles, setup scripts

What *not* to store:
- Compiled binaries
- Build artifacts (e.g., `/dist`, `/build`)
- Generated documentation
- Output from test reports or coverage tools

Build products should be reproducible and disposable. If they're hard to regenerate, that's a deeper problem CI is trying to fix.

#### Use a Single Source of Truth: The Mainline

CI is centered around a shared, reliable **main branch**. This is the *source of truth* for your product’s current state and should reflect the next version that’s going into production.

In Git, this is typically:
- `main` (modern default)
- `master` (legacy default)
- `trunk` (used by teams practicing Trunk-Based Development)

All feature branches are temporary; their goal is to merge cleanly into the mainline after passing all automated checks.

CI only works well when:
- Everyone integrates into `main` frequently.
- Tests are run against this branch constantly.
- The build is always green (or immediately fixed when not).

#### Automate the Build

Turning source code into a running system can soametimes involve multiple steps: compiling, copying files, generating assets, setting environment variables, loading database schemas, etc. While that can sound complex, **everything involved in building the system should be automated**.

> “Computers are designed to perform simple, repetitive tasks. As soon as you have humans doing repetitive tasks on behalf of computers, all the computers get together late at night and laugh at you.”  
> — *Neal Ford*

##### Why Automate Builds?
- Manual builds are error-prone and inconsistent.
- CI systems need builds to be reproducible on clean machines.
- Developers save time and avoid typos or environment mismatches.
- New contributors should be able to clone the repo and run a single command to get started.

---

#### Build Scripts Should Live in the Repository

All build logic should be defined using **text-based configuration or scripting** and committed to version control. This includes:
- Build tools like `make`, `gradle`, `maven`, `npm`, `poetry`, etc.
- Shell scripts (`build.sh`)
- CI workflow definitions (e.g., `.github/workflows/build.yml`)

Storing build logic as code allows:
- Easy inspection
- Collaboration
- Clear version history and diffs
- Portability across machines

Avoid tools that rely on point-and-click GUI setups for builds as they’re hard to track and impossible to replicate reliably in CI.

---

#### Use Dependency-Aware Build Tools

While small builds can be written as shell scripts, larger projects benefit from **dedicated build systems** that use a **dependency graph** model. These systems break the build process into tasks with clearly defined inputs and outputs, which allows for:

- **Incremental builds**: only what's changed gets rebuilt
- **Optimized performance**: avoid re-running expensive tasks
- **Consistency**: build steps execute in the correct order

Examples include:
- `make`
- `ninja`
- `gradle`
- `bazel`

These tools determine what needs to be rebuilt based on file modification times or hashes. For example, if you edit a CSS file, the system might only recompile that page instead of rebuilding the entire site.

---

#### A One-Command Build Rule

> **CI-Ready Rule of Thumb**:  
> Anyone should be able to take a clean machine, clone the repo, and run a single command (e.g., `./build.sh` or `make`) to build and run the entire system.

This includes:
- Installing dependencies
- Compiling or packaging
- Spinning up a test or dev database
- Running tests
- Starting the server or UI

If the system supports different environments (e.g., production, staging, test), your build scripts should support **targets or flags** for those cases:
```bash
# Examples
make test
npm run build:dev
./build.sh --skip-tests
```
#### Make the Build Self-Testing

Compiling and packaging code is just the beginning, a build that **runs but doesn't do the right thing** is just as dangerous as a build that doesn’t run at all. To support Continuous Integration, your build must also **verify behavior** through **automated tests**.

That’s what makes a **self-testing build** so important. It’s the idea that the build doesn’t just assemble the code but it also automatically confirms that the system still works as expected.


Your CI build pipeline should:
- Automatically run **unit tests** to verify logic.
- Run **integration tests** to check component interactions.
- Possibly include **end-to-end tests** for full workflows (when needed).
- Fail the build if *any* test fails. 99.9% green is still red.

Most languages now offer easy-to-use testing frameworks:
- Python: `pytest`, `unittest`
- JavaScript/Node: `jest`, `mocha`
- Java: `JUnit`
- C#: `xUnit`, `NUnit`
- Go: `go test`

These frameworks usually integrate directly with your CI tool. You’ll often see CI dashboards or terminals refer to a “green build” (all tests pass) or a “red build” (one or more fail).

Self-testing builds can also include:
- **Linters** to catch code smells and enforce style (e.g., `eslint`, `flake8`, `pylint`)
- **Security scanners** to find vulnerabilities (e.g., `Bandit`, `Snyk`)
- **Code formatters** like `black`, `prettier`, or `clang-format`
No test suite can catch everything. Tests don’t prove the **absence** of bugs but even *imperfect* tests that run automatically are **far better** than no tests at all.

S. The more confidence you have in your test suite, the safer it is to make changes and ship frequently.


#### Every Push to Mainline Should Trigger a Build

If every team member is integrating changes very frequently, the shared mainline should always reflect a clean, deployable state. But real-world development isn't perfect, people forget to pull, merge conflicts happen, environments differ.

That’s why **every push to the main branch must automatically trigger a build** in a clean, shared CI environment (e.g., GitHub Actions, Jenkins, CircleCI, etc.).

- The CI service monitors the mainline (`main`, `trunk`, or `master`).
- On each commit, it checks out the code, builds it, and runs tests.
- If the build is green, the integration is considered successful.
- If it fails, the problem can be traced directly to that recent push.

> Note: While it’s possible to use CI tools to build many branches, **true Continuous Integration focuses on verifying the mainline**. The goal is to keep one branch working at all times, not to test in isolation.

Although CI Services automate this flow, it’s also possible (though less common) to perform integrations manually on a shared machine but that defeats the purpose of fast, reliable feedback.
#### Keep the Build Fast

The value of Continuous Integration comes from **fast feedback**. If the build takes too long, developers won’t integrate frequently or they’ll ignore the results.

> The Extreme Programming (XP) rule of thumb:  
> A build should complete in **10 minutes or less**.

Modern CI tools and cloud infrastructure make this achievable. If your build takes 30–60 minutes, you’re less likely to run it on every commit and you’ll lose the rapid feedback that CI is all about.

##### How to Speed Up CI Builds:
- **Stage the build pipeline**:
  - **Commit build**: Fast, core unit tests + build checks.
  - **Secondary build**: Slower, full integration or end-to-end tests.
- **Use test doubles** for slow services (e.g., in-memory DBs, API mocks).
- **Run expensive tests in parallel** on separate CI runners.
- **Use caching** and only rebuild parts of the system that changed.
- **Monitor dependency updates** automatically treat them like external contributors that could break the build.
- **Push failed slow-stage tests upstream** by writing faster equivalents for the commit build when possible.


#### Use a Deployment Pipeline

A **deployment pipeline** (also called a staged build) is a CI best practice that breaks the build process into multiple sequential stages.

Typical setup:
1. **Commit Stage** — Fast checks, must pass before merging.
2. **Acceptance Stage** — Full system tests, DB integration, real environment.
3. **Staging/Production Stage** — Manual or auto-triggered deployment.

Each stage adds more certainty. Early builds give developers quick feedback. Later stages run heavier tests, without slowing everyone down.

> If the late-stage build catches a bug, the commit build should be strengthened to catch it earlier next time.

---

#### Test in a Clone of the Production Environment

A critical part of reliable CI is running your tests in an environment that **matches production as closely as possible**. Otherwise, bugs caused by configuration differences may slip through unnoticed.

Strategies for environment consistency:
- Use **Docker** or other containers to ensure identical app behavior.
- Match:
  - OS version
  - Database engine + version
  - Third-party services
  - Networking (IP/port settings)
  - Library versions
- If production has special constraints (e.g., low memory, weak CPU, flaky network), simulate those too.

> A passing test in dev but a crash in prod usually means the environments weren’t aligned well enough.

By testing in a cloned environment, you **eliminate an entire category of bugs** related to environment mismatch.

### Benefits of CI
#### 1. Reduced Risk of Delivery Delays

- Large-scale integrations (pre-release or long-lived feature branches) are unpredictable.
- The longer you wait to integrate, the more difficult and time-consuming the merge becomes.
- CI eliminates this by integrating small, frequent changes that are easier to manage.
- Delays are replaced with quick merges and fast recoveries often within minutes or hours, not days or weeks.
- Problems surface while there’s still time to fix them, rather than during crunch time.
#### 2. Less Time Wasted on Integration

- Integration becomes routine and uneventful.
- You’re always working with a fresh and known-good codebase.
- Less time is spent rebasing, resolving merge conflicts, or debugging old branches.
- Small, continuous merges mean you’re working with code that’s still **fresh in your mind**.
- The development team becomes more **collaborative**, because source control turns into a real-time communication channel.


### 3. Fewer Bugs, Easier Debugging

- CI enforces **self-testing code**: automated tests that catch bugs before they spread.
- Integration bugs are caught early while the change set is small and easier to diagnose.
- **Diff debugging** becomes easier: if a test fails, you only need to inspect the last handful of commits.
- CI exposes gaps in the test suite quickly and teams are incentivized to close them.

#### 4. Enables Safe, Continuous Refactoring

- CI encourages and enables continuous improvement of the codebase structure.
- Refactoring is safer because:
  - Changes are kept small.
  - Tests are run automatically.
  - Integration is fast and frequent.
- Teams don’t have to “freeze” code or avoid reworking critical modules due to fear of breaking someone else's work.
- The result: **healthier codebases**, faster onboarding, and easier scaling of features over time.

> The teams that invest more in **refactoring and tests** deliver features faster and more reliably.

### 5. Release to Production Becomes a Business Decision

- With a **Release-Ready Mainline**, any successful build is potentially shippable.
- Stakeholders can decide to release new features based on **business needs**, not technical readiness.
- This enables:
  - More frequent deployments
  - Faster user feedback
  - Tighter customer-developer collaboration
- CI removes one of the biggest blockers to fast, user-centered software development: fear of releasing unfinished or unstable code.

### When to not use CI

With all the benefits CI offers, it’s fair to ask: *Is there ever a case where we shouldn’t use Continuous Integration?*

The short answer is: **CI is usually worth adopting**, but it **does require the right context and team readiness**. Without that, CI can cause more frustration than value.

---

#### When the Team Isn't Committed

CI works best when the team:
- Works full-time on the product
- Integrates code frequently
- Collaborates closely

**Not ideal for**:
- Projects where contributors are loosely coordinated
- Teams without shared working hours or visibility into each other’s work

In these scenarios, **feature branching with pull requests** is often more practical. Even so, increasing integration frequency (e.g. shorter-lived branches) is still beneficial when possible.

---

#### When the Team Lacks Key Practices

Trying CI without these prerequisites usually backfires:
- No **self-testing code**: Bugs slip through undetected
- No **automation**: Manual builds and tests make integration painful
- No **fixing**: Developers push broken code to mainline, constantly breaking the build

CI isn’t just a tool, it’s a workflow **supported by technical practices**:
- Automated builds
- Strong test suites
- Clean, version-controlled mainline

## Continuous Deployment (CD)

### What is Continuous Deployment?

**Continuous Deployment (CD)** is the practice of automatically pushing every change that passes your CI pipeline **straight to production** wiht no manual approval required.

While Continuous Integration ensures that your code is always tested and merged cleanly, CD goes a step further and **ships** that code to your users.

> CI = “It works.”  
> CD = “Now send it!”

---
### Example: Robot Chef Deploys Omelets

Let’s say our robot chef already supports 100 recipes. After testing a new omelet feature through CI, CD takes over:

1. The new omelet logic is pushed and tested
2. CD packages the update and deploys it to production
3. Users can now order omelets with no downtime or manual work

---

### CD vs. Continuous Delivery

| Term                   | Description |
|------------------------|-------------|
| **Continuous Delivery** | Every change is automatically tested and **ready** to deploy but requires a **manual trigger** to go live. |
| **Continuous Deployment** | Every change that passes CI is **automatically deployed** no human involvement. |

---

### What a CD Pipeline Looks Like

1. **Push to Main**  
2. **CI Validates** with tests & build  
3. **CD Packages** the app (e.g., Docker container)  
4. **CD Deploys** to prod (or staging → prod)  
5. **Smoke Tests + Monitoring** check production  
6. **Feature is Live** (and rollback-ready!)


### CD General Practices

#### Green Builds Are Deployable
Only merge to `main` when you're ready to ship. If it passes CI, it should be safe to go live.

#### Manage Secrets Safely
Never hardcode credentials.
Use:
- GitHub Actions Secrets
- AWS Secrets Manager / Parameter Store
- HashiCorp Vault
- `.env.production` (encrypted)


#### Monitor Everything
Use logging and metrics tools like:
- Prometheus + Grafana
- Datadog / New Relic
- CloudWatch / Stackdriver

Setup alerts for:
- Crashes
- High latency
- Error spikes

#### Be Ready to Rollback
CD only works if bad deploys are reversible.
Rollback techniques:
- Docker image version re-pull
- Git reverts + redeploy
- Infra-level rollback (e.g., Kubernetes, Terraform)

---

### Blue/Green Deployment Strategy

**Blue/Green Deployments** keep **two environments**:
- **Blue** = current live version
- **Green** = new version being tested

### Flow:
1. Deploy to **Green** (new version)
2. Test in production-like settings
3. Switch traffic from **Blue → Green**
4. If issues occur, switch back to Blue

#### Benefits:
- Zero-downtime deploys
- Fast rollbacks
- Full prod-like validation before switching
- Easier risk isolation

#### Supported By:
- AWS Elastic Beanstalk
- Kubernetes (services + selectors)
- Google Cloud Run / App Engine
- NGINX / HAProxy (manual routing)
- Spinnaker, Argo Rollouts

### Sample Blue/Green Deploy Script:

```yaml
steps:
  - name: Deploy to Green
    run: ./deploy.sh --env green

  - name: Run Smoke Tests
    run: ./test.sh --env green

  - name: Switch Traffic to Green
    run: ./switch-traffic.sh --from blue --to green

  - name: Monitor
    run: ./monitor.sh --env green
```
---
### Sample GitHub Actions CD Workflow

```yaml
# .github/workflows/deploy.yml
name: CD Pipeline

on:
  push:
    branches: [main]

jobs:
  test-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - run: ./build.sh
      - run: ./test.sh
      - run: ./deploy.sh production
```

---

### Benefits of Continuous Deployment


| Benefit                            | Description                                                  |
|------------------------------------|--------------------------------------------------------------|
| **Fast Feedback**                | See how real users respond within minutes                    |
| **Smaller Deploys**              | Easier to debug, test, and roll back                         |
| **Continuous Refactoring**      | Enables safer, incremental changes to improve code structure |
| **Release Becomes a Business Choice** | No technical blockers delay new features              |


### When Not to Use Continuous Deployment

While CD is powerful, it’s not always the right fit.

| Situation                 | Reason                                                |
|--------------------------|--------------------------------------------------------|
| Weak test coverage     | You might ship broken code to production              |
| Regulated environments | Manual approval may be required by compliance         |
| No rollback plan       | CD without escape hatches = risky operations          |

> Tip: If your team isn’t ready for full CD, start with **Continuous Delivery** and build up confidence from there.

# References
1. Shyam, K. (2020). **Core CI/CD Concepts: A Comprehensive Overview**. *Dev.to*. Available at: [https://dev.to/kshyam/core-cicd-concepts-a-comprehensive-overview-ma6](https://dev.to/kshyam/core-cicd-concepts-a-comprehensive-overview-ma6)
2. Shore, J. (2005). **A Practical Guide to Continuous Integration**. *James Shore's Blog*. Available at: [https://www.jamesshore.com/v2/books/aoad1/ten_minute_build](https://www.jamesshore.com/v2/books/aoad1/ten_minute_build)
3. Swarmia. (2021). **Continuous Integration: What It Is and Why It’s Important**. *Swarmia Blog*. Available at: [https://www.swarmia.com/blog/continuous-integration/](https://www.swarmia.com/blog/continuous-integration/)
4. GART Solutions. (2020). **Building an Effective CI/CD Pipeline: A Comprehensive Guide**. *Medium*. Available at: [https://gartsolutions.medium.com/building-an-effective-ci-cd-pipeline-a-comprehensive-guide-bb07343973b7](https://gartsolutions.medium.com/building-an-effective-ci-cd-pipeline-a-comprehensive-guide-bb07343973b7)
5. Fitz, T. (2019). **Timothy Fitz's Blog**. *Timothy Fitz's Blog*. Available at: [http://timothyfitz.com/blog/](http://timothyfitz.com/blog/)
6. Fowler, M. (2024). **Continuous Integration**. *Martin Fowler's Blog*. Available at: [https://www.martinfowler.com/articles/continuousIntegration.html#BuildingAFeatureWithContinuousIntegration](https://www.martinfowler.com/articles/continuousIntegration.html#BuildingAFeatureWithContinuousIntegration)
