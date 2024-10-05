# pyodide_wheels

1. build docker image: `docker build -t pyodide-env .`
2. start docker container: `docker run -it --rm --name pyodide-env pyodide-env`
3. build whls in the container: `bash /src/build_whls.sh`
4. copy built whls to docker host: `bash take_whls_out_from_container.sh`
