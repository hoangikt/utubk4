# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e0df0ab3cb72380c82f8c5513538152e822a6d8994252663060adea9fdc450c2 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b969ffa5d847b5acd28bd18b12d5b6631cb69c8289f03b309e19b68608724dc6

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
