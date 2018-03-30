#!/usr/bin/env bats

# default image
IMAGE=${IMAGE:-mini/ansible:${VERSION}}
DOCKER_CMD="docker run -it --rm ${IMAGE}"

@test "$IMAGE: check presence of 'ansible'" {
	run $DOCKER_CMD which ansible
	[ "$status" -eq 0 ]
	[[ "$output" =~ "/usr/local/bin/ansible" ]]
}

@test "$IMAGE: check version of 'ansible'" {
	run $DOCKER_CMD ansible --version
	[ "$status" -eq 0 ]
	[[ "$output" =~ $VERSION ]]
}

@test "$IMAGE: check paramiko works" {
	run $DOCKER_CMD python -c "import paramiko"
	[ "$status" -eq 0 ]
}
