EAPI=7

inherit toolchain-funcs

DESCRIPTION="libclut - A C colour lookup table library"
HOMEPAGE="https://github.com/maandree/libclut"

EGIT_COMMIT=fcd672bf6ddceff1e0e2fcd15933c3178e1f9402
SRC_URI="https://github.com/maandree/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}/

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

IUSE="+doc"

BDEPEND=">=sys-apps/texinfo-4.11
	doc? ( virtual/texi2dvi )"

PATCHES="${FILESDIR}/Stop-configure-script-from-including-random-env-vars.patch"

src_prepare() {
	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	if use doc; then
		local extra_emakeargs=(install-pdf install-dvi install-ps)
	else
		local extra_emakeargs=()
	fi
	emake DESTDIR="${D}" install-lib install-info "${extra_emakeargs[@]}"
	dodoc NEWS README COPYING
}
