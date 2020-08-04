
default:
	echo pass

NAME=phlummox/alpine-haskell-stack
TAG=0.1

build:
	docker build --file Dockerfile  -t  $(NAME):$(TAG) .

run:
	docker -D run -it --rm  --net=host  \
	-v $$PWD:/opt/work \
	    $(NAME):$(TAG) 


