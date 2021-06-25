EAPI=7

PYTHON_COMPAT=( python3_{4,5,6,7,8,9,10} )
inherit python-single-r1

DESCRIPTION="auto-auto-complete - Autogenerate shell auto-completion scripts"
HOMEPAGE="https://github.com/maandree/auto-auto-complete"
SRC_URI="https://github.com/maandree/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

IUSE="bash-completion fish-completion zsh-completion +doc"

# python is needed during build time if making the any of the auto
# completion files, since the auto-auto-complete is run during the build
# to produce
BDEPEND="
	bash-completion? ( ${PYTHON_DEPS} )
	fish-completion? ( ${PYTHON_DEPS} )
	zsh-completion? ( ${PYTHON_DEPS} )
	>=sys-apps/texinfo-4.11
	doc? ( virtual/texi2dvi )"

RDEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	# base name of info file on $(COMMAND) rather than $(PKGNAME), just
	# like for the man page (will install info file without suffixing it
	# with the package version)
	sed -i Makefile -e 's/$(PKGNAME).info/$(COMMAND).info/g' || die "sed fix failed"

	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_compile() {
	:
}

src_install() {
	local emakeargs=(
		install-base
		install-examples
		install-info
		install-man
		$(usex bash-completion 'install-bash' '')
		$(usex fish-completion 'install-fish' '')
		$(usex zsh-completion 'install-zsh' '')
		$(usex doc 'install-doc' '')
	)

	emake DESTDIR="${D}" PREFIX=/usr \
	      SHEBANG="${PYTHON}" \
	      PKGNAME="${PF}" \
	      LICENSEDIR="/usr/share/doc" \
	      "${emakeargs[@]}"
}
