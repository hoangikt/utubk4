# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bbb6c8149e9b60c30275f25d04f4f120ce675d6866317ffa727aaf835a9b6410 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:46ed6def26f18988e03439a57c731975e0975b797b92338af574b1125034a6b8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
