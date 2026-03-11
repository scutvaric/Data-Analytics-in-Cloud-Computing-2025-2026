# EX_2 — Virtualization and Containers on Azure (VM + Podman)

In this exercise you will run the same small analytics workload in three ways:

- **Virtualization (IaaS):** run on an **Azure VM** (you manage OS + runtime)
- **Containers:** run inside a **Podman container** (packaged workload, isolated processes, shared host kernel)
- **Managed containers:** run the container on **Azure Container Instances (ACI)** using **Azure Container Registry (ACR)**

> Full step-by-step instructions are in **`EX_2_instructions.pdf`** (one-liners + portal steps).

---

## Public dataset

We use the **UCI Wine Quality** dataset (downloaded during the lab):
- `winequality-red.csv` (CSV delimiter is `;`)

Metrics computed (same everywhere):
1. Total rows
2. Average alcohol
3. High-quality count (quality >= threshold)
4. Most common quality score

Configuration via environment variables:
- `QUALITY_THRESHOLD` (default: `7`)
- `DATA_FILE` (path to CSV; default: `winequality-red.csv`)

---

## Copying code (recommended)

- **One-liner commands** are safe to copy from the PDF instructions.
- **Longer code** should be copied from the repo files (prevents indentation/formatting issues when copying from PDF).

Copy from these files:
- `wine_metrics.py`
- `Containerfile`

---

## Files in this folder

- `EX_2_instructions.pdf` — full lab instructions (VM + Podman + Cloud Shell ACR/ACI)
- `wine_metrics.py` — analytics script (host run + container run)
- `Containerfile` — container build file for Podman (Dockerfile syntax)


---

## Notes

- If your subscription restricts regions, choose an **allowed region** for VM/ACR/ACI.
- Clean up resources after the lab (delete the resource group) to avoid costs.