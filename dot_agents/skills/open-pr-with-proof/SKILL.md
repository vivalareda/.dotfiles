---
name: open-pr-with-proof
description: Use when the user asks you to open a pr SPECIFICALLY with proof on a web project
---

# STEPS

1. implement the changes the users asked for
2. if you have a `agent-browser` skill load it otherwise look at [docs][https://agent-browser.dev/]
3. record a video of the browser (unless asked to default to headless) showing the changes applied showing the interactions and final result
3. create the PR using the `gh pr create --attach <video-path>` flag to attach the video. It should not be committed to the repo.


