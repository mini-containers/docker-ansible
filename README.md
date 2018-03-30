# mini/ansible

Alpine-powered container for [Ansible](https://github.com/ansible/ansible)

Avoid having to install Python, pip, virtualenv and others to be able to
provision servers using Ansible.

## Usage

You can simply run this container using `docker run`:

```shell
$ docker run -it --rm mini/ansible ansible-playbook --help
```

This container will have no access to your playbook, SSH keys or
configuration options, which can be exposed using a combination of volumes
and options.

### Ansible versions

Latest major versions of Ansible have been available using `MAJOR.MINOR`
combination for the image tag (ie. `2.4` represents latest 2.4.x release)

In order to use an specific or different version than latest, specify it in
the command line:

```shell
$ docker run -it --rm mini/ansible:2.1 ansible --version
```

### Volumes

This container uses `/data` as default work directory, which you can mount
to expose your local playbooks and inventory to it:

```shell
$ docker run -it -v $(pwd):/data mini/ansible:2.4 ansible-playbook -i hosts.ini deploy.yml
```

### SSH and private keys

Of course, mounting the playbooks within the container is not enough, as
Ansible requires private keys to SSH into servers.

You can place your private key in your current directory and use
`--private-key` on every invocation of ansible container:

```shell
$ docker run -it -v $(pwd):/data mini/ansible:2.4 ansible-playbook -i hosts.ini --private-key=mykey.pem deploy.yml
```

Or mount that key as the default one (`id_rsa`):

```shell
$ docker run -it -v $(pwd)/pkey.pem:/root/.ssh/id_rsa:ro $(pwd):/data mini/ansible:2.4 ansible-playbook -i hosts.ini deploy.yml
```

Please note that the key has been mounted as **read-only**, possibly
avoiding your playbooks/roles or anything else alter it.

### Dealing with `known_hosts`

Some posts online recommend disable host identity check, which is not a
good practice.

Since Docker containers are ephemeral, it is recommended you expose your
existing `known_hosts` file inside the container:

```shell
$ docker run -it -v $(realpath ~/.ssh/known_hosts):/etc/ssh/ssh_known_hosts:ro $(pwd):/data mini/ansible:2.4 ansible-playbook -i hosts.ini deploy.yml
```

Notice that the file was mounted in **read-only** mode, avoiding the
new connections from being added to the file. This is a recommended
approach to avoid possible alterations by your playbooks or the image
itself.

You can add these hosts to your personal `known_hosts` by using
`ssh-keygen` and `ssh-keyscan`:

1. Check if host already exist using `ssh-keygen -F [host_or_IP]`
2. Add new entry using `ssh-keyscan -H [host_or_IP] >> ~/.ssh/known_hosts`

You can use the DNS (host), IP or a combination of both, separated
by comma:

```shell
$ ssh-keyscan -H mysite.com,1.2.3.4 >> ~/.ssh/known_hosts
```

### Vault passwords

Depending on your setup of Docker, attempt to use vault password files from
mounted volumes might trigger errors due incorrect volume permissions.

For the time being, is recommended to use `--ask-vault-pass` option instead.

### Wrappers

As convenience to reduce typing, an script is provided within
[wrappers](wrappers) directory.

Simply copy [`docker-ansible`](wrapper/docker-ansible) into your project's
`bin` directory and customize it to your needs.

By default, the wrapper will:

1. Use `latest` version of `mini/ansible` image.
2. Mount current user `known_hosts`
3. Mount project directory (parent of `bin` one) as `/data`
4. If `PKEY` variable is found, will mount as default SSH key

Check the comments at the top of the script for available options.

#### Example

Within your project, run `deploy` playbook with `xyz.pem` key:

```shell
$ cd project

$ PKEY=~/.ssh/xyz.pem bin/ansible playbook -i hosts.ini deploy.yml
```

## Caveats

At this time, there is no easy way to share your current SSH agent with a
Docker container, which might cause passphrase prompts for your SSH keys.

## Sponsor

Work on this was made possible thanks to [AREA 17](https://area17.com).

## License

All code contained in this repository, unless explicitly stated, is
licensed under MIT license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
