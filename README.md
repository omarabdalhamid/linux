# CI/CD Workflow for Backend and Frontend

 CI/CD pipelines for both backend and frontend, covering workflows for feature/bugfix, develop, and main branches. The pipelines include pre-commit checks, linting, security testing, unit testing, code analysis, build processes, and deployment options to AWS services.

## Table of Contents
- [Backend CI/CD Pipeline](#backend-cicd-pipeline)
  - [Feature/Bugfix Branch Pipeline](#featurebugfix-branch-pipeline)
  - [Develop Branch Pipeline](#develop-branch-pipeline)
  - [Main Branch Pipeline](#main-branch-pipeline)
  - [Backend Deployment Options](#backend-deployment-options)
- [Frontend CI/CD Pipeline](#frontend-cicd-pipeline)
  - [Feature/Bugfix Branch Pipeline](#frontend-featurebugfix-branch-pipeline)
  - [Develop Branch Pipeline](#frontend-develop-branch-pipeline)
  - [Main Branch Pipeline](#frontend-main-branch-pipeline)
  - [Frontend Deployment Options](#frontend-deployment-options)

---

## Backend CI/CD Pipeline

### Feature/Bugfix Branch Pipeline

The pipeline for feature and bugfix branches (`^feature\/|^bugfix\/`) ensures code quality and security before merging into the develop branch.
![Feature_Branch](./img/be-dev.png "Feature_Branch CICD")
#### Pre-Commit Checks
- **Rebase_Check**: Verifies the branch is rebased against the latest develop branch to avoid merge conflicts.
- **CHANGELOG_Check**: Ensures the CHANGELOG is updated with relevant entries.
- **LFS_Check**: Validates Git LFS usage for large files.
- **Secret_Detection**: Scans for sensitive information (e.g., API keys, credentials) in the codebase.

#### Lint Testing
- **Flake8**: Enforces Python code style and detects syntax errors.
- **Pylint**: Analyzes Python code for potential errors and enforces coding standards.

#### Static Security Testing
- **Semgrep_SAST**: Performs static application security testing to identify vulnerabilities.
- **SBOM_Analysis**: Generates a Software Bill of Materials for dependency tracking.
- **Owasp_Dependency_Track**: Checks dependencies for known vulnerabilities.
- **Software_Composition_Analysis**: Analyzes third-party components for security risks.
- **Open_Source_License_Compliance**: Ensures compliance with open-source licenses.

#### Unit Testing
- **Unit_Testing_Group_1 to Group_4**: Executes unit tests in parallel groups for faster feedback.

#### Code Analysis
- **SonarQube**: Performs static code analysis for code quality, coverage, and technical debt.

#### Build and Push
- **Build_Application_Push_Nexus**: Builds the application and pushes artifacts to Nexus.
- **Build_Docker_Push_ECR**: Builds Docker images and pushes them to AWS ECR.

#### Deploy Review
- **Deploy_Review_Environment [Manual]**: Deploys to a review environment for manual validation.

#### API Testing
- **NewMan_Testing**: Runs API tests using Newman to validate endpoints.

---

### Develop Branch Pipeline

The develop branch pipeline extends the feature branch pipeline with additional integration, container scanning, and staging deployment steps.

#### Lint Testing
- **Flake8**: Enforces Python code style.
- **Pylint**: Analyzes Python code for errors and standards.

#### Static Security Testing
- **Semgrep_SAST**: Identifies security vulnerabilities.
- **SBOM_Analysis**: Tracks dependencies.
- **Owasp_Dependency_Track**: Checks for vulnerable dependencies.
- **Software_Composition_Analysis**: Analyzes third-party components.
- **Open_Source_License_Compliance**: Verifies license compliance.

#### Unit Testing
- **Unit_Testing_Group_1 to Group_4**: Runs unit tests in parallel.

#### Code Analysis
- **SonarQube**: Analyzes code quality and coverage.

#### Build and Push
- **Build_Application_Push_Nexus**: Pushes artifacts to Nexus.
- **Build_Docker_Push_ECR**: Pushes Docker images to AWS ECR.

#### Container Scanner
- **Trivy_Scanner**: Scans Docker images for vulnerabilities.

#### Integration Testing
- **Integration_Testing**: Runs integration tests to validate component interactions.

#### Deploy Develop
- **Deploy_Develop_Env**: Deploys to the development environment (AWS EKS with Helm or AWS Fargate).
  - **EKS with Helm and ArgoCD**: Uses Helm charts for deployment, followed by ArgoCD sync to ensure the cluster state matches the Git repository.
  - **Fargate**: Deploys to AWS Fargate for serverless container execution.

#### Health Check Staging
- **HealthCheck_Staging**: Verifies the staging environment's health.
- **Notify_Testing_Team**: Notifies the testing team for validation.

#### API Testing
- **API_Testing**: Executes API tests to ensure functionality.

#### Deploy Staging
- **Deploy_Staging_Env [Manual]**: Deploys to the staging environment (EKS with Helm/ArgoCD or Fargate) after manual approval.

#### Health Check Staging (Post-Deploy)
- **HealthCheck_Staging**: Re-validates the staging environment.
- **Notify_Testing_Team**: Notifies the testing team.

#### Automation Testing
- **Playwright**: Runs end-to-end browser tests for frontend functionality.

#### Load Testing
- **K6**: Performs load testing to evaluate performance under stress.

#### Dynamic Application Security Testing (DAST)
- **OWASP_ZAP**: Scans the application for runtime vulnerabilities.

---

### Main Branch Pipeline

The main branch pipeline prepares the application for production, including tagging, database migrations, and production deployment.

#### Auto Tagging
- **Symentic_Tag**: Automatically generates semantic version tags for releases.

#### Lint Testing
- **Flake8**: Enforces code style.
- **Pylint**: Analyzes code quality.

#### Static Security Testing
- **Semgrep_SAST**: Identifies vulnerabilities.
- **SBOM_Analysis**: Tracks dependencies.
- **Owasp_Dependency_Track**: Checks for vulnerable dependencies.
- **Software_Composition_Analysis**: Analyzes third-party components.
- **Open_Source_License_Compliance**: Ensures license compliance.

#### Unit Testing
- **Unit_Testing_Group_1 to Group_4**: Executes unit tests.

#### Code Analysis
- **SonarQube**: Analyzes code quality.

#### Build and Push
- **Build_Application_Push_Nexus**: Pushes artifacts to Nexus.
- **Build_Docker_Push_ECR**: Pushes Docker images to AWS ECR.

#### Container Scanner
- **Trivy_Scanner**: Scans images for vulnerabilities.

#### Integration Testing
- **Integration_Testing**: Validates component interactions.

#### UAT Database Migration
- **Liquibase_Validate**: Validates database schema changes.
- **Block_Drop_Delete**: Prevents destructive database operations.

#### Deploy UAT
- **Deploy_UAT_Env**: Deploys to the User Acceptance Testing environment (EKS with Helm/ArgoCD or Fargate).

#### Health Check UAT
- **HealthCheck_UAT**: Verifies UAT environment health.
- **Notify_SRE_Team**: Notifies the SRE team for monitoring.

#### API Testing
- **NewMan_Testing**: Runs API tests.

#### Automation Testing
- **Playwright**: Executes end-to-end tests.

#### Load Testing
- **K6**: Tests performance under load.

#### DAST
- **OWASP_ZAP**: Scans for runtime vulnerabilities.

#### Production Database Migration
- **Liquibase_Validate**: Validates production database changes.
- **Block_Drop_Delete**: Prevents destructive operations.

#### Deploy Production
- **Deploy_Develop_Env**: Deploys to production (EKS with Helm/ArgoCD or Fargate).
- **Rollback_Prod [Manual]**: Provides a manual rollback option in case of deployment issues.

#### Health Check Production
- **HealthCheck_Prod**: Verifies production environment health.
- **Notify_SRE_Team**: Notifies the SRE team for monitoring.

---

### Backend Deployment Options

#### Option 1: AWS EKS with Helm and ArgoCD
- **Commit Helm Chart**: Update the Helm chart in the repository with the new image ID.
- **ArgoCD Sync**: ArgoCD detects the commit, syncs with the EKS cluster, and deploys the updated application automatically or on manual trigger.

#### Option 2: AWS Fargate with Terraform
- **Commit Terraform Config**: Update the Terraform repository with the new image ID and configuration for Fargate tasks.
- **Deploy to Fargate**: Auto-apply Terraform changes to deploy containers on AWS Fargate via ECS services, using Docker images from ECR.

---

## Frontend CI/CD Pipeline

### Frontend Feature/Bugfix Branch Pipeline

The pipeline for feature and bugfix branches (`^feature/|^bugfix/`) ensures code quality and security before merging into the develop branch.

#### Pre-Commit Checks
- **Rebase Check**: Ensures the branch is rebased on the latest `develop` branch to avoid merge conflicts.
- **CHANGELOG Check**: Verifies that the `CHANGELOG.md` is updated with relevant changes.
- **LFS Check**: Validates Git Large File Storage (LFS) usage for large assets.
- **Secret Detection**: Scans for secrets (e.g., API keys) in the codebase using tools like TruffleHog.
- **Husky Hooks Check**: Ensures Husky pre-commit hooks (e.g., linting, formatting) are executed.
- **Node Version Check**: Confirms the correct Node.js version is used to avoid runtime issues.

#### Lint Testing
- **ESLint**: Enforces JavaScript/TypeScript code quality and coding standards.
- **Prettier Check**: Verifies code formatting consistency using Prettier.
- **Stylelint**: Lints CSS/SCSS files to ensure styling consistency.
- **TypeScript Check**: Performs type checking for TypeScript code to catch type-related errors.

#### Static Security Testing
- **Semgrep SAST**: Conducts Static Application Security Testing (SAST) to identify vulnerabilities.
- **SBOM Analysis**: Generates a Software Bill of Materials (SBOM) for dependency tracking.
- **OWASP Dependency Track**: Analyzes dependencies for known vulnerabilities.
- **Software Composition Analysis**: Ensures third-party libraries are secure and up-to-date.
- **Open Source License Compliance**: Checks for compliance with open-source licenses.

#### Unit Testing
- **Unit Testing**: Executes unit tests using Jest to validate individual components and functions.

#### Code Analysis
- **SonarQube**: Analyzes code quality, detecting code smells, bugs, and vulnerabilities.

#### Build and Push
- **Build Application Push Nexus**: Builds the frontend application and pushes artifacts to a Nexus repository.
- **Build Docker Push ECR**: Builds a Docker image and pushes it to AWS Elastic Container Registry (ECR).

#### Deploy Review
- **Deploy Review Environment [Manual]**: Deploys to a temporary review environment (e.g., AWS Amplify or AWS Fargate) for manual testing by developers or QA.
- **Commit to Terraform Repo**: Commits infrastructure changes (e.g., Amplify app config or Fargate service definitions) to a separate Terraform repository.
- **Trigger Terraform Auto-Apply**: Triggers the Terraform repository’s CI pipeline to auto-apply infrastructure changes, provisioning the review environment.

---

### Frontend Develop Branch Pipeline

#### Lint Testing
- **ESLint**: Enforces JavaScript/TypeScript code quality.
- **Prettier Check**: Verifies code formatting with Prettier.
- **Stylelint**: Lints CSS/SCSS files for consistency.
- **TypeScript Check**: Performs type checking for TypeScript code.

#### Static Security Testing
- **Semgrep SAST**: Identifies vulnerabilities via SAST.
- **SBOM Analysis**: Documents dependencies in an SBOM.
- **OWASP Dependency Track**: Checks dependencies for vulnerabilities.
- **Software Composition Analysis**: Ensures secure third-party libraries.
- **Open Source License Compliance**: Verifies license compliance.

#### Unit Testing
- **Unit Testing**: Runs unit tests with Jest.

#### Code Analysis
- **SonarQube**: Analyzes code for quality and potential issues.

#### Build and Push
- **Build Application Push Nexus**: Builds and pushes artifacts to Nexus.
- **Build Docker Push ECR**: Builds and pushes Docker images to ECR.

#### Container Scanner
- **Trivy Scanner**: Scans Docker images for vulnerabilities.

#### Deploy Dev
- **Deploy Develop Env**: Deploys to the development environment using:
  - **AWS Amplify**: For static frontend hosting with CDN.
  - **AWS Fargate**: For containerized deployments with serverless orchestration.
- **Commit to Terraform Repo**: Commits infrastructure changes to the Terraform repository.
- **Trigger Terraform Auto-Apply**: Triggers the Terraform repository’s CI pipeline to auto-apply infrastructure changes for the development environment.

#### HealthCheck Staging
- **HealthCheck Staging**: Verifies the health of the development environment.
- **Notify Testing Team**: Notifies the testing team of issues via Slack or email.

#### Deploy Staging
- **Deploy Staging Env [Manual]**: Deploys to the staging environment (AWS Amplify or AWS Fargate) for further testing.
- **Commit to Terraform Repo**: Commits infrastructure changes to the Terraform repository.
- **Trigger Terraform Auto-Apply**: Triggers the Terraform repository’s CI pipeline to auto-apply infrastructure changes for the staging environment.

#### HealthCheck Staging
- **HealthCheck Staging**: Re-validates the staging environment’s health.
- **Notify Testing Team**: Sends notifications if issues are detected.

#### Automation Testing
- **Playwright**: Runs end-to-end (E2E) tests to validate user interactions.

#### DAST
- **OWASP ZAP**: Performs Dynamic Application Security Testing (DAST) to identify runtime vulnerabilities.

---

### Frontend Main Branch Pipeline

#### Auto Tagging
- **Semantic Tag**: Generates semantic version tags (e.g., v1.0.0) based on commit messages.

#### Lint Testing
- **ESLint**: Enforces code quality.
- **Prettier Check**: Ensures formatting consistency.
- **Stylelint**: Lints CSS/SCSS files.
- **TypeScript Check**: Checks TypeScript types.

#### Static Security Testing
- **Semgrep SAST**: Runs SAST to find vulnerabilities.
- **SBOM Analysis**: Creates an SBOM for dependencies.
- **OWASP Dependency Track**: Checks for dependency vulnerabilities.
- **Software Composition Analysis**: Ensures secure libraries.
- **Open Source License Compliance**: Verifies license compliance.

#### Unit Testing
- **Unit Testing**: Executes unit tests with Jest.

#### Code Analyzer
- **SonarQube**: Analyzes code quality and vulnerabilities.

#### Build and Push
- **Build Application Push Nexus**: Builds and pushes artifacts to Nexus.
- **Build Docker Push ECR**: Builds and pushes Docker images to ECR.

#### Container Scanner
- **Trivy Scanner**: Scans Docker images for vulnerabilities.

#### Integration Testing
- **Integration Testing**: Verifies interactions between frontend and APIs/backend services.

#### UAT Release Gates
- **Lighthouse CI**: Runs performance, SEO, and best practice audits.
- **Accessibility Audit**: Ensures WCAG compliance using tools like axe-core.
- **CSP Headers Validate**: Validates Content Security Policy headers.

#### Deploy UAT
- **Deploy UAT Env**: Deploys to the UAT environment using:
  - **AWS Amplify**: For static frontend hosting.
  - **AWS Fargate**: For containerized deployments.
- **Commit to Terraform Repo**: Commits infrastructure changes to the Terraform repository.
- **Trigger Terraform Auto-Apply**: Triggers the Terraform repository’s CI pipeline to auto-apply infrastructure changes for the UAT environment.

#### HealthCheck UAT
- **HealthCheck UAT**: Verifies UAT environment stability.
- **Notify SRE Team**: Notifies the SRE team of issues.

#### Automation Testing
- **Playwright**: Runs E2E tests to validate application behavior.

#### DAST
- **OWASP ZAP**: Performs DAST to identify runtime vulnerabilities.

#### Prod Release Gates
- **Lighthouse CI**: Re-runs performance and quality audits.
- **Accessibility Audit**: Re-validates accessibility compliance.
- **CSP Headers Validate**: Re-validates CSP headers.

#### Deploy Prod
- **Deploy Prod Env**: Deploys to production using:
  - **AWS Amplify**: For scalable static hosting.
  - **AWS Fargate**: For containerized production deployments.
- **Commit to Terraform Repo**: Commits infrastructure changes to the Terraform repository.
- **Trigger Terraform Auto-Apply**: Triggers the Terraform repository’s CI pipeline to auto-apply infrastructure changes for the production environment.
- **Rollback Prod [Manual]**: Allows manual rollback to the previous stable version.

#### HealthCheck Prod
- **HealthCheck Prod**: Verifies production environment health.
- **Notify SRE Team**: Notifies the SRE team of issues.

---

### Frontend Deployment Options

- **AWS Amplify**: Ideal for static frontend applications with CDN, auto-scaling, and hosting. Infrastructure changes to Amplify app settings are committed to the Terraform repository and auto-applied.
- **AWS Fargate**: Suited for containerized applications, SSR, or dynamic frontends with serverless container orchestration via ECS. Infrastructure changes to Fargate service configuration are committed to the Terraform repository and auto-applied.