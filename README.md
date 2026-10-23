# Frontaliere Ticino OSS Scanner build mirror

This repository is the compact build entry point used by Anthropic OSS Scanner.
The Dockerfile fetches a pinned commit from
[`valerielinc-ops/frontaliere-si-o-no`](https://github.com/valerielinc-ops/frontaliere-si-o-no)
and runs that repository's own `build:fast` command. Keeping the scanner entry
point separate avoids cloning the production repository's multi-gigabyte Git
history while preserving the exact source commit under review.
