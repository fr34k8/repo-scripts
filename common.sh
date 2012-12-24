source "/etc/init.d/functions.sh"

GENTOO_CACHE="${GENTOO_CACHE:-${HOME}/cache/gentoo-portage}"
REPO_NAME=$(<"${TOPDIR}"/profiles/repo_name)

die() {
	eerror "$@"
	exit 1
}

geix() {
	eix --cache-file "${TOPDIR}"/eix.cache.gentoo \
		--exact \
		--nocolor \
		--pure-packages \
		"$@"
}

is_overlay() {
	[[ $(<"${TOPDIR}"/profiles/repo_name) =~ "^zentoo" ]]
}

setup_portdir() {
	if is_overlay; then
		export PORTDIR=$(realpath ${TOPDIR}/../../zentoo)
		export PORTDIR_OVERLAY=${TOPDIR}
	else
		export PORTDIR=${TOPDIR}
		export PORTDIR_OVERLAY=
	fi
}
