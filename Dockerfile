# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:166a4d6f825a138ce27793a0262d0ca5a2272aaceceee64c83f898c1a9ec4a2c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6bfae26ad9d39160a2a5bdd3f9d4e096a167e2cc288cf98717094aff869e7371

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
