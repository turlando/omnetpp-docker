DOCKER=docker
NAME=omnetpp
WORKSPACE=nonexistent

.PHONY: build
build:
	$(DOCKER) build -t $(NAME) .

.PHONY: run
run:
	xhost +local:
	$(DOCKER) run                                \
	    --rm                                     \
	    -u $(shell id -u):$(shell id -g)         \
	    -v $(HOME)/.Xauthority:/root/.Xauthority \
	    -v /tmp/.X11-unix:/tmp/.X11-unix         \
	    -v $(WORKSPACE):/workspace               \
	    -e DISPLAY=unix$(DISPLAY)                \
	    -it                                      \
	    $(NAME)
	xhost -local:
