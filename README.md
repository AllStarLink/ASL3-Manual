# ASL Manual
This is the manual found at (https://allstarlink.github.io). All
contributions are welcome!

## Contributing to the Manual
To view and edit the manual is simple. Simply clone the ASL-Manual
project, install mkdocs (see below per platform), and begin editing.

Installing [MkDocs](https://www.mkdocs.org/) is required to view/test
the documentation. See the setup directions below for the appropriate
platform you're running. Pages are composed in the [Markdown](https://daringfireball.net/projects/markdown/)
format.

Edits should be done in a git branch and push the branch back to
GitHub for developers to consider inclusion. A branch is simply a 
named copy of the repository that contains your changes. A branch
name should be a short label of what the change is for - for
example "add_foopage". A branch name cannot contain whitespace.
Each branch should contain a specific set of changes that are 
thematically related. 

The general workflow, using a terminal or PowerShell session is:
```bash
git clone https://github.com/AllStarLink/ASL3-Manual
cd ASL3-Manual
git branch some_label_here
git checkout some_label_here
mkdocs serve
```

Now the files may be edited. If you aren't sure what editor to use
then consider using VSCode. It supports very nice syntax highlighting
for Markdown. It also has plugins to help with managing a Git respository
if you are unfamiliar with that.

Browse http://127.0.0.1:8000 to see the existing documentation set.
As you edit files in the `docs/` directory, the web browser window will be
updated in real time by the running `mkdocs serve` command. Watch that
terminal window for any error and correct them before committing
code to the repository.

After all the edits have been made. Commit the changes and push the branch
back to GitHub:

```bash
git commit .
git push origin some_label_here
```

After that, go to the [GitHub repository](https://github.com/AllStarLink/ASL3-Manual)
and open a Pull Request for the changes. Describe the nature of the changes.
One of the core developers much approve and accept the changed.

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
- Install Python3 with the Mac installer as needed `brew install python3`
- Checkout the project as described below in **Contributing to the Manual**
- Create a virtual python environment and install the necessary packages
```bash
python3 -m venv ~/.mkdocs
. ~/.mkdocs/bin/activate
pip install -r requirements.txt
```

Every new shell, enter the python venv with `. ~/.mkdocs/bin/activate` before
beginning to use any `mkdocs` commands.

My zsh prompt now leads with `(.mkdocs)`. 

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
ASL3-Manual/
    mkdocs.yml
    docs/
allstarlink.github.io/
```
After making and verifying your updates locally you need to change
directories to the `allstarlink.github.io` repository and call the
`mkdocs gh-deploy` command from there:

```bash
cd ../allstarlink.github.io/
git reset --hard origin/main
mkdocs gh-deploy --config-file ../ASL3-Manual/mkdocs.yml --remote-branch main
```

Note that you need to explicitly point to the `mkdocs.yml` configuration file as
it is no longer in the current working directory. You also need to inform the
deploy script to commit to the `main` branch. You may override the default
with the [remote_branch] configuration setting. If you forget to change
directories before running the deploy script, it will commit to the `master`
branch of your project, which you probably don't want.

The live site will be at (https://allstarlink.github.io)
