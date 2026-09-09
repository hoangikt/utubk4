# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:de669347e9c1348d3fb952b1ab93738412bd7207769a882701691825741bfce3 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1f37785e5cdb70151f36aaa15e1e3cef4571424dbefbf4b0d8a9222535cb13ff

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
