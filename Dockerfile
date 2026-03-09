# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4b05460cc186cfd85deab1bfa1013788c982f9b9a23f52388bfb820f34bea874 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e1d518a526adce156f88af1adba65428a352fbb8f753020a0cba899399662036

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
