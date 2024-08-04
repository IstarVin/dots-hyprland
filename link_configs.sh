for i in $(find .config -maxdepth 1 -mindepth 1); do
  rm -rf "${HOME:-/home/$USER}/$i"
  ln -sf "$(pwd)/$i" "${HOME:-/home/$USER}/$i"
done

for i in $(find .dots -maxdepth 1 -mindepth 1); do
  rm -rf "${HOME:-/home/$USER}/$(basename "$i")"
  ln -sf "$(pwd)/$i" "${HOME:-/home/$USER}/$(basename "$i")"
done
