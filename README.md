<div align="center">

# asdf-earthly [![Release](https://github.com/brad-jones/asdf-earthly/actions/workflows/release.yml/badge.svg)](https://github.com/brad-jones/asdf-earthly/actions/workflows/release.yml)

[earthly](https://earthly.dev/) plugin for the
[asdf version manager](https://asdf-vm.com).

</div>

# Dependencies

The following basic *nix utilities are assumed to exist.
This plugin will not work without them.

- `bash`: <https://www.gnu.org/software/bash>
- `awk`: <https://www.gnu.org/software/gawk>
- `cp`: <https://en.wikipedia.org/wiki/Cp_(Unix)>
- `curl`: <https://curl.se>
- `cut`: <https://en.wikipedia.org/wiki/Cut_(Unix)>
- `git`: <https://git-scm.com>
- `grep`: <https://www.gnu.org/software/grep>
- `mkdir`: <https://en.wikipedia.org/wiki/Mkdir>
- `rm`: <https://en.wikipedia.org/wiki/Rm_(Unix)>
- `sed`: <https://www.gnu.org/software/sed>
- `sort`: <https://en.wikipedia.org/wiki/Sort_(Unix)>
- `tar`: <https://www.gnu.org/software/tar>
- `uname`: <https://en.wikipedia.org/wiki/Uname>

# Install

Plugin:

```shell
asdf plugin add earthly https://github.com/brad-jones/asdf-earthly.git
```

earthly:

```shell
# Show all installable versions
asdf list-all earthly

# Install specific version
asdf install earthly latest

# Set a version globally (on your ~/.tool-versions file)
asdf global earthly latest

# Now earthly commands are available
earthly --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on
how to install & manage versions.
