# README.md

## Usage
To view and edit the manual is simple:
 - Install mkdocs on your local system: `apt install mkdocs` or see https://www.mkdocs.org/getting-started/ but don't start a new mkdocs project.
 - `clone https://github.com/AllStarLink/ASL3-Manual`
 - `cd ASL-Manual`
 - `mkdocs build` may be necessary the first run or after changes to the yaml file. 
 - `mkdocs serve`
 - browse http://127.0.0.1:8000
 - The branch you are in will display locally when you do mkdocs serve.

## Publishing to GitHub.io

You need working copies of two repositories on your local system. The directory structure should look like this:

```text
ASL-Manual/
    mkdocs.yml
    docs/
allstarlink.github.io/
```
After making and verifying your updates locally you need to change
directories to the `allstarlink.github.io` repository and call the
`mkdocs gh-deploy` command from there:

```sh
cd ../allstarlink.github.io/
mkdocs gh-deploy --config-file ../ASL-Manual/mkdocs.yml --remote-branch main
```

Note that you need to explicitly point to the `mkdocs.yml` configuration file as
it is no longer in the current working directory. You also need to inform the
deploy script to commit to the `main` branch. You may override the default
with the [remote_branch] configuration setting. If you forget to change
directories before running the deploy script, it will commit to the `master`
branch of your project, which you probably don't want.

The live site will be at https://allstarlink.github.io
