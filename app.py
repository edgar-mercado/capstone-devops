import logging

from flask import Flask, request, jsonify
from flask.logging import create_logger

app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)


@app.route("/")
def home():
"""
Root endpoint
"""
    return "<h1>Udacity pipeline test successful</h1>"

if __name__ == "__main__":
    # load pretrained model as clf
    app.run(host='0.0.0.0', port=80, debug=True) # specify port=80
