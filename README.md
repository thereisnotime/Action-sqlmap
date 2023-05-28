# GitHub Action: sqlmap

This action runs `sqlmap` to scan a URL with the given parameters. Recommended use is with a @vX tag to ensure a stable version is used instead of @master. Versions can be found here [tags](https://github.com/thereisnotime/Action-sqlmap/tags) and sqlmap documentation for all parameters [here](https://github.com/sqlmapproject/sqlmap/wiki/Usage).

## Examples

### Start a scan

```yaml
- name: Scan with sqlmap
  uses: thereisnotime/action-sqlmap@master
  with:
    url: "https://blackfox-security.com/vuln.php?id=1"
```

### Weekly scheduled scans

```yaml
on:
  schedule:
    - cron: 0 11 * * 1 # Monday at 11 UTC

jobs:
  scan_sqlmap:
    runs-on: ubuntu-latest
    name: SCAN | sqlmap DAST
    steps:
      - name: Scan with sqlmap
        uses: thereisnotime/action-sqlmap@master
        with:
          url: "https://blackfox-security.com"
          additional_args: "--batch --crawl=2 --random-agent --forms --level=5 --risk=3"
```

### Use latest version in a job

```yaml
scan_sqlmap:
  runs-on: ubuntu-latest
  name: SCAN | sqlmap DAST
  steps:
    - name: Scan with sqlmap
      uses: thereisnotime/action-sqlmap@master
      with:
        url: "https://blackfox-security.com"
        additional_args: "--batch --crawl=2 --random-agent --forms --level=5 --risk=3"
```

### Use latest version in a job and upload the results back to the repository

```yaml
scan_sqlmap:
  runs-on: ubuntu-latest
  name: SCAN | sqlmap DAST
  steps:
    - name: Prepare environment
      run: |
        echo "START_DATE=$(date +'%d-%m-%YT%H-%M-%S-%Z')" >> $GITHUB_ENV
        echo "START_TIMESTAMP=$(date +'%s')" >> $GITHUB_ENV
        TMP_TARGET="https://blackfox-security.com"
        echo "TARGET=$TMP_TARGET" >> $GITHUB_ENV
    - name: Checkout
      uses: actions/checkout@v3
    - name: Scan with sqlmap
      uses: thereisnotime/action-sqlmap@master
      with:
        url: ${{ env.TARGET }}
        additional_args: "--batch --crawl=2 --random-agent --forms --level=5 --risk=3"
    - name: Commit and push changes
      uses: EndBug/add-and-commit@v9
      with:
        author_name: GitHub Actions
        author_email: 41898282+github-actions[bot]@users.noreply.github.com
        message: "👷 chore(sqlmap): add report for ${{ env.TARGET }}-${{ env.START_DATE }}-${{ env.START_TIMESTAMP }}"
        add: "./reports/web/*"
        pull: "--rebase --autostash"
```

## Inputs

### `url`

**Required**. Target URL (e.g. <http://blackfox-security.com/vuln.php?id=1>)

### `additional_args`

Additional arguments to pass to sqlmap. Default is `--batch` to run in non-interactive mode.

## Outputs

### `result`

JSON scan results.

### `resultb64`

JSON scan results, base64 encoded.

## Roadmap

If there is enough time or interest, I will add the following features (feel free to open PRs):

- [ ] Finish support for outputs (e.g. `result` and `resultb64`).
- [ ] Add support for notification via Slack.
- [ ] Add support for notification via Telegram.
- [ ] Add support for notification via email.
- [ ] Add support for notification via custom webhooks.
- [ ] Improve argument handling.
