# flyline_link_and_enable.sh
#
# The rerunnable, bare minimum to get flyline working in a bash shell.
#
# It checks  to see if the soft link needed already exists.
# It will also output a line you can put in your bashrc file to register flyline for all sessions.
#
# Source this file in a currently running bash shell.
# You'll know it's working if you see a "glowing" cursor.

FLYLINE_VERSION="1.3.0"
FLYLINE_INVOCATION="flyline"
VERSIONED_FLYLINE_LIB="/opt/homebrew/Cellar/flyline/${FLYLINE_VERSION}/lib/bash/flyline"
HOMEBREW_LIB_LINKS_DIR="/opt/homebrew/lib"
LINKED_FLYLINE_LIB="${HOMEBREW_LIB_LINKS_DIR}/flyline.dylib"

if [[ -L "${LINKED_FLYLINE_LIB}" ]]; then
  echo "Flyline is already linked to '$(readlink -f %R "${LINKED_FLYLINE_LIB}")'"
else
  ln -s "${VERSIONED_FLYLINE_LIB}" "${LINKED_FLYLINE_LIB}"
fi

# Conveniently dump the rc configuration for flyline to STDOUT.
cat <<-RC_CODE
	Add the following to your bash startup file:
	enable -f "${LINKED_FLYLINE_LIB}" "${FLYLINE_INVOCATION}"
	RC_CODE
