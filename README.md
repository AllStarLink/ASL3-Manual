# ASL Manual
This is the manual found at (https://allstarlink.github.io). All
contributions are welcome!

## Contributing to the Manual
To view and edit the manual is simple. Simply clone the ASL-Manual
project, install mkdocs (see below per platform), and begin editing.

```bash
git clone https://github.com/AllStarLink/ASL3-Manual
cd ASL3-Manual
# install mkdocs here if not already installed
mkdocs serve
```
Then browse http://127.0.0.1:8000 and the documentation.
As you edit files in the `docs/` directory, the web browser
window will be updated in real time by the running
`mkdocs serve` command. Watch that terminal window for any
error and correct them before committing code to the repository.

## Setup MkDocs
ASL-Manual is generated with [MkDocs](https://www.mkdocs.org/). While it is possible
to contribute to the manual without installing MkDocs, it would be difficult.
Fortunately MkDocs is available on all normal user platforms with Python pip.

### Windows 10/11
- Install Python3 with the Windows installer
- Checkout the project as described below in **Contributing to the Manual**
- Install mkdocs from PowerShell
```bash
pip install -r requirements.txt
```

### MacOS
- Install Python3 with the Mac installer as needed
- Checkout the project as described below in **Contributing to the Manual**
- Install mkdocs from a Terminal
```bash
pip install -r requirements.txt
```

### Debian Linux
- Checkout the project as described below in **Contributing to the Manual**
- Create a virtual python environment and install the necessary packages
```bash
python3 -m venv ~/.mkdocs
. ~/.mkdocs/bin/activate
pip install -r requirements.txt
```

Every new shell, enter the python venv with `. ~/.mkdocs/bin/activate` before
beginning to use any `mkdocs` commands.

## Site Generation
Use `mkdocs build` to compile the site into HTML. However, never
check the directory `site` into the ASL-Manual repository.

## Publishing to GitHub.io
You need working copies of two repositories on your local system. The
directory structure should look like this:
```text
ASL-Manual/
    mkdocs.yml
    docs/
allstarlink.github.io/
```
After making and verifying your updates locally you need to change
directories to the `allstarlink.github.io` repository and call the
`mkdocs gh-deploy` command from there:

```bash
cd ../allstarlink.github.io/
mkdocs gh-deploy --config-file ../ASL3-Manual/mkdocs.yml --remote-branch main
```

Note that you need to explicitly point to the `mkdocs.yml` configuration file as
it is no longer in the current working directory. You also need to inform the
deploy script to commit to the `main` branch. You may override the default
with the [remote_branch] configuration setting. If you forget to change
directories before running the deploy script, it will commit to the `master`
branch of your project, which you probably don't want.

The live site will be at (https://allstarlink.github.io)
