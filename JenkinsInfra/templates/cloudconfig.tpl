#cloud-config
package_upgrade: true

packages:
    - docker.io
    - docker-compose

# create the docker group
groups:
    - docker

# assign VM's default user to the docker group
system_info:
    default_user:
        groups: [docker]