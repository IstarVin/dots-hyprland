for i in $(find .config -maxdepth 1 -mindepth 1); do
  rm -rf "${HOME:-/home/aj}/$i"
  ln -sf "$(pwd)/$i" "${HOME:-/home/aj}/$i"
done

for i in $(find .dots -maxdepth 1 -mindepth 1); do
  rm -rf "${HOME:-/home/aj}/$(basename "$i")"
  ln -sf "$(pwd)/$i" "${HOME:-/home/aj}/$(basename "$i")"
done
