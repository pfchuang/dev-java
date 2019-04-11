## Docker Build
```shell=
docker build -t luke/dev-java github.com/pfchuang/dev-java
```
## Docker Run
```shell=
docker run -it luke/dev-java
```
Run container and delete it automatically when leaving vim.
```shell=
docker run -it --rm luke/dev-java
```
