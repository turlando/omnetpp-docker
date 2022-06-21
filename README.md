# omnetpp-docker

## Usage

### Build the Docker container

```
make build
```

#### Make variables

- `DOCKER`: docker-compatible binary (e.g. `podman`). Default: `docker`

### Run the Docker container

```
make WORKSPACE=$HOME/Omnet++ run
```

#### Make variables

- `DOCKER`: docker-compatible binary (e.g. `podman`). Default: `docker`
- `WORKSPACE`: path to Omnet++ workspace

Run `omnetpp -configuration /workspace' to run the IDE.
