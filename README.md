
Dockerfile for doing builds of static Haskell executables using
Stack, linked against musl.

## Usage

`make build` will do a build of the docker image

`make run` will run it with `docker run`.

Building a static executable will then involve something like:

```
$ stack --skip-ghc-check --system-ghc --resolver=lts-13 build  --ghc-options '-fPIC -optl -static'
```

