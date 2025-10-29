# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b766b72cc0d6ca2b80f19083ec13266c613d7013928887ac7551780545d90827 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:aff11fb801109cee35db8f90412c78d6a242f4f105234764d33238553cc5d870

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
