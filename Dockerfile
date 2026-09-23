# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c9be3f0eab022db93387c863d190b164c259e70dd533bdf9d8d42b87f9559567 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b4f3096df6c0c127dde500e48d9433e33b2496654a814395ce74d6d001bcb851

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
