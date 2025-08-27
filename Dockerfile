# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:53a696211852eb96dfa7024efa7bf49154865da50c33a2fe6cd5f02effe4373f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:40a29d69c56a8908f5367a66275cbc84c9a0532234fdbe945156fdd49ef26fc5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
