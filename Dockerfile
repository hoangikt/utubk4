# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4266f833dc9460c954d4ccdb99781c44949296d6339cf58788df6efc8299b433 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:47fe69adf3f2a9a8875b1bbfa1a1eeccf1a79dec952cdf5334b8517141a025a9

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
