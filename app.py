import logging

from flask import Flask
from flask.logging import create_logger
from flask import render_template


app = Flask(__name__, template_folder='templates', static_folder='static')
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/")
def home():
    """
    Root endpoint
    """
    LOG.info("Request made to /")
    return render_templates('index.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
