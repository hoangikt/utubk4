# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:10dd873bce826d035f86990c03f7e1db5d28ecd8c327cccf0629df8879e00480 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:df0b981e02f6f8f56dd5fca37439255e0ba3855dd613314fb0c6b6db464293fa

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
