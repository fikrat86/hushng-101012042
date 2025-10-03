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

## Rubric checklist
1. GitHub repo created and files uploaded (this repo: fikrat86/hushng-101012042).
2. APIs enabled in GCP: Cloud Run, Cloud Build, Secret Manager. Cloud Build settings include Cloud Run Admin + Service Account User permissions (or grant all service accounts access).
3. Artifact Registry repository: hushng-101012042 in us-central1.
4. Cloud Build host connection: GitHub account connected; repository linked.
5. Build config (cloudbuild.yaml):
	- Uses docker builder to build and tag image with ${SHORT_SHA}.
	- Pushes to Artifact Registry repo hushng-101012042.
	- Options include defaultLogsBucketBehavior: REGIONAL_USER_OWNED_BUCKET.
	- Trigger name: dc-hushng-101012042 (push on main; approval recommended).
6. Manual trigger executed; image visible in Artifact Registry under hushng-101012042 (tagged with commit SHA).
