# markdown
markdown rendering service

## Contributing

### Prerequisits

* GNU Make
* Docker
* if using the github container registry, [Log docker in](https://docs.github.com/en/packages/guides/pushing-and-pulling-docker-images)

### Building

* copy the ```defaults.env``` example configuration to ```.env``` and edit to taste: ```$> cp defaults.env .env```
* see ```Makefile``` for the possible targets. Just running ```$> make``` will try to rebuild the project locally, but you need to explicitly call ```$> make push``` or ```$> make pull``` to interact with the container registry configured in ```.env```

### DOD

* gitflow should be used

