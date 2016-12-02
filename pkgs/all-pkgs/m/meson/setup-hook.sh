mesonConfigureAction() {
  configureBuildRoot

  # Meson requires a python executable for itself in the build directory
  for bin in $(ls "$(dirname "$(type -tP meson)")"/meson*); do
    echo "from subprocess import call; import sys; exit(call(['$bin'] + sys.argv[1:]))" \
      >"$buildRoot"/"$(basename "$bin")"
  done

  if [ -n "${addPrefix-true}" ]; then
    mesonFlagsArray+=(
      "--prefix" "$prefix"
    )
  fi

  # Build always Release, to ensure optimisation flags
  mesonFlagsArray+=(
    "--buildtype" "${mesonBuildType-release}"
  )

  local actualFlags
  actualFlags=(
    $mesonFlags
    "${mesonFlagsArray[@]}"
  )

  echo "Using build root: $buildRoot" >&2
  printFlags "meson configure"
  LC_ALL='en_US.UTF-8' meson "${actualFlags[@]}" "${srcRoot}" "${buildRoot}"
}

mesonFixup() {
  rm -rf "$prefix"/{share,libexec}/installed-tests
  rmdir "$prefix"/libexec >/dev/null 2>&1 || true
  rmdir "$prefix"/share >/dev/null 2>&1 || true
}

if [ -n "${mesonConfigure-true}" -a "$configureAction" = "autotoolsConfigureAction" ]; then
  configureAction=mesonConfigureAction
  if [ -z "$checkTarget" ]; then
    checkTarget="test"
  fi
  fixupOutputHooks+=(mesonFixup)
fi
