# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:dde1a2549dd62864f0263dae8e877680837b4e738a7ecc85c671c55c069848ac as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:49fd266eb8a1331194c318b742087c7a2939cc5794fa64f17feb9e17e12703e2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
