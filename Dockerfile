# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:94105b6bc1761793a0fa73b99c815f1b42e491d9191be46b9cb7c22fba5f1508 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4953695b11dd5ac9a93ebab5f7ebe00f905a672a6c6149ba17f196e41f148a59

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
