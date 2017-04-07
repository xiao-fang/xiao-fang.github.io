hexo clean
echo ">>> commit & push git changes >>>"
git pull
git commit -a -m "$1"
git push -f
echo ">>> hexo deploy >>>"
hexo d