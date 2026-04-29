
from flask import Flask, request, jsonify, send_from_directory
import os

app = Flask(__name__, static_folder='static')

HISTORY_FILE = "history.txt"

@app.route("/")
def index():
    return send_from_directory("static", "index.html")

@app.route("/save_score", methods=["POST"])
def save_score():
    data = request.get_json()

    name = data.get("name")
    score = data.get("score")
    cause = data.get("cause")
    duration = data.get("duration")

    # validation for score
    if score is None:
        return jsonify({"status": "error"}), 400

    # appending history.txt
    with open(HISTORY_FILE, "a") as f:
        f.write(f"{name} | {score} | {cause} | {duration}\n")

    return jsonify({"status": "saved"})


if __name__ == "__main__":
    app.run(debug=True)

