
# install
virtualenv venv
source venv/bin/activate
pip install -r ./src/requirements.txt
# package
mkdir python
cp -r venv/lib python/
zip -r9 layer.zip python \
    --exclude '*.pyc' \
    --exclude '*__pycache__*' \
    --exclude '*dist-info*' \
    --exclude '*tests*' \
    --exclude '*docs*' \
    --exclude '*.egg-info*' \
    --exclude '*.pyo'