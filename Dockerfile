ARG SLIM_IMAGE

FROM ghcr.io/actions/actions-runner:2.336.0 AS actions_runner
FROM ${SLIM_IMAGE}

ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1 \
    HOME=/home/runner \
    ImageOS=ubuntu24 \
    RUNNER_MANUALLY_TRAP_SIG=1

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
