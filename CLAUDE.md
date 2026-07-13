# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

A Helm charts library published at https://robjuz.github.io/helm-charts/ and as OCI artifacts under `oci://ghcr.io/robjuz/charts`. Active charts live in `charts/` (futtertrog, kimai2, nominatim); retired charts live in `archived/` and must not be touched (Renovate ignores them too).

## Common Commands

```bash
# Fetch/vendor chart dependencies (Bitnami repo needed for older charts using HTTPS repo URLs)
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency build charts/<chart>     # honors Chart.lock
helm dependency update charts/<chart>    # re-resolves and updates Chart.lock

# Lint and render a chart locally
helm lint charts/<chart>
helm template my-release charts/<chart>

# Render with specific values to test a code path
helm template my-release charts/nominatim --set initJob.enabled=true
```

There is no test suite or chart-testing (ct) config; validate changes with `helm lint` and `helm template`.

## Release Process

Releases are fully automated by `.github/workflows/release.yaml`: any push to `master` touching `charts/**` runs helm/chart-releaser-action (GitHub Pages release + GitHub Release) and pushes the packaged charts to GHCR. Therefore:

- **Bump `version` in the chart's `Chart.yaml` with every change to that chart** — chart-releaser skips existing versions, so an unbumped chart silently doesn't release.
- Renovate handles routine bumps: it updates `appVersion`/dependency versions and auto-bumps the chart `version` (patch) per `renovate.json`. Manual changes to templates/values need a manual version bump.
- `appVersion` tracks the upstream app image tag (kimai2 uses `apache-X.Y.Z` tags, see the regex versioning rule in `renovate.json`).

## Chart Architecture

All charts are built on the **Bitnami `common` library chart** and follow Bitnami chart conventions:

- Templates delegate naming, labels, images, and pull secrets to `common.*` helpers (e.g. `common.names.fullname`, `common.images.image`, `common.labels.standard`, `common.capabilities.*`). Chart-specific helpers in `templates/_helpers.tpl` are thin wrappers around these.
- Values follow the Bitnami shape: `image.registry/repository/tag`, `commonLabels`/`commonAnnotations`, `extraEnvVars`, `resources`, `volumePermissions`, `extraDeploy` (rendered via `templates/extra-list.yaml`), networkpolicy/pdb/hpa toggles.
- Databases are bundled Bitnami subcharts (`postgresql` for nominatim, `mariadb` for kimai2/futtertrog) enabled via `<db>.enabled`, with an `externalDatabase.*` alternative — helpers like `nominatim.databaseHost` switch between them.
- Dependencies are vendored as `.tgz` in each chart's `charts/` directory alongside `Chart.lock`.

### Nominatim specifics

Nominatim (the most complex chart) has a two-phase lifecycle documented in its README: first install with `initJob.enabled: true` to download OSM data and build the database (a Job in `initJob.yaml`), then redeploy with it disabled. It also has an `updatesJob` for OSM replication updates, a separate nginx/ui layer (`nginx-configmap.yaml`, `ui-configmap.yaml`), and optional flatnode storage requiring ReadWriteMany PVs.

## Documentation

Each chart has a `README.md` with an exhaustive parameter table — update it when adding or changing values. Charts are listed on Artifact Hub, which reads chart metadata and READMEs.