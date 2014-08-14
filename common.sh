source "/lib/gentoo/functions.sh"

GENTOO_CACHE="${GENTOO_CACHE:-${TOPDIR}/cache/gentoo-portage}"
REPO_NAME=$(<"${TOPDIR}"/profiles/repo_name)

GENTOO_EIX_CACHE="${TOPDIR}"/eix.cache.gentoo
REPO_EIX_CACHE="${TOPDIR}"/eix.cache.${REPO_NAME}

cd ${TOPDIR}

die() {
	eerror "$@"
	exit 1
}

geix() {
	env \
		PORTDIR=${GENTOO_CACHE} \
		PORTAGE_PROFILE=${GENTOO_CACHE}/profiles/default/linux/amd64/13.0 \
		eix --cache-file "${GENTOO_EIX_CACHE}" "$@"
}

reix() {
	env \
		PORTDIR=${TOPDIR} \
		PORTAGE_PROFILE=${TOPDIR}/profiles/default/linux/amd64/11.0 \
		eix --cache-file "${REPO_EIX_CACHE}" "$@"
}

fcopy() {
	for file in "$@"; do
		mkdir -p "$(dirname "${TOPDIR}/${file}")"
		einfo "  - ${file}"
		if [[ -z $EINFO_QUIET ]]; then
			cp "${GENTOO_CACHE}/${file}" "${TOPDIR}/${file}"
		else
			cp "${GENTOO_CACHE}/${file}" "${TOPDIR}/${file}" 2>/dev/null
		fi
	done
}

is_overlay() {
	[[ $(<"${TOPDIR}"/profiles/repo_name) =~ "^zentoo" ]]
}

is_blacklisted() {
	if [[ -r "${TOPDIR}"/profiles/releases/zentoo/eupdate.blacklist ]]; then
		blacklist=$(<"${TOPDIR}"/profiles/releases/zentoo/eupdate.blacklist)
		for a in ${blacklist}; do
			if [[ ${1} == ${a} ]]; then
				ewarn "${1} is blacklisted"
				return 0
			fi
		done
	fi

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
