# flyline_manual_brew_setup.sh
#
# Takes care of manual setup of linking and enabling flyline lib in Homebrew's file hierarchy.
#
# Source this file in a currently running bash shell.
# You'll know it's working if you see a "glowing" cursor.

FLYLINE_VERSION="1.3.0"
FLYLINE_INVOCATION="flyline"
# NOTE: the homebrew recipe installs the shared lib as just "flyline" and not "flyline.dylib".
#    (lib/"bash").install shared_library("target/release/libflyline") => "flyline"
VERSIONED_FLYLINE_LIB="/opt/homebrew/Cellar/flyline/${FLYLINE_VERSION}/lib/bash/flyline"
HOMEBREW_LIB_LINKS_DIR="/opt/homebrew/lib"
LINKED_FLYLINE_LIB="${HOMEBREW_LIB_LINKS_DIR}/flyline.dylib"

# Echo red text to STDERR
errcho() { >&2 printf "\e[31m%s\e[0m\n" "$*"; }

# Check for bash as the current shell. Bail if it's not.
if [ -z "${BASH_VERSION}" ]; then
  errcho "Are you running this under bash?"
  return 1
else
  echo "bash version: ${BASH_VERSION}"
fi
errcho "1" # DBG

# Sane script execution
set -eu -o pipefail
errcho "2" # DBG

# Check for bash version > 4.4. Bail if it's not.
BASH_MAJOR_VER="${BASH_VERSINFO[0]}"
BASH_MINOR_VER="${BASH_VERSINFO[1]}"
if [ "${BASH_MAJOR_VER}" -gt 4 ] && { [ "${BASH_MAJOR_VER}" -eq 4 ] && [ "${BASH_MINOR_VER}" -ge 4 ]; }
then
  errcho "Flyline requires bash 4.4 or greater. Install a newer version with Homebrew."
  return 1
fi
errcho "3" # DBG

# Install flyline with Homebrew.
#brew install flyline

# Unregister flyline command before deleting soft link.
if command -v "${FLYLINE_INVOCATION}" &> /dev/null; then
  enable -d "flyline"
fi
errcho "3.5" # DBG

# Always delete link before another soft linking.
if [ -f "${LINKED_FLYLINE_LIB}" ]; then rm "${LINKED_FLYLINE_LIB}"; fi
errcho "4" # DBG

# Soft link flyline shared lib to $HOMEBREW_LIB_LINKS_DIR.
ln -s "${VERSIONED_FLYLINE_LIB}" "${LINKED_FLYLINE_LIB}"
errcho "5" # DBG

# Enable flyline command in bash.
#
# NOTE: "enable" is a bash builtin command for enabling and disabling bash builtin commands.
#
#   Syntax
#          enable [-a] [-dnps] [-f filename] [name …]
#
#   Key
#      -a   List each builtin with an indication of whether or not it is enabled.
#
#      -d   Delete a builtin loaded with '-f'.
#
#      -f   Load the new builtin command name from shared object filename, on systems that
#           support dynamic loading.
#
#      -n   Disable the names listed, otherwise names are enabled.
#
#      -p   Print a list of shell builtins, default if no name arguments appear.
#           With no other arguments, the list consists of all enabled shell builtins.
#
#      -s   Restrict to enable only POSIX special builtins
#
# Example:
# enable -f path_to_lib command_invocation
#
enable -f "${LINKED_FLYLINE_LIB}" "${FLYLINE_INVOCATION}"
errcho "6" # DBG

# Test invocability
if ! command -v "${FLYLINE_INVOCATION}" &> /dev/null; then
  errcho "Something bad happened. ${FLYLINE_INVOCATION} is not invocable."
  return 1
fi
errcho "7" # DBG

# Show happy, green SUCCESS!
echo -e "\n\e[32mSUCCESS!\e[0m\n"
errcho "8" # DBG

# Conveniently dump the rc configuration for flyline to STDOUT.
cat <<-RC_CODE
	Add the following to your bash startup file:
	enable -f "${LINKED_FLYLINE_LIB}" "${FLYLINE_INVOCATION}"
	RC_CODE
errcho "9" # DBG
