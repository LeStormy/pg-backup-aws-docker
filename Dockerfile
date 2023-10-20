FROM postgres:16

RUN apt-get update && apt-get upgrade -y

RUN apt-get update && apt-get install -y postgresql-client
RUN apt-get install -y curl wget gnupg2 unzip tar

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN mkdir -p /tmp/gnupg && chmod 700 /tmp/gnupg
COPY pubkey.gpg /tmp/gnupg/pubkey.gpg
RUN chmod 600 /tmp/gnupg/pubkey.gpg

COPY backup.sh /backup.sh

WORKDIR /

CMD ["/bin/bash", "/backup.sh"]
