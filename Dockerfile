# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:56efc8c00c3db8998a5ab327ffa3d4a60527211eb4c4e90121f5da1baa100932 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4e0071d93c68dc02059f220342a75cec135b252970416cb4e4bfd28024c7e2e1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
