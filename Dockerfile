# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:369768c6ee466cc726ebab82e1b590f2d5a78507d134b17912f3e5c58de950ff as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3b1c6334c5a216c52b4059f148fa5edbb0cacadd3e576eb0f2fc2a75bbbc2841

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
