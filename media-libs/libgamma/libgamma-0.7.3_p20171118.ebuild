EAPI=7

inherit toolchain-funcs

DESCRIPTION="libgamma - Display server abstraction layer for gamma ramps"
HOMEPAGE="https://github.com/maandree/libgamma"

EGIT_COMMIT=7d85639cc46e28dfed4df1d91691ca53cacec5e6
SRC_URI="https://github.com/maandree/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}/

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

IUSE="xrandr vidmode drm dummy +doc"

BDEPEND=">=sys-apps/texinfo-4.11
	doc? ( virtual/texi2dvi )
	dev-lang/python
	dev-util/gpp"
DEPEND="xrandr? ( x11-libs/libxcb )
	vidmode? ( x11-libs/libX11 x11-libs/libXxf86vm )
	drm? ( x11-libs/libdrm )"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/0001-configure-add-disable-options.patch"

src_prepare() {
	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_configure() {
    ./configure --linux \
		$(use_enable xrandr 'randr') \
		$(use_enable vidmode) \
		$(use_enable drm) \
		$(use_enable dummy)
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
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" \
	      install-lib \
	      install-include \
	      install-info \
	      "${extra_emakeargs[@]}"
	dodoc README COPYING LICENSE TODO
}
