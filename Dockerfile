# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:24ab6598248da608a35ff3d5cd958205b819fe9d8265581c2f364ddfc6abd753 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7b27b4bfa2836f4c7007238658754d94a06ba84461a7720f2e07e284c6e564a1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
