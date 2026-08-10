# syntax=docker.io/docker/dockerfile:1.7-labs

FROM python:3.15.0rc1-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /srv/app

##################################################

FROM base AS builder

RUN python3 -m venv /opt/venv && \
  pip3 install --ignore-installed --no-cache-dir --disable-pip-version-check --upgrade pip setuptools wheel

COPY requirements.txt /tmp/requirements.txt

RUN pip3 install --ignore-installed --no-cache-dir -r /tmp/requirements.txt

##################################################

FROM base AS runtime

COPY --from=builder /opt/venv/ /opt/venv/

COPY --exclude=requirements.txt ./ ./

ENTRYPOINT [ "python3", "-m", "pachca_file_sender" ]
