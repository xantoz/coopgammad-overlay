EAPI=7

inherit toolchain-funcs

DESCRIPTION="cg-tools - Cooperative gamma tools"
HOMEPAGE="https://github.com/maandree/cg-tools"
SRC_URI="https://github.com/maandree/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

DEPEND="media-libs/libcoopgamma"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	local emakeargs=(
		install-cmd
		install-man
	)

	emake DESTDIR="${D}" PREFIX=/usr "${emakeargs[@]}"
	dodoc COPYING LICENSE README
}
