<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:B91C1C,50:DC2626,100:F87171&height=220&section=header&text=DevSecOps%20Shield%20Pipeline&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Shift-Left%20Continuous%20Delivery%20%7C%20Azure%20DevOps%20%26%20GitHub%20Actions&descFontSize=16&descAlignY=58" width="100%" alt="DevSecOps Shield Pipeline Banner" />

<p align="center">
  <img src="https://img.shields.io/badge/Azure_DevOps-Multi--Stage%20YAML-0078D7?style=for-the-badge&logo=azure-devops&logoColor=white" alt="Azure DevOps" />
  <img src="https://img.shields.io/badge/GitHub_Actions-Production%20Hardened-2088FF?style=for-the-badge&logo=github-actions&logoColor=white" alt="GitHub Actions" />
  <img src="https://img.shields.io/badge/Security-Shift--Left%20SAST-0052CC?style=for-the-badge&logo=aquasec&logoColor=white" alt="Security" />
  <img src="https://img.shields.io/badge/FinOps-Infracost%20Guardrail-00D084?style=for-the-badge&logo=infracost&logoColor=white" alt="Infracost" />
</p>

</div>

---

## 🧭 Overview

**DevSecOps Shield Pipeline** is a battle-tested, production-ready continuous delivery pipeline framework designed for **Azure DevOps Pipelines** and **GitHub Actions**.

It embeds **Shift-Left Security**, **Compliance as Code**, **FinOps Budget Guardrails**, and **Automated Drift Detection** directly into the pull request review lifecycle, ensuring zero insecure or unbudgeted infrastructure reaches production environments.

```mermaid
flowchart LR
    %% Custom Styling
    classDef trigger fill:#1E293B,stroke:#64748B,stroke-width:2px,color:#fff;
    classDef stage fill:#0F172A,stroke:#0284C7,stroke-width:2px,color:#fff;
    classDef sec fill:#450A0A,stroke:#DC2626,stroke-width:2px,color:#fff;
    classDef finops fill:#064E3B,stroke:#059669,stroke-width:2px,color:#fff;
    classDef gate fill:#581C87,stroke:#9333EA,stroke-width:2px,color:#fff;
    classDef deploy fill:#0C4A6E,stroke:#0284C7,stroke-width:2px,color:#fff;
    classDef rollback fill:#7F1D1D,stroke:#EF4444,stroke-width:2px,color:#fff;

    DEV([👨‍💻 PR Commit]):::trigger --> S1[Stage 1: Lint & Format<br/>tflint & fmt]:::stage
    S1 --> S2[Stage 2: Shift-Left Security<br/>Gitleaks, Checkov, Trivy]:::sec
    S2 --> S3[Stage 3: FinOps Budget Gate<br/>Infracost Cost Delta]:::finops
    S3 --> S4[Stage 4: Speculative Plan<br/>terraform plan -detailed-exitcode]:::stage
    S4 --> S5{Stage 5: Approval Gate<br/>CODEOWNERS: 2+ Leads}:::gate
    S5 -->|Approved| S6[Stage 6: Deploy & Apply<br/>Managed Identity]:::deploy
    S6 -->|Failure| RB[Automated Rollback<br/>Auto-revert & Alert]:::rollback
```

---

## ⚡ Key Pipeline Stages

| Stage | Tooling & Checks | Enforcement Target |
| :--- | :--- | :--- |
| **Stage 1: Quality & Linting** | `terraform fmt`, `tflint`, `terraform validate` | Syntax correctness, deprecated arguments, module style guides. |
| **Stage 2: Shift-Left Security** | `Gitleaks`, `Checkov`, `Trivy` | Zero committed secrets/API keys, CIS Azure benchmarks, container & IaC misconfigs. |
| **Stage 3: FinOps Budgeting** | `Infracost`, `scripts/cost-guardrail.py` | Automatically comments monthly cost impact on PRs; fails PR if delta exceeds threshold (e.g. +$250/mo). |
| **Stage 4: Speculative Plan & Drift** | `terraform plan -detailed-exitcode` | Validates target state and detects manual console drift during nightly scheduled runs. |
| **Stage 5: Production Deployment** | Azure Managed Identity, Blob Lease Locking | Zero permanent credentials in pipeline runners; automated rollback script on execution failure. |

---

## 📁 Repository Structure

```
.
├── .github/workflows/
│   └── devsecops-pipeline.yml   # Multi-stage GitHub Actions CI/CD workflow
├── azure-pipelines/
│   ├── azure-pipelines.yml      # Root Azure DevOps Pipeline
│   └── templates/
│       ├── validate-stage.yml   # Linting and syntax validation
│       ├── security-stage.yml   # Gitleaks, Checkov, Trivy steps
│       ├── finops-stage.yml     # Infracost budgeting gate
│       └── deploy-stage.yml     # Production apply with auto-rollback
├── scripts/
│   ├── drift-detector.sh        # Scheduled CLI drift auditing script
│   ├── cost-guardrail.py        # Python FinOps budget threshold gate
│   └── automated-rollback.sh    # Instant failover recovery script
├── sample-workload/             # Self-contained Terraform workload for testing
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── CODEOWNERS                   # Enterprise branch review policies
```

---

## 🚀 Setup & Execution

### 1. GitHub Actions Setup
1. Push this repository to GitHub.
2. In **Repository Settings ➔ Secrets & Variables ➔ Actions**, add:
   - `INFRACOST_API_KEY`: Infracost Cloud API Token.
   - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`: OIDC Federated Credentials for Azure.
3. Open a Pull Request on a feature branch to see the automated security and cost gates in action!

### 2. Azure DevOps Setup
1. Create a new Pipeline pointing to `azure-pipelines/azure-pipelines.yml`.
2. Configure your Azure Service Connection (`sc-enterprise-azure-sub`) using Workload Identity Federation.
3. Run the pipeline — all 4 stages execute automatically with sequential approval gates.

---

## 🛡️ Drift Detection & Nightly Cron

Run the automated drift detector locally or via scheduled pipelines:

```bash
# Execute drift detection audit
bash scripts/drift-detector.sh sample-workload
```

---

## 👤 Author

**Swapnil Agarwal**  
*Senior DevSecOps Engineer & Azure Cloud Architect*  
- **Email:** [swapnilagarwal94@gmail.com](mailto:swapnilagarwal94@gmail.com)  
- **GitHub:** [@swapnilagarwal30](https://github.com/swapnilagarwal30)  
- **LinkedIn:** [Swapnil Agarwal](https://www.linkedin.com/in/swapnilagarwal30/)
