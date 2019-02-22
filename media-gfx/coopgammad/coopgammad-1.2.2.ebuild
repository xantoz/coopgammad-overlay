EAPI=7

inherit toolchain-funcs

DESCRIPTION="coopgammad - Cooperative gamma server"
HOMEPAGE="https://github.com/maandree/coopgammad"
SRC_URI="https://github.com/maandree/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

IUSE="xrandr vidmode drm dummy"

CDEPEND="media-libs/libgamma[xrandr=,vidmode=,drm=,dummy=]"
# coopgammad actually only uses the (very macroful) header from libclut
BDEPEND="media-libs/libclut ${CDEPEND}"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

src_prepare() {
	# Make the makefile use CFLAGS argument given on the command line, and
	# append that to the CCFLAGS variable (which is used internally)
	sed -i Makefile -e 's/^CCFLAGS\s*=\(.*\)$/CCFLAGS =\1 $(CFLAGS)/' || die "sed fix failed"

	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	local emakeargs=(
		install-cmd
		install-man
	)

	emake DESTDIR="${D}" PREFIX=/usr \
	      "${emakeargs[@]}"
	dodoc COPYING LICENSE README
}
