# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7d75104053e1b1b9e3316743e52acc3113be6750918fa7b1c2600fed8b590547 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:459a10eaf994a3244330e6c514375c9064f14a34729fe75746f35d1f9fc5a149

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
