# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:42c7616876638d3fc9f6663aeb159a346ebe494aced2c7c2c1bb990245ba45b8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8ee621c22371d08cc07f734704837da58b48b12fe52815fd81e1f426c082fb6c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
