FROM ghcr.io/hadolint/hadolint:2.10.0-alpine

RUN apk add --no-cache shadow=~4 sudo=~1

RUN echo 'developer ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/developer && \
    chmod u+s "$(which groupadd)" "$(which useradd)" && \
    { \
    echo "#!/bin/sh -e"; \
    echo "user_id=\$(id -u)"; \
    echo "group_id=\$(id -g)"; \
    echo "getent group \$group_id || groupadd --gid \$group_id developer"; \
    echo "getent passwd \$user_id || useradd --uid \$user_id --gid \$group_id --home-dir /root developer"; \
    echo "sudo find /root -maxdepth 1 | xargs sudo chown \$user_id:\$group_id"; \
    echo "exec \"\$@\""; \
    } > /entrypoint && chmod +x /entrypoint

ENTRYPOINT [ "/entrypoint" ]
