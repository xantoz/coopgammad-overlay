EAPI=7

PYTHON_COMPAT=( python3_{4,5,6,7} )
inherit python-single-r1

DESCRIPTION="gpp - Bash-based preprocessor for anything"
HOMEPAGE="https://github.com/maandree/gpp"
SRC_URI="https://github.com/maandree/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64"

IUSE="bash-completion fish-completion zsh-completion +doc"

BDEPEND="${PYTHON_DEPS}
	>=sys-apps/texinfo-4.11
	doc? ( virtual/texi2dvi )
	bash-completion? ( dev-util/auto-auto-complete )
	fish-completion? ( dev-util/auto-auto-complete )
	zsh-completion? ( dev-util/auto-auto-complete )"

RDEPEND="${PYTHON_DEPS}
	app-shells/bash"

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
		install-core
		install-info
		install-man
		$(usex bash-completion 'install-bash' '')
		$(usex fish-completion 'install-fish' '')
		$(usex zsh-completion 'install-zsh' '')
		$(usex doc 'install-doc' '')
	)

	emake DESTDIR="${D}" PREFIX=/usr \
	      PY="${PYTHON}" \
	      SHEBANG="${PYTHON}" \
	      PKGNAME="${PF}" \
	      DOCDIR="/usr/share/doc/${PF}" \
	      LICENSEDIR="/usr/share/doc" \
	      "${emakeargs[@]}"
}
