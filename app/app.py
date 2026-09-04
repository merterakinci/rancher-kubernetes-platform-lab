from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.get("/")
def home():
    return jsonify(
        service="platform-api",
        hostname=socket.gethostname(),
        environment=os.getenv("ENVIRONMENT", "dev"),
        storage=os.getenv("STORAGE_BACKEND", "s3"),
    )

@app.get("/health")
def health():
    return jsonify(status="healthy")

@app.get("/ready")
def ready():
    return jsonify(status="ready")
