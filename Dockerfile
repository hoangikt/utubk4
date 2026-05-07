# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:da62283d2105a938c111c13395f031af27f613c608d8749b15dcc501844e7b15 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d5621d0d63e5212f6ae9fd612c6d2a72f65155f978538f984a7a0cdafbd7cdb2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
