EAPI=7

inherit toolchain-funcs

DESCRIPTION="libcoopgamma - Cooperative gamma library"
HOMEPAGE="https://github.com/maandree/libcoopgamma"

EGIT_COMMIT=cb13f33d17857d3e6495f5d1f3982202927d1306
SRC_URI="https://github.com/maandree/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}/

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

DEPEND="media-gfx/coopgammad"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/Stop-configure-script-from-including-random-env-vars.patch"

src_prepare() {
	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install-lib install-man
	dodoc README COPYING LICENSE
}
