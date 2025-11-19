# ASL Manual
This is the manual found at (https://allstarlink.github.io). All
contributions are welcome!

## Contributing to the Manual
To view and edit the manual is simple. Simply clone the ASL-Manual
project, open a Codespace container, and begin editing.
Alternately, install mkdocs (see below per platform),

## Github Codespace
The simplest way to get editing is using Github Codespace.  After cloning
the repository, click on the green **"<>Code"** button, choose **"Codespaces"**, and
select **"+"** to create a new codespace.  Github will create
a container with everything configured and ready to edit.  Review the
[Codespace quickstart](https://docs.github.com/en/codespaces/quickstart) for
more details.

## Installing locally
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
for Markdown. It also has plugins to help with managing a Git repository
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

### Windows 10/11 and WSL2

This procedure will configure a WSL2 environment on your local machine to run Linux under (for those more familiar with operating Git in CLI under Linux), and integrate that with using VS Code in the host Windows environment for editing the manual.

#### Configure a WSL2 Distribution

- Open an elevated Command Prompt window
- Install Ubuntu under WSL2:
    ```
    wsl --install -d Ubuntu-24.04
    ```
- Create a user
- Run `sudo apt update && apt upgrade` to update the distro
- Install the required packages:
    ```
    sudo apt install git python3-pip python3.12-venv
    ```

#### Setup Git Environment for SSH Authentication

- SSH somewhere (anyehere), so that ~/.ssh gets created automatically, it doesn't exist by default.
- Create a default public/private keypair:
    ```
    ssh-keygen -t rsa -b 4096 -C "youremailaddress"
    ```
- Accept the default filename, `id_rsa` as we're just using this environment for manual updates, and it means we don't have to manually add more keys to ssh-agent.
- Add a passphrase (if desired), or just hit enter.
- Once the key is generated, view the public key, and copy it to your clipboard:
    ```
    cat ~/.ssh/id_rsa.pub
    ```
- Login to [Github](https://github.com) and go to your `Settings` and the `SSH and GPG Keys`.
- Add a new SSH key by clicking the button, give it a name, note that this is an `Authentication` key, and then paste your clipboard into the box and add the key.
- Repeat the above step to add the same key again, but this time, instead of an `Authentication` key, choose `Signing` key.
- Back in your WSL2 console, test with `ssh -T git@github.com`. Accept their public key, then you should receive confirmation with your username returned that your authentication was successful.
- See [Connecting to Github with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) for additional help.
- Now, we need to set up some defaults for pushing back to the repo, namely your Github ID and Name (the email address associated with your Github account):
    ```
    git config --global user.email "youremail@somewhere.com"
    git config --global user.name "Your Name"
    ```

#### Install VS Code in Windows

- [Download and install VS Code](https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user).
- Review [Developing in WSL](https://code.visualstudio.com/docs/remote/wsl).
- Your WSL distro should still be running in the background
- Launch VS Code, it should detect WSL running and ask you if you want to install the WSL Extension, select yes.
- Once you are in VS Code, you should be able to connect to your WSL environment to edit/preview the manual.

#### Setup the ASL3 Manual Repo

- In your WSL console, clone the repo. We will do it via SSH, since we've already pre-configured Git to work with SSH authentication.
    ```
    git clone git@github.com:AllStarLink/ASL3-Manual.git
    cd ASL3-Manual
    python3 -m venv ~/.mkdocs
    . ~/.mkdocs/bin/activate
    ```
- The first time you clone the repo, you will need to install some additional prerequisites via `pip`:
    ```
    pip install -r ./requirements.txt
    ```
- You should now have a functioning environment for editing the ASL3 Manual.

#### Working with the ASL3 Manual Repo

- The basic workflow will be:
    - Create a new branch for the thematic edit/add you want to make
    - Switch to (checkout) your new branch
    - Edit the pages in VS Code
    - Commit your changes
    - Push your changes back to the origin repo
    - Open a Pull Request for review
    - Switch back to (checkout) the main branch
    - Create another branch for additional thematic changes
- Create a new branch and switch to it:
    ```
    git branch creating_sample_man_page
    git checkout creating_sample_man_page
    ```
- Now over in your Windows host, in VS Code, you should be able to connect to your WSL instance, browse to the manual folder in the explorer, and see all the files.
- You can confirm which branch you are on by using the `Source Control ` button on the left menu.
- You can preview your edits in realtime by using the `Open Preview to the Side` button in the top right of the window.
- Once you've made all your changes for this branch, be sure to save your changes!
- Back in your WSL console, confirm Git sees the files you've modified using `git status`.
- When you are ready to push your changes:
    ```
    git commit .
    git push origin <branch_name>
    ```
- If your push is successful, you should receive confirmation, along with a reminder to open a Pull Request (it even provides you the URL).
- Switch back to the main branch with `git checkout main`. You can confirm you're on the main branch with `git status`.
- Now, you can create a new branch for another update, and follow the same process.
- To get out of the Python `venv`, use the `deactivate` command.
- Each time you start up a new WSL session to work on the manual, you'll need to run these commands:
    ```
    cd ASL3-Manual
    python3 -m venv ~/.mkdocs
    . ~/.mkdocs/bin/activate
    ```
- You will also want to make sure your local repo is updated and in synch with Github using `git pull origin main`.

### Windows 10/11
- Download and install the latest stable version of Python3 (currently Python 3.13) with the Windows installer - [Downloads](https://www.python.org/downloads/)
- Download and install the latest version of Git with the Windows standalone installer - [Downloads](https://git-scm.com/downloads/win)
- If you are not familiar with working with SSH keys, install the GitHub cli tool:
    ```psexec
    winget install --id GitHub.cli
    ```
- If you don't already have a preferred text/code editor, install VSCode from the Windows Store - [Store Link](https://apps.microsoft.com/store/detail/XP9KHM4BK9FZ7Q?ocid=pdpshare)
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

### Debian Linux
- Install git and Python Pip
    ```bash
    apt install git python3-pip
    ```
- Checkout the project as described below in **Contributing to the Manual**
- Create a virtual python environment and install the necessary packages
    ```bash
    python3 -m venv ~/.mkdocs
    . ~/.mkdocs/bin/activate
    pip install -r requirements.txt
    ```
Every new shell, enter the python venv with `. ~/.mkdocs/bin/activate` before
beginning to use any `mkdocs` commands.

## Guides to Help Get Started
#### GitHub
- [Creating a GitHub account](https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github)
- [Verify your email with GitHub](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/verifying-your-email-address)
- [Authenticating to GitHub with gh](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git#github-cli)
- [Add an SSH key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

#### Basics of Git
- [Get started with Git](https://docs.github.com/en/get-started/getting-started-with-git/set-up-git)
- [Basic Git](https://docs.github.com/en/get-started/using-git/about-git)

#### Basics of Markdown
- [Markdown Syntax](https://www.markdownguide.org/basic-syntax/)
- [Markdown Tutorial](https://www.markdownguide.org/getting-started/)
- [MKDocs Material Markdown Add-Ons](https://squidfunk.github.io/mkdocs-material/reference/)

## Publishing to GitHub.io
This is for repo admins only.

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
git pull origin
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
