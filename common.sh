source "/etc/init.d/functions.sh"

GENTOO_CACHE="${GENTOO_CACHE:-${HOME}/cache/gentoo-portage}"
REPO_NAME=$(<"${TOPDIR}"/profiles/repo_name)
BLACKLIST=$(<"${TOPDIR}"/profiles/releases/zentoo/eupdate.blacklist)

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

leix() {
	eix --cache-file "${TOPDIR}"/eix.cache.${REPO_NAME} \
		"$@"
}

fcopy() {
	for file in "$@"; do
		mkdir -p "$(dirname "${TOPDIR}/${file}")"
		einfo "  - ${file}"
		cp "${GENTOO_CACHE}/${file}" "${TOPDIR}/${file}"
	done
}

is_overlay() {
	[[ $(<"${TOPDIR}"/profiles/repo_name) =~ "^zentoo" ]]
}

is_blacklisted() {
	for a in ${BLACKLIST}; do
		if [[ ${1} == ${a} ]]; then
			eerror "${1} is blacklisted, skipping copy ..."
			return 0
		fi
	done

	return 1
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
