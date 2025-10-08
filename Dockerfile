# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d05e9a6f4a5f55b69e5029e09be3135c82778e790cfbbbe8cf1302be2883e715 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:435ebc07441f0a8292d2a733bab01e66bae1c1506ffd6112def713885abdc1e6

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
