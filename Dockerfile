# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e55c66e1405ff03cf60c56c8c11bba46a272796ace158cd913dad5998caaf58a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f23c2b7cd3d6b18aed6ad6e1099d79668ff62ba49078e81bb558e5a1c7581fd8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
