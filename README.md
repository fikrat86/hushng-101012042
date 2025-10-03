# hushng-101012042

Minimal Node.js/Express app deployed to Cloud Run.

- Artifact Registry repo: hushng-101012042 (image: app)
- Cloud Run service: hushng-101012042-service (region: us-central1)

Local run (Docker Compose):

1. Build and start
	- Exposes http://localhost:8080
2. App respects PORT env var (defaults handled by Compose/Dockerfile)

CI/CD (Cloud Build):
- Builds and pushes: us-central1-docker.pkg.dev/$PROJECT_ID/hushng-101012042/app:${SHORT_SHA}
- Deploys to: hushng-101012042-service
