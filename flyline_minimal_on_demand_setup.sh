# flyline_minimal_on_demand_setup.sh
#
# The bare minimum to get flyline working in a bash shell for the first time.
#
# It does NOT check to see if the soft link needed already exists.
#
# Source this file in a currently running bash shell.
# You'll know it's working if you see a "glowing" cursor.

FLYLINE_VERSION="1.3.0"
FLYLINE_INVOCATION="flyline"
VERSIONED_FLYLINE_LIB="/opt/homebrew/Cellar/flyline/${FLYLINE_VERSION}/lib/bash/flyline"
HOMEBREW_LIB_LINKS_DIR="/opt/homebrew/lib"
LINKED_FLYLINE_LIB="${HOMEBREW_LIB_LINKS_DIR}/flyline.dylib"

ln -s "${VERSIONED_FLYLINE_LIB}" "${LINKED_FLYLINE_LIB}"
enable -f "${LINKED_FLYLINE_LIB}" "${FLYLINE_INVOCATION}"
