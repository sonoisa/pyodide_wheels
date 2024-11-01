source /emsdk/emsdk_env.sh

cd /src
git clone -b 0.8.0 --recursive https://github.com/openai/tiktoken
cd tiktoken
pyodide build


cd /src
git clone -b v1.39.0 --recursive https://github.com/openai/openai-python
cd openai-python
python3 -m build


# cd /src
# git clone  -b 2.1.0 --recursive https://github.com/urllib3/urllib3
# cd urllib3
# python3 -m build


# cd /src
# git clone  -b v4.7.6 --recursive https://github.com/aio-libs/multidict
# cd multidict
# pyodide build


# cd /src
# git clone -b v4.0.0a1 https://github.com/aio-libs/aiohttp
# cd aiohttp
# cd /src/aiohttp/vendor
# rm -rf http-parser
# git clone https://github.com/nodejs/http-parser
# cd /src/aiohttp
# cython -3 aiohttp/*.pyx
# pyodide build


# cd /src
# git clone  -b v1.4.0 --recursive https://github.com/aio-libs/frozenlist
# cd frozenlist
# make cythonize
# pip install build==1.2.0
# pyodide build
