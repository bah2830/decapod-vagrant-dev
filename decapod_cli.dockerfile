FROM python:2.7

ENV DECAPOD_API_TOKEN=26758c32-3421-4f3d-9603-e4b5337e7ecc
ENV DECAPOD_API_ENDPOINT=http://10.10.10.10:9999

RUN apt-get update \
    && apt-get install -y git make \
    && pip install setuptools \
    && mkdir /app \
    && mkdir /data

RUN git clone --recurse-submodules https://github.com/Mirantis/ceph-lcm.git /decapod

WORKDIR /decapod

RUN chmod 0600 containerization/files/devconfigs/ansible_ssh_keyfile.pem \
    && ssh-keygen -y -f containerization/files/devconfigs/ansible_ssh_keyfile.pem > ~/ansible_ssh_keyfile.pem.pub \
    && chmod 0600 ~/ansible_ssh_keyfile.pem.pub 

RUN make build_eggs \
    && pip install output/eggs/decapodlib*.whl output/eggs/decapod_cli*.whl

CMD rm -f /data/cloud-init-user-data \
    && decapod -u $DECAPOD_API_ENDPOINT cloud-config \
        $DECAPOD_API_TOKEN ~/ansible_ssh_keyfile.pem.pub > /data/cloud-init-user-data
