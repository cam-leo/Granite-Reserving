# Build the documentation

The site uses Sphinx, PyData Sphinx Theme, and MyST Markdown. Its source files live in [`docs/source/`](source/). The project planning notes in `docs/` are outside the site source.

## Preview locally

Run these commands from the repository root with Python 3.13 installed.

On macOS or Linux:

```sh
python3.13 -m venv .venv-docs
source .venv-docs/bin/activate
```

On Windows PowerShell:

```powershell
py -3.13 -m venv .venv-docs
.\.venv-docs\Scripts\Activate.ps1
```

Then install the locked dependencies, build the site, and start the preview server.

```sh
python -m pip install --require-hashes -r docs/requirements.txt
python -m sphinx -W --keep-going -b html docs/source docs/_build/html
python -m http.server --bind 127.0.0.1 --directory docs/_build/html 8000
```

Open [http://localhost:8000](http://localhost:8000). Stop the server with Ctrl+C. The build treats Sphinx warnings as errors, matching the GitHub Actions check.

## Update the dependencies

Edit [`docs/requirements.in`](requirements.in) when changing the direct dependencies. With [uv](https://docs.astral.sh/uv/) installed, regenerate and review the hash-pinned lock, then test it in a fresh environment.

```sh
uv pip compile docs/requirements.in --python-version 3.13 --universal --generate-hashes -o docs/requirements.txt
```

Add `--upgrade` to refresh existing pins. Commit both dependency files when changing the inputs.

## Publish on GitHub Pages

A repository administrator or maintainer selects **GitHub Actions** as the source under **Settings → Pages → Build and deployment**. [GitHub Pages settings](https://github.com/cam-leo/Granite-Reserving/settings/pages)

The **Documentation** workflow builds on pull requests to `main` and publishes on pushes to `main`. To redeploy manually, open **Actions → Documentation → Run workflow** and select `main`. If the `github-pages` environment has required reviewers, a reviewer must approve the deploy job. [Documentation workflow](https://github.com/cam-leo/Granite-Reserving/actions/workflows/docs.yml)

Once the deploy job succeeds, open the [project site](https://cam-leo.github.io/Granite-Reserving/).
