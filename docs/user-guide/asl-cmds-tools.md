# ASL Commands and Tools
The following commands and tools are the primary AllStarLink ecosystem. Each entry contains a description of the command, link to the documentation, and what package provides the command or tool.

| Command | Description | Documentation | Package |
|-|-|-|-|
| asterisk | The main console for Asterisk and app_rpt | Normally invoked with `asterisk -r` | asl3-asterisk |
| `asl-menu` | The main text-based menu for configuring ASL | [Menu Use](menu.md) | asl3 |
| `asl3-update-nodelist` | Primary engine to update the `/var/lib/asterisk/rpt_extnodes` database like for the node dictionary. | [Node Resolution](../adv-topics/noderesolution.md) | asl3-update-nodelist |
| `asl3-update-astdb` | Universal engine to provide `astdb.txt` to various applications that require the old node name database. Use this rather than a special version for every third-party app (e.g. Supermon, Node Remote, etc.) | [Node Resolution](../adv-topics/noderesolution.md) | asl3-update-nodelist |
| `allmon3-passwd` | Manage the user database and passwords for Allmon3 | [Allmon3 User Management](../allmon3/usermgmt.md) | allmon3 |
| `asl-find-sound` | Utility to help locate compatible sound devices | [manpage](../mans/asl-find-sound.md) | asl3 |
| `asl-node-lookup` | Utility to test node lookup when troubleshooting Asterisk/app_rpt connectivity issues | [manpage](../mans/asl-node-lookup.md) | asl3 |
| `asl-play-arn` | Tool to play Amateur Radio Newsline | [manpage](../mans/asl-play-arn.md) | asl3 |
| `asl-repo-switch` | Utility to change package release streams for AllStarLink | [Beta Testing](betatest.md) | asl3 |
| `asl-say` | Tool for basic statements into Asterisk like the sime | [manpage](../mans/asl-say.md) | asl3 |
| `asl-show-version` | Utility to report the package version of all related ASL3 software. Normally used in bug reports and support requests. | N/A | asl3 |
| `asl-tts` | Text-to-speech engine for AllStarLink | [Text to Speech](../adv-topics/tts.md) | asl3-tts |
| `sa818` | CLI tool for configuration SA818/DRA818-based radio modules. Use `sa818-menu in most cases. | [SA818 Page](../adv-topics/sa818modules.md) | asl3 |
| `sa818-menu` | Menu for configuring SA818/DRA818-based radio modules | [SA818 Page](../adv-topics/sa818modules.md) | asl3 |
