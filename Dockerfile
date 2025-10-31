# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:985874fb9565c617dffeff32a6956095e742387cbaed3a536375437add7b16e0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:383c8b591d31dd66d36fc0a565a24c7ce7ed04df63114f0074489bc13a8dc925

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
