source "/etc/init.d/functions.sh"

GENTOO_CACHE="${GENTOO_CACHE:-${HOME}/cache/gentoo-portage}"

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
	test $(<"${TOPDIR}"/profiles/repo_name) != zentoo
}

no_overlay_support() {
	if is_overlay; then
		die "This script is not supported for overlays"
	fi
}
