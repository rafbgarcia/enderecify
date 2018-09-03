graphdoc -e http://localhost:4000/ -o ./doc/schema
rm -rf ../enderecify-api-docs
mv doc/schema ../enderecify-api-docs
cd ../enderecify-api-docs
git init
git add -A
git commit -m "Init"
git remote add origin git@github.com:Enderecify/Enderecify.github.io.git
git push -u -f origin master
