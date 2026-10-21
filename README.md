# CI/CD Lab Starter

A small Express and TypeScript app for the CI/CD Crash Course. Use this starting point to follow along with automated testing, GitHub Actions, and deployment to Render.

The starter includes a home page, a health endpoint, and a passing health endpoint test. You will add the combined `verify` script, GitHub Actions workflow, and version endpoint during the course.

## Requirements

- Node.js 24 and npm
- Git
- GitHub and Render accounts for the deployment sections

## Get started

Clone the starter into a new folder:

```bash
git clone https://github.com/bradtraversy/cicd-lab-starter.git cicd-lab
cd cicd-lab
npm ci
```

Start the development server:

```bash
npm run dev
```

Open [localhost:3000](http://localhost:3000). The [health endpoint](http://localhost:3000/api/health) returns HTTP 200 with:

```json
{"status":"ok"}
```

Stop the server with Ctrl+C.

## Scripts

- `npm run dev`: start the development server with automatic restarts.
- `npm run typecheck`: check TypeScript without generating output.
- `npm test`: run the health endpoint test. The test starts and stops its own server.
- `npm run build`: compile the app into `dist`.
- `npm start`: run the compiled app after building it.

## Run with Docker

Build the image and start the container in the background:

```bash
docker compose up -d --build
```

Open [localhost:3000](http://localhost:3000). Set `APP_VERSION` to change the version shown on the home page (it defaults to `docker`):

```bash
APP_VERSION=1.0.0 docker compose up -d --build
```

View logs with `docker compose logs -f`, and stop the container with `docker compose down`.

Without Compose:

```bash
docker build -t cicd-lab .
docker run --rm -p 3000:3000 -e APP_VERSION=1.0.0 cicd-lab
```

### Run scripts with Docker

You don't need Node.js on your machine to run the tests or other scripts. The `test` service in `compose.yaml` builds the `test` stage of the `Dockerfile`, which has all dependencies, the source and the tests. The production image is unchanged and has none of these.

Run the tests:

```bash
docker compose run --rm --build test
```

Add a script name at the end to run that script instead:

```bash
docker compose run --rm --build test npm run verify
docker compose run --rm --build test npm run typecheck
docker compose run --rm --build test npm run build
```

- `--build` rebuilds the image so it includes your latest changes. The source is copied into the image, not shared with it live.
- `--rm` deletes the container when the command finishes, so output such as `dist` from `npm run build` is discarded.
- The `test` service uses a Compose profile, so `docker compose up` does not start it.
- To run the app, use `docker compose up -d --build` rather than `npm run dev` or `npm start`.

## Start your own repository

From inside your newly cloned `cicd-lab` folder, remove the starter's Git history and remote connection, then initialize your own repository. This preserves the app files.

These commands use Bash or Zsh. On Windows, use Git Bash.

```bash
rm -rf .git
git init -b main
git add .
git commit -m "feat: add CI/CD lab starter"
```

Create an empty `cicd-lab` repository on GitHub without a README, license, or gitignore. Replace `YOUR_USERNAME` below with your GitHub username:

```bash
git remote add origin https://github.com/YOUR_USERNAME/cicd-lab.git
git push -u origin main
```

Continue with the course to add verification and deployment. Keep `package-lock.json` committed; dependencies, build output, and environment files are excluded by `.gitignore`.

## Configuration

The server uses port `3000` unless `PORT` is set. The home page displays `APP_VERSION`, defaulting to `development`. Neither variable is required to run the starter locally.
