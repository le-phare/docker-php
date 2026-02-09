build:
	docker buildx bake --pull

build-arm:
	docker run --privileged --rm tonistiigi/binfmt --install all
	docker buildx bake --pull --set '*.platform=linux/arm64' image-all
