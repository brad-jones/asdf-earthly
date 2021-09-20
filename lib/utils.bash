#!/usr/bin/env bash
{
  set -euo pipefail

  TOOL_NAME="earthly"
  GH_REPO="https://github.com/${TOOL_NAME}/${TOOL_NAME}"

  function log_std_err {
    local msg
    msg="$1"
    echo >&2 "${msg}" 1>&2
  }

  function fail {
    local msg
    msg="$1"
    log_std_err "asdf-${TOOL_NAME}: ${msg}"
    exit 1
  }

  function log_missing_command {
    local cmd link
    cmd="$1"
    link="$2"
    log_std_err "Error: ${cmd} not found!"
    log_std_err ""
    log_std_err "asdf-${TOOL_NAME} can not operate without it."
    log_std_err "Please install manually."
    log_std_err ""
    log_std_err "see: ${link}"
  }

  function command_exist {
    local cmd
    cmd="$1"
    if ! command -v "${cmd}" >/dev/null; then
      return 1
    fi
    return 0
  }

  function ensure_command_exists {
    local cmd link
    cmd="$1"
    link="$2"
    if ! command_exist "${cmd}"; then
      log_missing_command "${cmd}" "${link}"
      exit 1
    fi
  }

  ensure_command_exists "awk" "https://www.gnu.org/software/gawk"
  ensure_command_exists "cp" "https://en.wikipedia.org/wiki/Cp_(Unix)"
  ensure_command_exists "curl" "https://curl.se"
  ensure_command_exists "cut" "https://en.wikipedia.org/wiki/Cut_(Unix)"
  ensure_command_exists "git" "https://git-scm.com"
  ensure_command_exists "grep" "https://www.gnu.org/software/grep"
  ensure_command_exists "mkdir" "https://en.wikipedia.org/wiki/Mkdir"
  ensure_command_exists "rm" "https://en.wikipedia.org/wiki/Rm_(Unix)"
  ensure_command_exists "sed" "https://www.gnu.org/software/sed"
  ensure_command_exists "sort" "https://en.wikipedia.org/wiki/Sort_(Unix)"
  ensure_command_exists "tar" "https://www.gnu.org/software/tar"
  ensure_command_exists "uname" "https://en.wikipedia.org/wiki/Uname"

  function get_os {
    case "$(uname -s)" in
    Darwin) echo 'darwin' ;;
    Linux) echo 'linux' ;;
    *) echo 'unknown' ;;
    esac
  }
  OS="$(get_os)"

  function get_arch {
    case "$(uname -m)" in
    x86_64) echo 'amd64' ;;
    aarch64 | arm64) echo 'arm64' ;;
    armv7l) echo 'arm7' ;;
    *) echo 'unknown' ;;
    esac
  }
  ARCH="$(get_arch)"

  function sort_versions {
    sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
      LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
  }

  function list_all_versions {
    git ls-remote --tags --refs "${GH_REPO}.git" |
      grep -o 'refs/tags/.*' | cut -d/ -f3- |
      grep -v 'vscode.*' | sed 's/^v//'
  }

  function download_release {
    local version filename
    version="$1"
    filename="$2"

    local curl_opts
    curl_opts=(-fsSL)
    if [ -n "${GITHUB_API_TOKEN:-}" ]; then
      curl_opts=("${curl_opts[@]}" -H "Authorization: token ${GITHUB_API_TOKEN}")
    else
      if [ -n "${GITHUB_TOKEN:-}" ]; then
        curl_opts=("${curl_opts[@]}" -H "Authorization: token ${GITHUB_TOKEN}")
      fi
    fi

    local url
    url="https://github.com/${TOOL_NAME}/${TOOL_NAME}/releases/download/v${version}/${TOOL_NAME}-${OS}-${ARCH}"

    echo "* Downloading ${url}..."
    curl "${curl_opts[@]}" -o "${filename}" -C - "${url}" || fail "Could not download ${url}"
    echo "* Downloaded ${filename}"
  }

  function install_version {
    local install_type version install_path
    install_type="$1"
    version="$2"
    install_path="$3"

    if [ "$install_type" != "version" ]; then
      fail "supports release installs only"
    fi

    (
      mkdir -p "$install_path/bin"
      cp "${ASDF_DOWNLOAD_PATH}/${TOOL_NAME}" "${install_path}/bin/${TOOL_NAME}"
      chmod +x "$install_path/bin/${TOOL_NAME}"

      test -x "${install_path}/bin/${TOOL_NAME}" ||
        fail "Expected ${install_path}/bin/${TOOL_NAME} to be executable."

      echo "$TOOL_NAME $version installation was successful!"
    ) || (
      rm -rf "$install_path"
      fail "An error ocurred while installing $TOOL_NAME $version."
    )
  }
}
