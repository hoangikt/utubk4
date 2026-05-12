# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:11ea36ab984ff8c778fbabbd438fae1de5341b515bfc5f12097e34ae9c398088 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:04b61de7e81a66ccb07d04ae66b61d9e8b2f48e38d1807b05820c8fe4592653f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
