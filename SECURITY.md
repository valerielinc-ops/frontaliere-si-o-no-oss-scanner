# Security

This repository is a compact build mirror used to enroll the Frontaliere Ticino
production site in Anthropic's OSS Scanner. It is not a separate application
and does not accept production data.

For security reports about the fetched production source, contact
`info@frontaliereticino.ch`. The Dockerfile pins and fetches the production
commit listed in its `FRONTALIERE_SITE_COMMIT` argument.
