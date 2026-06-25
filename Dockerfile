# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b646dd6753d8d0a5504971b39e9e3e5a7337e1d9f970b30ad68da0ede2bbcc47 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1117c1bc4777cf6d25fe4f78bb21020b5bdf5fa940da636043292b68a1c44477

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
