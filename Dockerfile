# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4decc0a7de3d586bbb38307244f32a10f50c96627714ac2785a347a8b63ceeb4 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:308d2fda1d9ad9620454de97cb84fa407bd20e24dd66902909f4b3b44b310836

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
