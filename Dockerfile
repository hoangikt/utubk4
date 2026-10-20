# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:493521fad3d4633ad34c8662cd01c89bd659618d58fed0de4edaf33b8693daa6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:702c7dffc2f1665e10b2ec88a9955bd21caa9741b7840b6a05a334a62b91be54

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
