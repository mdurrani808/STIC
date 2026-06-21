---
title: Networking Project
description: Networking project for CMSC398W.
---

## Overview

In this project, imagine you are a software engineer / sysadmin at a company and you receive 3 customer tickets triaged to you. It's your job to read each ticket and diagnose the issue using common Linux networking tools.

See the tickets [here](https://github.com/cmsc398w/398W_NetworkingProject/tree/main).

You do not need to worry about the contents of the Dockerfiles or Docker Compose files.

:::note
You may see an issue related to `undefined symbol: EVP_MD_CTX_get_size_ex` on Ticket 2. This is related to an open upstream bug, but you can reason about the bug by examining the config file.
:::

## Requirements

You will need Docker installed on your machine. See [Get Started with Docker](https://www.docker.com/get-started/).

### Write Up (15 points each x 3 tickets)

For each ticket, write a one paragraph (8 sentences max) bug report containing:

- A brief description of the issue (2 points)
- Steps you took to reproduce the issue (4 points)
- What tools you used to diagnose the issue -- you **must** include the specific commands run and why (4 points)
- What is the issue? (5 points)

You must use a tool covered in class or in the networking notes to receive credit.
