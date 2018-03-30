#!/usr/bin/env bats

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
