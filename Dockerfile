# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:caf0bae450119a2f72633ec23603196681b9e5b778a47f566d30a0613b45c485 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:18974e90873baf1217c62e0daeed36ea873fb577193f7ce4814c051e78c68c03

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
