#
# In this script:
#
#  1. We clean unused data from the disk.
#  2. We mount a large disk for docker layers.
#  3. We set up number of concurrent connections for docker pull.
#

df -h

#
# Clean up all the unused languages from the ram drives.
#
# This creates additional free space in the high speed storage area for the
# test runs.
#

sudo tune2fs -m 1 /dev/mapper/semaphore--vm--vg-root
sudo rm -rf /usr/local/golang/
sudo rm -rf /home/semaphore/.phpbrew
sudo rm -rf /home/semaphore/.kerl
sudo rm -rf /home/semaphore/.sbt
sudo rm -rf /home/semaphore/.nvm
sudo rm -rf /home/semaphore/.npm
sudo rm -rf /home/semaphore/.kiex
sudo rm -rf /home/semaphore/.rustup
sudo rm -rf /home/semaphore/.stack
sudo rm -rf /home/semaphore/.stack
sudo rm -rf /usr/lib/jvm
sudo rm -rf /opt/*

#
# Use official DockerHub repository with 10 parallel connections.
# This makes docker pull fast & stable.
#

echo '{ "registry-mirrors": [], "max-concurrent-downloads": 10 }' | sudo tee /etc/docker/daemon.json

#
# Replace storage space of Docker layers with a dedicated disk image.
#
# The /dev/vbc is a bigger (50G) disk that can be mounted to any location.
#
# Pros: The disk gives enough space for large docker images.
# Cons: It is not a ramdrive.
#
# With testing and analysis, the choice of regular disk vs ramdrive for storage
# does not introduce significant slowdown in performance. The pros outweight the
# cons.
#

# First, we save the current state of the docker partition.
sudo service docker stop
sudo mv /var/lib/docker /var/lib/docker2

# Then, we mount the disk to /var/lib/docker
echo 'type=83' | sudo sfdisk /dev/vdc
sudo mkfs.ext4 /dev/vdc1
sudo mkdir /var/lib/docker
sudo mount /dev/vdc1 /var/lib/docker/

# Finally, we restore the docker state.
sudo bash -c 'cp -R /var/lib/docker2/* /var/lib/docker'
sudo service docker start

df -h
