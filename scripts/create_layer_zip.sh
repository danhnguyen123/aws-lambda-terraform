
# install
python3.11 -m venv venv
source venv/bin/activate
pip install -r ./src/requirements.txt
# package
mkdir python
cp -r venv/lib python/
zip -r layer.zip python