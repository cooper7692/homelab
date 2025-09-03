# Home Lab Config Repository

This repository is the **authoritative, versioned store** for Cooper’s home lab configs.  
It is structured for public-safe sync to GitHub (examples only) and private full sync to NAS (with secrets).  

---

## 📂 Repository Structure

```
services/
  <service>/
    versions/
      v0001/
        compose.yaml
        .env.example
        <service>.traefik.config.yaml
        config/
          config.example.yml

nodes/
  node1-ubuntu/{compose,systemd,cron,fstab}/
  node2-ubuntu/{compose,systemd,cron,fstab}/
  node3-windows/{compose,systemd,cron,fstab}/
  nas-truenas/{compose,systemd,cron,fstab}/

.githooks/pre-commit
.github/workflows/lint.yml
docs/{changelog.md,decisions.md}
scripts/{commit-config.sh,new-version.sh}
scripts/windows/{init-repo.bat,new-version.bat,new-version.ps1,commit-and-push.bat,quick-push.bat,daily-auto-snapshot.xml}
```

---

## 🔒 Safety Rules

- Real configs → `*.private.*`, `.env` (ignored).  
- Public-safe templates → `*.example.*` (committed).  
- Pre-commit hook blocks secrets.  
- Traefik configs include inline examples.  

---

## 🛠️ Helper Scripts

Linux/macOS: `commit-config.sh`, `new-version.sh`  
Windows: `init-repo.bat`, `new-version.bat/ps1`, `commit-and-push.bat`, `quick-push.bat`, `daily-auto-snapshot.xml`  

---

## 🌀 Workflow

1. Initialize repo (`init-repo.bat` or `commit-config.sh`).  
2. Add new service version (`new-version`).  
3. Commit & push safe templates.  
4. Keep `.private` files local + synced to NAS.  

---

## 📜 Version History

### v0.1 — Initial Scaffold
- Repo structure, safety rules, CI, hooks, scripts.

### v0.2 — Frigate v0001
- Added Frigate (compose, env example, traefik config, config.example).  
- Added Windows helpers.  
- Expanded README + changelog.
