import logging

from flask import Flask
from flask.logging import create_logger
from flask import render_template


app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/")
def home():
    """
    Root endpoint
    """
    LOG.INFO("Request made to /")
    return render_template('static/index.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
