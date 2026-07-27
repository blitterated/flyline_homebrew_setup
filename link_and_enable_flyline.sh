FLYLINE_VERSION="1.3.0"
FLYLINE_INVOCATION="flyline"
VERSIONED_FLYLINE_LIB="/opt/homebrew/Cellar/flyline/${FLYLINE_VERSION}/lib/bash/flyline"
HOMEBREW_LIB_LINKS_DIR="/opt/homebrew/lib"
LINKED_FLYLINE_LIB="${HOMEBREW_LIB_LINKS_DIR}/flyline.dylib"

if [[ -L "${LINKED_FLYLINE_LIB}" ]]; then
  LINK_MESSAGE="Flyline is already linked to '${VERSIONED_FLYLINE_LIB}'"
  echo -e "\n\e[33m${LINK_MESSAGE}!\e[0m\n"
else
  ln -s "${VERSIONED_FLYLINE_LIB}" "${LINKED_FLYLINE_LIB}"
fi

# Conveniently dump the rc configuration for flyline to STDOUT.
cat <<-RC_CODE
	Add the following to your bash startup file:
	enable -f "${LINKED_FLYLINE_LIB}" "${FLYLINE_INVOCATION}"
	RC_CODE
