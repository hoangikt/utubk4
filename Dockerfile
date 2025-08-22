# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2bb9421bc83a3f655ab2aa54655a6853771d84ad54c3aed1056fc595157bdc7b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:50a76a053d4e769ed7bcfdf681042985b1a9c64815dbee44ced740a126378264

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
