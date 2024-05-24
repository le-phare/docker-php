build:
	docker buildx bake  --set '*.platform=linux/amd64'

build-arm:
	docker run --privileged --rm tonistiigi/binfmt --install all
	docker buildx bake  --set '*.platform=linux/arm64'
