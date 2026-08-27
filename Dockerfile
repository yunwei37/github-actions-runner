ARG SLIM_IMAGE
ARG GO_VERSION=1.24.13
ARG GO_SHA256=1fc94b57134d51669c72173ad5d49fd62afb0f1db9bf3f798fd98ee423f8d730

FROM ghcr.io/actions/actions-runner:2.336.0 AS actions_runner
FROM ${SLIM_IMAGE}

ARG GO_VERSION
ARG GO_SHA256

ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1 \
    HOME=/home/runner \
    ImageOS=ubuntu24 \
    PATH=/usr/local/go/bin:${PATH} \
    RUNNER_MANUALLY_TRAP_SIG=1

RUN curl --fail --location --silent --show-error \
      "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
      --output /tmp/go.tar.gz \
    && echo "${GO_SHA256}  /tmp/go.tar.gz" | sha256sum --check --strict \
    && tar --directory /usr/local --extract --gzip --file /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz \
    && go version

RUN if ! getent group docker >/dev/null; then groupadd --gid 123 docker; fi \
    && groupadd --gid 1001 runner \
    && useradd --create-home --uid 1001 --gid runner --groups docker,sudo --shell /bin/bash runner \
    && echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner \
    && chmod 0440 /etc/sudoers.d/runner

COPY --from=actions_runner --chown=runner:docker /home/runner /home/runner

RUN /home/runner/bin/installdependencies.sh \
    && chmod 777 /home/runner

WORKDIR /home/runner
USER runner
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
